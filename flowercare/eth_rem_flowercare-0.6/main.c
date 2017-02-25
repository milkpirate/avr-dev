/*********************************************
 * vim:sw=8:ts=8:si:et
 * To use the above modeline in vim you add "set modeline" in your .vimrc
 * Author: Guido Socher
 * Copyright: GPL V2
 * See http://www.gnu.org/licenses/gpl.html
 *
 * Ethernet flower care
 * 
 * See http://tuxgraphics.org/electronics/
 *
 * Chip type           : Atmega168 or Atmega328 with ENC28J60
 *********************************************/
#include <avr/io.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <avr/pgmspace.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include "ip_arp_udp_tcp.h"
#include "enc28j60.h"
#include "timeout.h"
#include "net.h"
#include "websrv_help_functions.h"
#include "onewire.h"
#include "ds18x20.h"
#include "analog.h"

// set output to VCC, red LED off
#define LEDOFF PORTB|=(1<<PORTB1)
// set output to GND, red LED on
#define LEDON PORTB&=~(1<<PORTB1)
// to test the state of the LED
#define LEDISOFF PORTB&(1<<PORTB1)

// please modify the following lines. mac and ip have to be unique
// in your local area network. You can not have the same numbers in
// two devices. The IP address may be changed at run-time but the
// MAC address is hardcoded:
static uint8_t mymac[6] = {0x54,0x55,0x58,0x10,0x00,0x29};
// how did I get the mac addr? Translate the first 3 numbers into ascii is: TUX
//
// The IP of this device (can also be changed at run-time, see README file):
static uint8_t myip[4] = {10,0,0,29};
//static uint8_t myip[4] = {192,168,1,201};
// listen port for tcp/www:
#define MYWWWPORT 80
// the password string (only characters: a-z,0-9,_,.,-,# ), max len 8 char:
static char password[]="secret";
// -------------- do not change anything below this line ----------
// The buffer is the packet size we can handle and its upper limit is
// given by the amount of RAM that the atmega chip has. The page p2.js is 600 bytes long.
#define BUFFER_SIZE 610
static uint8_t buf[BUFFER_SIZE+1];

// global string buffer
#define STR_BUFFER_SIZE 20
static char gStrbuf[STR_BUFFER_SIZE+1];
static uint16_t gPlen;
// if you want to have a page where you can see debug information about the 
// attached sensors then set this to one:
#define DEBUG_SENSORS 0
// uncomment this is you want the graphs in farenheit
//#define GRAPH_IN_F
#define MAXSENSORS 2
static uint8_t gSensorIDs[MAXSENSORS][OW_ROMCODE_SIZE];
static int16_t gTempdata[MAXSENSORS]; // temperature times 10
static int8_t gNsensors=0;
// default values for dry and wet, you can also change this at run time:
static uint8_t gHumiDry=80; // at which value it is dry, led will start to blink
static uint8_t gHumiWet=120; // at which value it is wet, between wet and dry is normal
//
static uint8_t gHumidat=0; // variable for current humidity values
#define HIST_BUFFER_SIZE 64
// how often (in minutes) to record the data to a graph (max value=255 same as gRecMin):
#define TEMP_REC_INTERVAL 240
// position at which the EEPROM is used for storage of temp. data:
#define EEPROM_TEMP_POS_OFFSET 40 
static uint8_t gTemphistnextptr=0;
//
static volatile uint8_t cnt2step=0;
static volatile uint8_t gSec=0;
static volatile uint8_t gMeasurementTimer=0; // sec
static volatile int16_t gRelay_timeout_sec=0; // timeout in sec
static uint8_t gRecMin=0; // miniutes counter for recording of history graphis
static uint8_t gTemp_measurementstatus=0; // 0=ok,1=error
//

// sensor=0..MAXSENSORS-1
int8_t read_dat(uint8_t pos,uint8_t sensor)
{
        return ((int8_t)eeprom_read_byte((uint8_t *)(pos+EEPROM_TEMP_POS_OFFSET+HIST_BUFFER_SIZE*sensor)));
}

// no overflow protection here make sure you stay within the available eeprom size:
void store_dat(int8_t val, uint8_t pos,uint8_t sensor)
{
        eeprom_write_byte((uint8_t *)(pos+EEPROM_TEMP_POS_OFFSET+HIST_BUFFER_SIZE*sensor),val); 
}

