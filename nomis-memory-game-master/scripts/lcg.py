import random
seed = random.randint(0,0xFFFF)
lcg = seed
a = 257
m = 32768
print lcg
print
period = 0

while (period < 100):
	lcg = (a * lcg + 1) % m
	print bin(lcg)
	print bin(lcg >> 13)
	print lcg >> 13,
	period += 1

print
print
print period
