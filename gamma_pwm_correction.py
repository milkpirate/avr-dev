from sys import stdout,exit

def disp_val(val):
    if (w >= 10000) and (val < 10000):      stdout.write(" ")
    if (w >= 1000)  and (val < 1000):       stdout.write(" ")
    if (w >= 100)   and (val < 100):        stdout.write(" ")
    if val < 10:                            stdout.write(" ")
    stdout.write(str(val))

def clean_exit():
    print("\nPress enter to exit.")
    raw_input()

def error_page():
    print("\nEntered value is invalid!")
    exit(Wrong_Input)

print("Gamma correction value calculater for LED PWM\n")

s = int(raw_input("Array size:\t\t\t\t"))
if s < 1: error_page()

w = int(raw_input("Total PWM steps:\t\t\t"))
if w < 1: error_page()

g = raw_input("Gamma correction (default: 2.5):\t")
if g == "": g = 2.5
try:        g = float(g)
except:     error_page()

l = str(raw_input("Language (a=Asm, c=C/C++):\t\t"))
if (len(l) > 1) or not l.isalpha(): error_page()

c = int(raw_input("Columns:\t\t\t\t"))
if c < 1:   error_page()

##g = 4
##w = 256
##s = 64
##c = 8
##l = 'c'

g = float(g)
l = l.lower()
w -= 1

if l == "a":
    print("")
    if w > 255:
        print(";-----------------------------------------------")
        print("; pwm gamma correction")
        print("; %d words flash used" %s                        )
        print("; (= %d bytes)"        %(2*s)                    )
        print(";-----------------------------------------------")
        print("pwm_gamma:")
        
        for i in range(1, s):
            val = int(w*((float(i)/s)**g)+0.5)
            if i%c == 0:
                disp_val(val)
                stdout.write("\n")
            elif (i-1)%c == 0:
                stdout.write("  .dw ")
                disp_val(val)
                stdout.write(", ")
            else:
                disp_val(val)
                stdout.write(", ")
        disp_val(w)
##        print(";-----------------------------------------------")
##        print("; pwm gamma correction")
##        print("; %d words flash used" %(2*s)                    )
##        print("; (= %d bytes)"        %(4*s)                    )
##        print(";-----------------------------------------------")
##        print("pwm_gamma:")
##
##        c >>= 1     ## c /= 2
##
##        for i in range(1, s):
##            val = (int)(w * pow( float(i)/s, g ) + 0.5)
##            val_hnib = val >> 8
##            val_lnib = val & 0xFF
##            if i%c == 0:
##                disp_val(val_hnib)
##                stdout.write(", ")
##                disp_val(val_lnib)
##                stdout.write("\n")
##            elif (i-1)%c == 0:
##                stdout.write("  .db ")
##                disp_val(val_hnib)
##                stdout.write(", ")
##                disp_val(val_lnib)
##                stdout.write(", ")
##            else:
##                disp_val(val_hnib)
##                stdout.write(", ")
##                disp_val(val_lnib)
##                stdout.write(", ")
##
##        val_hnib = w >> 8
##        val_lnib = w & 0xFF
##        
##        disp_val(val_hnib)
##        stdout.write(", ")
##        disp_val(val_lnib)
    else:
        num_words = s/2 + s%2
        num_bytes = 2*num_words
        print(";-----------------------------------------------")
        print("; pwm gamma correction")
        print("; %d words flash used" %num_words)
        print("; (= %d bytes)"        %num_bytes)
        print(";-----------------------------------------------")
        print("pwm_gamma:")
        
        for i in range(1, s):
            val = (int)(w*(float(i)/s)**g + 0.5)
            if i%c == 0:
                disp_val(val)
                stdout.write("\n")
            elif (i-1)%c == 0:
                stdout.write("  .db ")
                disp_val(val)
                stdout.write(", ")
            else:
                disp_val(val)
                stdout.write(", ")
        if s%c == 1: stdout.write("  .db ")
        disp_val(w)
    clean_exit()
elif l == "c":
    if w > 255:
        print("\nconst uint16_t pwm_gamma[%d] = {\n\t" %s),
    else:
        print("\nconst uint8_t pwm_gamma[%d] = {\n\t" %s),

    for i in range(1, s):
        ##val = int(w*(2**(float(i)/s)-1)+0.5)
        val = int(w*((float(i)/s)**g)+0.5)
        if i%c == 0:
            disp_val(val)
            stdout.write(",\n\t"),
        else:
            disp_val(val)
            stdout.write(",")
    disp_val(w)
    stdout.write("};\n")
    clean_exit()
else:
    error_page()