void store_humilimits(int8_t dry, uint8_t wet)
{
        eeprom_write_byte((uint8_t *)(0x0),dry); 
        eeprom_write_byte((uint8_t *)(0x1),wet); 
        eeprom_write_byte((uint8_t *)(0x2),3); // magic number
        gHumiWet=wet;
        gHumiDry=dry;
}

// read gHumiDry and gHumiWet if the magic number matches
// otherwise they thake the above compile time values
void read_humilimits(void)
{
        if ((uint8_t)eeprom_read_byte((uint8_t *)0x2) == 3 ){
                gHumiDry=(uint8_t)eeprom_read_byte((uint8_t *)0x0);
                gHumiWet=(uint8_t)eeprom_read_byte((uint8_t *)0x1);
        }
}

// 
uint8_t verify_password(char *str)
{
        // the first characters of the received string are
        // a simple password/cookie:
        if (strncmp(password,str,strlen(password))==0){
                return(1);
        }
        return(0);
}

uint16_t http200ok(void)
{
        return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")));
}

uint16_t http200okjs(void)
{
        return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: application/x-javascript\r\n\r\n")));
}

uint16_t fill_tcp_data_uint(uint8_t *buf,uint16_t plen,uint8_t i)
{
        itoa(i,gStrbuf,10); // convert integer to string
        return(fill_tcp_data(buf,plen,gStrbuf));
}

uint16_t fill_tcp_data_int(uint8_t *buf,uint16_t plen,int8_t i)
{
        itoa(i,gStrbuf,10); // convert integer to string
        return(fill_tcp_data(buf,plen,gStrbuf));
}

uint16_t print_webpage_ok(uint8_t *buf)
{
        uint16_t plen;
        plen=http200ok();
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./>[home]</a>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<h2>OK</h2><hr>\n"));
        return(plen);
}

// writes to global array gSensorIDs
int8_t search_sensors(void)
{
	uint8_t diff;
        uint8_t nSensors=0;
	for( diff = OW_SEARCH_FIRST; 
		diff != OW_LAST_DEVICE && nSensors < MAXSENSORS ; )
	{
		DS18X20_find_sensor( &diff, &(gSensorIDs[nSensors][0]) );
		
		if( diff == OW_PRESENCE_ERR ) {
			return(-1); //No Sensor found
		}
		if( diff == OW_DATA_ERR ) {
			return(-2); //Bus Error
		}
		nSensors++;
	}
	return nSensors;
}

// start a measurement for all sensors on the bus:
void start_temp_meas(void){
        gTemp_measurementstatus=0;
        if ( DS18X20_start_meas(NULL) != DS18X20_OK) {
                gTemp_measurementstatus=1;
        }
}

// convert celsius times 10 values to Farenheit
int8_t c2f(int16_t celsiustimes10){
        return((int8_t)((int16_t)(celsiustimes10 * 18)/100) + 32);
}


// read the latest measurement off the scratchpad of the ds18x20 sensor
// and store it in gTempdata
void read_temp_meas(void){
        uint8_t i;
        uint8_t subzero, cel, cel_frac_bits;
        for ( i=0; i<gNsensors; i++ ) {
        
                if ( DS18X20_read_meas( &gSensorIDs[i][0], &subzero,
                                &cel, &cel_frac_bits) == DS18X20_OK ) {
                        gTempdata[i]=cel*10;
                        gTempdata[i]+=DS18X20_frac_bits_decimal(cel_frac_bits);
                        if (subzero){
                                gTempdata[i]=-gTempdata[i];
                        }
                }else{
                        gTempdata[i]=0;
                }
        }
}

