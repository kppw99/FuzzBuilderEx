import struct

filename = 'bak.jpg'

endian = 0 # {'0':'big', '1':'little'}

def byt2int(byt):
	if not endian: return big2int(byt)
	else: return lit2int(byt)


def big2int(byt):
	result = 0
	for b in byt: result = result * 0x100 + int(b)
	return result #struct.unpack('>h', byt)[0]


def lit2int(byt):
	tmp = bytearray(byt)
	tmp.reverse()
	return struct.unpack('<h', bytes(tmp))[0]


def app0():
	app_len = jpg.read(2)
	jpg.seek(big2int(app_len)-2,1)
	if jpg.read(2) == b'\xff\xe1': app1()


def app1():
	global endian
	jpg.seek(0x8,1)
	base = jpg.tell()
	if jpg.read(0x2) == b'II': endian = 1
	jpg.seek(0x6,1)
	tag_num = byt2int(jpg.read(2))
	for i in range(tag_num):
		tag = jpg.read(2)
		print(tag)
		if big2int(tag) == 306:
			jpg.seek(0x6,1)
			print(jpg.tell())
			if not endian: jpg.seek(2,1)
			jpg.seek(base + byt2int(jpg.read(2)),0)
			name = jpg.read(0x13)
			print(str(name).replace(':','').replace(' ','_'))
			exit(1)
		else: jpg.seek(0xa,1)
		

with open(filename, 'rb') as jpg:
	SOIMarker = jpg.read(2)
	if SOIMarker == b'\xff\xd8':
		app_num = jpg.read(2)
		if app_num == b'\xff\xe0': app0()
		elif app_num == b'\xff\xe1' : app1()
