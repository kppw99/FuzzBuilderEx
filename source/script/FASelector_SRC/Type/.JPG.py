#-*- coding:utf-8 -*-

import os
import re

class folder():
	def __init__(self,path):
		self.path = path
		if path[-1] != '/':
			self.path += '/'
		self.filelist = []

		self.get_filelist()

	def get_filelist(self):
		tmp = os.listdir(self.path)
		for test in tmp:
			test = self.path + test
			if os.path.isfile(test):
				self.filelist.append(test)
		print 'There are %d files in "%s" folder.' %(len(self.filelist), self.path)


class file():
	def __init__(self,filename):
		self.filename = filename
		with open(filename,'r') as f:
			self.raw_data = f.read()
		self.hex_data = self.raw_data.encode('hex')
		self.SOIMARKER = self.get_OIMARKER('\xff\xd8')
		self.EOIMARKER = self.get_OIMARKER('\xff\xd9')

	def check_OI(self):
		len_SOI = len(re.findall('\xff\xd8',self.raw_data))
		len_EOI = len(re.findall('\xff\xd9',self.raw_data))
		print "=" * 0x34
		print "'%s' has %d SOIMARKER & %d EOIMARKER" %(self.filename, len_SOI, len_EOI)
		return len_SOI

	def get_OIMARKER(self,sig):
		markers = []
		OIMARKER = re.finditer(sig,self.raw_data)
		for i in OIMARKER: markers.append(i.start())
		return markers


if __name__ == "__main__":
	import sys
	#path = './pictures/'
	#folder = folder(path)
	folder = folder(sys.argv[1])
	path, filelist = folder.path, folder.filelist
	markers = ['ffc','ffd','ffe','fff']
	JPG = []
	if not os.path.isdir('output'):
		os.makedirs('output/')
	for filename in filelist:
		pic = file(filename)
		output = filename.split('/')[-1].split('.')[0]
		if pic.check_OI():
			with open('output/%s.txt' % output,'w') as txt:
				fd = pic.SOIMARKER[0]
				txt.write("%s => %s\n" %(pic.raw_data[fd:fd+2].encode('hex'), hex(fd)))

				start, end = fd * 2 + 4, fd * 2 + 8
				while pic.hex_data[start:end-1] in markers:
					marker = pic.hex_data[start:end]
					txt.write("%s => %s\n" %(marker, hex(start/2)))
					start, end = start + 4, end + 4
					index = int(pic.hex_data[start:end],16)
					start, end = start + index * 2, end + index * 2
				
				if marker == "ffda":
					marker = pic.EOIMARKER[0]
					if marker < end: marker = pic.EOIMARKER[1]
					txt.write("%s => %s\n" %('ffd9', hex(marker)))
					print "'%s' is JPG" % filename
					JPG.append(filename)
					with open('output/%s.jpg' % output, 'w') as restore:
						restore.write(pic.raw_data[fd:marker])
				else: print "'%s' is JPG but broken"

		else: print "'%s' is not JPG" % filename

	print "\n",JPG