void print_webpage_minmax_level(uint8_t *buf)
{
        gPlen=http200ok();
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("<a href=./>[home]</a>"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("<h2>Humidity level config</h2>\n<pre>\n"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("\n<form action=/ method=get>"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("dry [lower level]:<input type=text name=mi size=4 value="));
        gPlen=fill_tcp_data_uint(buf,gPlen,gHumiDry);
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR(">\n"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("wet [upper level]:<input type=text name=ma size=4 value="));
        gPlen=fill_tcp_data_uint(buf,gPlen,gHumiWet);
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR(">\n"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("password: <input type=password size=10 name=pw>\n"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("<input type=submit value=\"change\"></form>\n"));
        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("</pre><hr>"));
}

uint16_t print_webpage_relay(uint8_t *buf, uint8_t on)
{
        uint16_t plen;
        plen=http200ok();
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./>[home]</a> <a href=./?sw=1>[refresh]</a>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<h2>water pump</h2>\n<pre>state: "));
        if (on){
                plen=fill_tcp_data_p(buf,plen,PSTR("<font color=#00FF00>ON</font>"));
                if (gRelay_timeout_sec>0){
                        plen=fill_tcp_data_p(buf,plen,PSTR(" [for "));
                        // gRelay_timeout_min is 16bit we do not use fill_tcp_data_int
                        itoa(gRelay_timeout_sec,gStrbuf,10); // convert integer to string
                        plen=fill_tcp_data(buf,plen,gStrbuf);
                        plen=fill_tcp_data_p(buf,plen,PSTR(" more sec]"));
                }
        }else{
                plen=fill_tcp_data_p(buf,plen,PSTR("OFF"));
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("\n<form action=/ method=get>"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<input type=hidden name=sc value="));
        if (on){
                plen=fill_tcp_data_p(buf,plen,PSTR("0>\npassw: <input type=password size=10 name=pw>"));
                plen=fill_tcp_data_p(buf,plen,PSTR("<input type=submit value=\"switch off\"></form>\n"));
        }else{
                plen=fill_tcp_data_p(buf,plen,PSTR("1>\nOn for <input type=text name=tm value=0 size=3> sec\n\n"));
                plen=fill_tcp_data_p(buf,plen,PSTR("passw: <input type=password size=10 name=pw>"));
                plen=fill_tcp_data_p(buf,plen,PSTR("<input type=submit value=\"switch on\"></form>\n"));
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("</pre><hr>tuxgraphics"));
        return(plen);
}

// p1.js
uint16_t print_p1_js(uint8_t *buf)
{
        uint16_t plen;
        plen=http200okjs();
        plen=fill_tcp_data_p(buf,plen,PSTR("\
function pad(n){\n\
var s=n.toString(10);\n\
if (s.length<2){return(\"0\"+s)}\n\
return(s);\n\
}\n\
\n\
function dw(s){document.write(s+\"\\n\")}\n\
\n\
function pbar(w,c,t){\n\
dw(\"<p style=\\\"width:\"+w+\"px;background-color:#\"+c+\";margin:2px;border:1px #999 solid;white-space:pre;\\\">\"+t+\"</p>\");\n\
}\n\
"));
        return(plen);
}

// p2.js
uint16_t print_p2_js(uint8_t *buf)
{
        uint16_t plen;
        plen=http200okjs();
        // gd = graphdata array
        // c = color
        // a = amplification factor
        // h = heading
        // m = minutes since last data
        // d = recording interval in min
        plen=fill_tcp_data_p(buf,plen,PSTR("\
function bpt(gd,c,a,h,m,d){\n\
var t = new Date();\n\
var tz = (new Date()).getTimezoneOffset() / 60;\n\
dw(\"<h2>\"+h+\"</h2><small>\");\n\
var n,ms,pt,dd,hh,mm,s;\n\
ms= t.getTime();\n\
for(var i=0;i<gd.length;i++){\n\
 pt=ms-((m+d*i)*60*1000);\n\
 t.setTime(pt);\n\
 dd=pad(t.getDate());\n\
 hh=pad(t.getHours());\n\
 mm=pad(t.getMinutes());\n\
 n=parseInt(gd[i]);\n\
 pbar((a*n+100),c,dd+\"-\"+hh+\":\"+mm+\"=\"+n);\n\
}\n\
dw(\"<br>Time diff to GMT: \"+tz+\" hours. Format: day-hh:mm=val</small>\");\n\
}\n\
"));
        return(plen);
}

// sensor = 0 or 1
uint16_t print_webpage_graph_array(uint8_t *buf,uint8_t sensor)
{
        int8_t i;
        uint8_t nptr;
        uint16_t plen;
        plen=http200okjs();
        nptr=gTemphistnextptr; // gTemphistnextptr may change so we make a snapshot here
        i=nptr;
        plen=fill_tcp_data_p(buf,plen,PSTR("gdat"));
        plen=fill_tcp_data_int(buf,plen,sensor);
        plen=fill_tcp_data_p(buf,plen,PSTR("=Array("));
        if (!eeprom_is_ready()){
                // don't sit and wait 
                plen=fill_tcp_data_p(buf,plen,PSTR("0);\n"));
                return(plen);
        }
        while(1){
                if (i!=nptr){ // not first time
                        plen=fill_tcp_data_p(buf,plen,PSTR(","));
                }
                i--;
                if (i<0){
                        i=HIST_BUFFER_SIZE-1;
                }
                if (sensor==0){ // temperature
#ifdef GRAPH_IN_F
                        plen=fill_tcp_data_int(buf,plen,c2f(read_dat(i,0)*10));
#else
                        plen=fill_tcp_data_int(buf,plen,read_dat(i,0));
#endif
                }else{
                        plen=fill_tcp_data_uint(buf,plen,read_dat(i,sensor));
                }
                if (i==nptr){
                        break; // end loop
                }
        }
        plen=fill_tcp_data_p(buf,plen,PSTR(");\n"));
        return(plen);
}

uint16_t print_webpage_graph(uint8_t *buf)
{
        uint16_t plen;
        plen=http200ok();
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./>[home]</a>"));
        plen=fill_tcp_data_p(buf,plen,PSTR("\n<script src=p1.js></script>\n<script src=p2.js></script>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<script src=gdat0.js></script>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<script src=gdat1.js></script>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<table border=1 cellpadding=3><tr><td><script>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("bpt(gdat0,\"eb0\",3,\"Temperature\","));
        plen=fill_tcp_data_uint(buf,plen,gRecMin);
        plen=fill_tcp_data_p(buf,plen,PSTR(","));
        plen=fill_tcp_data_uint(buf,plen,TEMP_REC_INTERVAL);
        plen=fill_tcp_data_p(buf,plen,PSTR(");\n</script></td><td><script>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("bpt(gdat1,\"ac2\",1.2,\"Humidity\","));
        plen=fill_tcp_data_uint(buf,plen,gRecMin);
        plen=fill_tcp_data_p(buf,plen,PSTR(","));
        plen=fill_tcp_data_uint(buf,plen,TEMP_REC_INTERVAL);
        plen=fill_tcp_data_p(buf,plen,PSTR(");\n</script></td></tr></table>\n<br><hr>\n"));
        return(plen);
}

uint16_t print_webpage_sensoronly(uint8_t *buf,uint8_t num,uint8_t farenh)
{
        uint16_t plen;
        plen=http200ok();
        if (num<gNsensors){
                if (farenh==0){
                        plen=fill_tcp_data_int(buf,plen,gTempdata[num]/10);
                        plen=fill_tcp_data_p(buf,plen,PSTR("."));
                        plen=fill_tcp_data_int(buf,plen,abs(gTempdata[num])%10);
                }else{
                        plen=fill_tcp_data_int(buf,plen,c2f(gTempdata[num]));
                }
                plen=fill_tcp_data_p(buf,plen,PSTR("\n"));
        }else{
                plen=fill_tcp_data_p(buf,plen,PSTR("err\n"));
        }
        return(plen);
}

// this the top level main web page
uint16_t print_webpage_sensordetails(uint8_t *buf)
{
        int8_t i;
        uint16_t plen;
        plen=http200ok();
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./?sw=1>[water]</a> <a href=./?g=0>[graph]</a> <a href=./?mm=1>[levels]</a> "));
        if (DEBUG_SENSORS==1){
                plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./?ds=1>[dbg sensor]</a>"));
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./>[refresh]</a>\n<h2>Sensors</h2>"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<pre>"));
        if (gNsensors==0){
                plen=fill_tcp_data_p(buf,plen,PSTR("No temp. sensor found\n"));
        }
        for ( i=0; i<gNsensors; i++ ) {
                plen=fill_tcp_data_p(buf,plen,PSTR("Temperature:<a href=./?ts="));
                plen=fill_tcp_data_int(buf,plen,i);
                plen=fill_tcp_data_p(buf,plen,PSTR(">"));
                plen=fill_tcp_data_int(buf,plen,gTempdata[i]/10);
                plen=fill_tcp_data_p(buf,plen,PSTR("."));
                plen=fill_tcp_data_int(buf,plen,abs(gTempdata[i])%10);
                plen=fill_tcp_data_p(buf,plen,PSTR("</a>'C ["));
                plen=fill_tcp_data_int(buf,plen,c2f(gTempdata[i]));
                plen=fill_tcp_data_p(buf,plen,PSTR("'F]\n"));
        }
        if (gTemp_measurementstatus==1){
                plen=fill_tcp_data_p(buf,plen,PSTR("warning: sensor error\n"));
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("Humi level: <a href=./?hs=0>"));
        plen=fill_tcp_data_uint(buf,plen,gHumidat);
        plen=fill_tcp_data_p(buf,plen,PSTR("</a>"));
        if (gHumidat>gHumiWet){
                plen=fill_tcp_data_p(buf,plen,PSTR(" [wet]"));
        }else{
                if (gHumidat<gHumiDry){
                        plen=fill_tcp_data_p(buf,plen,PSTR(" [dry]"));
                }else{
                        plen=fill_tcp_data_p(buf,plen,PSTR(" [normal]"));
                }
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("\n</pre><hr>&copy; tuxgraphics\n"));
        return(plen);
}

#if (DEBUG_SENSORS==1)
// debug information, read sensor data at the moment when
// showing this page
uint16_t print_webpage_sensordetails_dbg(uint8_t *buf)
{
        uint16_t plen;
        uint8_t subzero, cel, cel_frac_bits;
        int8_t i,j;
        uint8_t sp[DS18X20_SP_SIZE];
        plen=http200ok();
        plen=fill_tcp_data_p(buf,plen,PSTR("<a href=./>[home]</a> <a href=./?ds=1&pw="));
        urlencode(password,gStrbuf);
        plen=fill_tcp_data(buf,plen,gStrbuf);
        plen=fill_tcp_data_p(buf,plen,PSTR(">[refresh]</a>\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<h2>1wire sensors</h2>"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<pre>"));
        if (gNsensors==-1){
                plen=fill_tcp_data_p(buf,plen,PSTR("no sensor found"));
                goto EOSENSOR;
        }
        if (gNsensors==-2){
                plen=fill_tcp_data_p(buf,plen,PSTR("OW_DATA_ERR"));
                goto EOSENSOR;
        }
        if (gNsensors>0){
                plen=fill_tcp_data_p(buf,plen,PSTR("Num. of sens:"));
                plen=fill_tcp_data_int(buf,plen,gNsensors);
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("\n"));
        for (i=0; i<gNsensors; i++) {
                plen=fill_tcp_data_p(buf,plen,PSTR("sensor:"));
                plen=fill_tcp_data_int(buf,plen,i);
                plen=fill_tcp_data_p(buf,plen,PSTR(" "));
                plen=DS18X20_show_id_print_buf( &gSensorIDs[i][0], plen,buf);
                plen=fill_tcp_data_p(buf,plen,PSTR("\n"));
        }
        if (gTemp_measurementstatus==1){
                plen=fill_tcp_data_p(buf,plen,PSTR("DS18X20_start_meas failed!\n"));
        }
        // The measurement is started from the main program. This will just read the
        // Data off the scratch pad of the sensors.
        for ( i=0; i<gNsensors; i++ ) {
                plen=fill_tcp_data_p(buf,plen,PSTR("sensor:"));
                plen=fill_tcp_data_int(buf,plen,i);
                plen=fill_tcp_data_p(buf,plen,PSTR(" "));
                // show the raw scratchpad (temperature info is stored there):
                if (DS18X20_read_scratchpad(&gSensorIDs[i][0],sp)==DS18X20_OK){
                        plen=fill_tcp_data_p(buf,plen,PSTR("SP:"));
                        for ( j=0 ; j< DS18X20_SP_SIZE; j++ ){
                                if (j>0)plen=fill_tcp_data_p(buf,plen,PSTR(":"));
                                plen=fill_tcp_data_uint(buf,plen,sp[j]);
                        }
                }
                plen=fill_tcp_data_p(buf,plen,PSTR(" "));
                if ( DS18X20_read_meas( &gSensorIDs[i][0], &subzero,
                                &cel, &cel_frac_bits) == DS18X20_OK ) {
                        // display temp
                        if (subzero){
                                plen=fill_tcp_data_p(buf,plen,PSTR("-"));
                        }else{
                                plen=fill_tcp_data_p(buf,plen,PSTR("+"));
                        }
                        plen=fill_tcp_data_int(buf,plen,cel);
                        plen=fill_tcp_data_p(buf,plen,PSTR("."));
                        plen=fill_tcp_data_int(buf,plen,DS18X20_frac_bits_decimal(cel_frac_bits));
                        plen=fill_tcp_data_p(buf,plen,PSTR("'C"));
                } else {
                        plen=fill_tcp_data_p(buf,plen,PSTR("ERR: CRC/connection"));
                }
                plen=fill_tcp_data_p(buf,plen,PSTR("\n"));
        }
EOSENSOR:

        plen=fill_tcp_data_p(buf,plen,PSTR("\nSensors are searched at power-on only.\n<hr>tuxgraphics"));
        return(plen);
}
#endif

// takes a string of the form command/Number and analyse it (e.g "?sw=pd7&a=1 HTTP/1.1")
// The first char of the url ('/') is already removed.
int8_t analyse_get_url(char *str)
{
        uint8_t i;
        uint8_t j;
        if (str[0]==' '){
                return(1); // end of url, main page
        }
        // --------
        if (strncmp("favicon.ico",str,11)==0){
                gPlen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 301 Moved Permanently\r\nLocation: "));
                gPlen=fill_tcp_data_p(buf,gPlen,PSTR("http://tuxgraphics.org/ico/d.ico"));
                gPlen=fill_tcp_data_p(buf,gPlen,PSTR("\r\n\r\nContent-Type: text/html\r\n\r\n"));
                gPlen=fill_tcp_data_p(buf,gPlen,PSTR("<h1>301 Moved Permanently</h1>\n"));
                return(10);
        }
        // --------
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"mm")){
                print_webpage_minmax_level(buf);
                return(10);
        }
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ma")){
                i=atoi(gStrbuf);
                if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"mi")){
                        j=atoi(gStrbuf);
                        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"pw")){
                                urldecode(gStrbuf);
                                if (verify_password(gStrbuf)){
                                        if (j<i){
                                                store_humilimits(j,i);
                                                return(2); // ok
                                        }
                                        gPlen=http200ok();
                                        gPlen=fill_tcp_data_p(buf,gPlen,PSTR("<pre>ERROR\nConditions are: 0&lt;dry&lt;wet&lt;255\n"));
                                        return(10);
                                }
                                return(-1); // Unauthorized
                        }
                }
                return(0); // not found
        }
        // --------
        // set the seconds for the relay to be on
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"sc")){
                if (gStrbuf[0]=='1'){
                        i=1;
                }
                if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"pw")){
                        urldecode(gStrbuf);
                        if (verify_password(gStrbuf)){
                                if (i){
                                        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"tm")){
                                                urldecode(gStrbuf);
                                                gRelay_timeout_sec=atoi(gStrbuf);
                                                if (gRelay_timeout_sec < 2 ){
                                                        gRelay_timeout_sec=2;
                                                }
                                                PORTD|= (1<<PORTD7);// transistor on
                                        }

                                }else{
                                        PORTD &= ~(1<<PORTD7);// transistor off
                                        gRelay_timeout_sec=0;
                                }
                                return(2);
                        }
                }
                return(-1);
        }
        //
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"sw")){
                i=0;
                // state of the transistor/relay
                if (PORTD&(1<<PORTD7)){
                        i=1;
                }
                gPlen=print_webpage_relay(buf,i);
                return(10);
        }
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ts")){
                gStrbuf[1]='\0';
                j=atoi(gStrbuf);
                i=0;
                if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"f")){
                        i=1;
                }
                // gStrbuf[0] contains the number of the sensor
                gPlen=print_webpage_sensoronly(buf,j,i);
                return(10);
        }
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"hs")){
                gPlen=http200ok();
                gPlen=fill_tcp_data_uint(buf,gPlen,gHumidat);
                gPlen=fill_tcp_data_p(buf,gPlen,PSTR("\n"));
                return(10);
        }
        if (strncmp("p1.js",str,5)==0){
                gPlen=print_p1_js(buf);
                return(10);
        }
        if (strncmp("p2.js",str,5)==0){
                gPlen=print_p2_js(buf);
                return(10);
        }
