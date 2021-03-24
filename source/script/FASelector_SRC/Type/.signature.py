import sys

OOXML = bytearray(b"\x50\x4B\x03\x04\x14\x00\x06\x00")
DOCX = "word/"
PPTX = "ppt/"
XLSX = "xl/"

with open(sys.argv[1], 'rb') as f:
	header = f.read(512)
	if OOXML == header[0:len(OOXML)]:
		print("OOXML")
	else:
		print("UNKNOWN")