import struct

def u32(x): return struct.unpack('<L', x)[0]

class MFT:
	attributeStart = 0x038

	def __init__(self, data):
		signature					= data[0x000:0x004]
		offsetToFixupArray			= data[0x004:0x006]
		numberOfFixupBytePairs		= data[0x006:0x008]
		logfileSequenceNumber		= data[0x008:0x010]
		sequenceNumber				= data[0x010:0x012]
		hardLinkCount				= data[0x012:0x014]
		offsetToFirstAttribute		= data[0x014:0x016]
		headerFlags					= data[0x016:0x018]
		actualRecordSize			= data[0x018:0x01C]
		allocateRecordSize			= data[0x01C:0x020]
		fileReferenceToBaseRecord	= data[0x020:0x028]
		nextAvaliableAttributeId	= data[0x028:0x02A]
		unknown						= data[0x02A:0x02C]
		entryNumber					= data[0x02C:0x030]
		fixupExpected				= data[0x030:0x032]
		fixupActual0				= data[0x032:0x034]
		fixupActual1				= data[0x034:0x036]
		padding						= data[0x036:0x038]

		start = self.attributeStart
		while u32(data[start:start+4]) != 0xFFFFFFFF:
			attributeType,size = u32(data[start:start+4]),u32(data[start+4:start+8])
			block = data[start:start+size]
			if   attributeType == 0x10: aStandardInformation= block
			elif attributeType == 0x20: aAttributeList		= block
			elif attributeType == 0x30: aFileName			= block
			elif attributeType == 0x40: aObjectId			= block
			elif attributeType == 0x60: aVolumeName			= block
			elif attributeType == 0x70: aVolumeInformation	= block
			elif attributeType == 0x80:
				if 'aData' in locals(): aData.append(block)
				else: aData = [block]
			elif attributeType == 0x90: aIndexRoot			= block
			elif attributeType == 0xA0: aIndexAllocation	= block
			elif attributeType == 0xB0: aBitmap				= block
			elif attributeType == 0xC0: aReparsePoint		= block
			else: break
			start += size

		if 'aFileName' in locals(): self.fileName = self.getFileName(aFileName)
		else: self.fileName = "noName"
		# if 'aData' in locals(): self.aData = aData

	# attributeType == 0x30
	def getFileName(self, aFileName):
		try: fileName = aFileName[0x5A:0x5A + aFileName[0x58] * 2].decode('utf-16')
		except: fileName = "noName"
		if not fileName[0].isprintable(): fileName = "noName"
		return fileName

	# attributeType == 0x80
	def getData(self):
		if 'aData' in self.__dict__: return self.aData


if __name__ == "__main__":
	with open("$MFT","rb") as mft:
		count,FILE = 0,mft.read(0x400)
		while FILE:
			file = MFT(FILE)
			print("%02d %s" % (count, file.__dict__))
			count,FILE = count+1,mft.read(0x400)


# [MFT Attribute Entry](https://docs.microsoft.com/en-us/windows/win32/devnotes/attribute-list-entry)