#if (DEBUG_SENSORS==1)
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ds")){
                return(6);
        }
#endif
        if (find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"g")){
                gPlen=print_webpage_graph(buf);
                return(10);
        }
        if (strncmp("gdat",str,4)==0){
                if (strncmp("0.js",(str+4),4)==0){
                        gPlen=print_webpage_graph_array(buf,0);
                        return(10);
                }
                if (strncmp("1.js",(str+4),4)==0){
                        gPlen=print_webpage_graph_array(buf,1);
                        return(10);
                }
        }
        return(0);
}

// called when TCNT2==OCR2A
// that is in 50Hz intervals
// This is used as a "clock" to store the data
ISR(TIMER2_COMPA_vect){
        cnt2step++;
        if (cnt2step>49){ 
                gSec++;
                gMeasurementTimer++;
                if (gRelay_timeout_sec>0){
                        gRelay_timeout_sec--;
                        if (gRelay_timeout_sec==0){
                                PORTD &= ~(1<<PORTD7);// transistor off
                        }
                }
                cnt2step=0;
        }
}

/* setup timer0 (T0) as a tone generator on pin OC0B (=PD5)
* You must call once sei() in the main program */
void init_cnt0(void)
{
        DDRD|= (1<<DDD5); // enable PD5 as output
        PRR&=~(1<<PRTIM0); // write power reduction register to zero
        TIMSK0=0; // do not generate any interrupt
        TCNT0=0;  // init counter
        OCR0A=5; // value to compare against ( divide by OCR0A +1)
        TCCR0A=(1<<COM0B0)|(1<<WGM01); // toggle output OC0B, clear at compare match
        // divide clock by 256: 12.5MHz/256=48828.125 Hz
        TCCR0B=(1<<CS02); // clock divider, start counter
        // 48828.125 / (5+1) / 2= 4069 Hz
}

