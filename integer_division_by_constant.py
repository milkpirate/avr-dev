import math

print "Magic Numbers For Integer Division By Constants\n"

print "Computes the magic number and the exponent for unsinged"
print "integer devision by multiplying with a constant (and right"
print "shifting afterwards)\n"

print " q =  n / d"
print " q ~ (n * m) >> p\n"

print "maximal n (divident):",
n = int(input())

print "devisor d:           ",
d = int(input())

def magicnum(nmax, d):
    if (d == 0):             # check if d is zero
        return "division by zero is not allowed!"
    
    if ((d & (d - 1)) == 0): # check if d is a power of 2
        p = -1
        while(d):
            d >>= 1
            p += 1
        return (1, p)        # return #shifts
    
    nc = (nmax // d) * d - 1
    nbits = int(math.log(nmax, 2)) + 1
    
    for p in range(0, 2 * nbits + 1):
        if 2**p > nc * (d - 1 - (2**p - 1)%d):
            m = (2**p + d - 1 - (2**p - 1)%d)//d
            return (m, p)
        
    print "can't find p, something is wrong."

print "\nmagic numbers: (m, p) =", magicnum(n,d)