/* setup timer T2 as an interrupt generating time base.
* You must call once sei() in the main program */
void init_cnt2(void)
{
        cnt2step=0;
        PRR&=~(1<<PRTIM2); // write power reduction register to zero
        TIMSK2=(1<<OCIE2A); // compare match on OCR2A
        TCNT2=0;  // init counter
        OCR2A=244; // value to compare against
        TCCR2A=(1<<WGM21); // do not change any output pin, clear at compare match
        // divide clock by 1024: 12.5MHz/1024=12207.0313 Hz
        TCCR2B=(1<<CS22)|(1<<CS21)|(1<<CS20); // clock divider, start counter
        // 12207.0313 / 244= 50.0288
}

// called every minute but data is only stored at TEMP_REC_INTERVAL:
void store_graph_dat(void){
        if (gRecMin==0){
                // round up to full 'C:
                store_dat((5+gTempdata[0])/10,gTemphistnextptr,0);
                // store humidity
                store_dat(gHumidat,gTemphistnextptr,1);
                gTemphistnextptr++;
                gTemphistnextptr=gTemphistnextptr%HIST_BUFFER_SIZE;
        }
        gRecMin++;
        // You can calibrate the clock here a bit:
        // our clock is a bit behind. Compensate it every 20 min:
        if (gRecMin==20){
                gSec+=25; // sec is around 0 when this function is called, advance clock
        }
        if (gRecMin==TEMP_REC_INTERVAL){
                gRecMin=0;
        }
}

int main(void){

        uint16_t dat_p;
        int8_t i,firstsample=1;
        static int8_t state=0;
        // set the clock speed to "no pre-scaler" (8MHz with internal osc or 
        // full external speed)
        // set the clock prescaler. First write CLKPCE to enable setting of clock the
        // next four instructions.
        CLKPR=(1<<CLKPCE); // change enable
        CLKPR=0; // "no pre-scaler"
        _delay_loop_1(0); // 60us

        /*initialize enc28j60*/
        enc28j60Init(mymac);
        enc28j60clkout(2); // change clkout from 6.25MHz to 12.5MHz
        _delay_loop_1(0); // 60us
        //
        // time keeping
        init_cnt2();
        // frequency output on PD5 (OC0B)
        init_cnt0();
        sei();
        // LED
        DDRB|= (1<<DDB1); // enable PB1, LED as output
        LEDOFF;

        // the transistor on PD7 (relay)
        DDRD|= (1<<DDD7);
        PORTD &= ~(1<<PORTD7);// transistor off
        // initialize the adc to use Vcc=3.3V as ref
        adc_ref_pin_init();
        /* Magjack leds configuration, see enc28j60 datasheet, page 11 */
        // LEDB=yellow LEDA=green
        //
        // 0x476 is PHLCON LEDA=links status, LEDB=receive/transmit
        // enc28j60PhyWrite(PHLCON,0b0000 0100 0111 01 10);
        enc28j60PhyWrite(PHLCON,0x476);
        // read limits from eeprom if stored:
        read_humilimits();
        //init the ethernet/ip layer:
        init_ip_arp_udp_tcp(mymac,myip,MYWWWPORT);

        // initialize:
        i=0;
        while(i<HIST_BUFFER_SIZE){
                store_dat(0,i,0);
                store_dat(0,i,1);
                i++;
        }
        gNsensors=search_sensors();
        // initialize gTempdata in case somebody reads the web page immediately after reboot
        i=0;
        while(i<MAXSENSORS){
                gTempdata[i]=0;
                i++;
        }
        if (gNsensors>0){
                start_temp_meas();
        }
        // initial reading, PD5 is already producing a tone.
        gHumidat=convertanalog8(0);

        while(1){
                // handle ping and wait for a tcp packet:
                gPlen=enc28j60PacketReceive(BUFFER_SIZE, buf);
                dat_p=packetloop_icmp_tcp(buf,gPlen);

                // dat_p will be unequal to zero if there is a valid http get 
                if(dat_p==0){
                        // we need at least 750ms time between 
                        // start of measurement and reading
                        if (gMeasurementTimer==2 && state==0){ 
                                if (gHumidat<gHumiDry){
                                        // blink red led if dry:
                                        LEDON;
                                }
                                read_temp_meas();
                                DDRD|= (1<<DDD5); // enable PD5 as output, tone output
                                state=1;
                                if (firstsample==1){
                                        firstsample=0;
                                        store_graph_dat();
                                }
                        }
                        if (gMeasurementTimer==3 && state==1){ 
                                if (DDRD&(1<<DDD5)){
                                        gHumidat=convertanalog8(0);
                                        DDRD&= ~(1<<DDD5); // disable PD5 as output, no tone output
                                }
                                start_temp_meas();
                                state=2;
                        }
                        if (gMeasurementTimer==5){ // every 5 sec new measurement:
                                LEDOFF;
                                gMeasurementTimer=0;
                                state=0;
                        }
                        if (gSec>59){
                                gSec=0;
                                store_graph_dat();
                        }
                        continue; // go to while(1)
                }
                if (strncmp("GET ",(char *)&(buf[dat_p]),4)!=0){
                        // head, post and other methods:
                        //
                        // for possible status codes see:
                        // http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
                        gPlen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>200 OK</h1>"));
                        goto SENDTCP;
                }
                // Cut the size for security reasons. If we are almost at the 
                // end of the buffer then there is a zero but normally there is
                // a lot of room and we can cut down the processing time as 
                // correct URLs should be short in our case:
                if ((dat_p+5+40) < BUFFER_SIZE){
                        buf[dat_p+5+40]='\0';
                }
                // analyse the url and do possible port changes:
                // move one char ahead:
                i=analyse_get_url((char *)&(buf[dat_p+5]));
                // for possible status codes see:
                // http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
                if (i==-1){
                        gPlen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 401 Unauthorized\r\nContent-Type: text/html\r\n\r\n<h1>401 Unauthorized</h1><a href=/>continue</a>\n"));
                        goto SENDTCP;
                }
                if (i==0){
                        gPlen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 404 Not Found\r\nContent-Type: text/html\r\n\r\n<h1>404 Not Found</h1>"));
                        goto SENDTCP;
                }
                if (i==2){
                        gPlen=print_webpage_ok(buf);
                        goto SENDTCP;
                }
#if (DEBUG_SENSORS==1)
                if (i==6){
                        gPlen=print_webpage_sensordetails_dbg(buf);
                        goto SENDTCP;
                }
#endif
                if (i==10){
                        goto SENDTCP;
                }
                // just display the status:
                // normally i==1
                gPlen=print_webpage_sensordetails(buf);
                //
SENDTCP:
                www_server_reply(buf,gPlen); // send web page data
                // tcp port www end
                //
        }
        return (0);
}
