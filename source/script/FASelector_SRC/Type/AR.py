class AR:
    def __init__(self, raw):
        self.raw    = raw
        self.APIs   = []
        self.parse()

    def parse(self):
        start, end = 0x8, 0x8

        while True:
            end = start + 60
            fileHeader = self.raw[ start : end ]
            if fileHeader == b'': break

            fileName  = fileHeader[ 0x00 : 0x10 ].rstrip()
            if fileName != b'//':
                timestamp = int(fileHeader[ 0x10 : 0x1C ].rstrip())
                ownerID   = int(fileHeader[ 0x1C : 0x22 ].rstrip())
                groudID   = int(fileHeader[ 0x22 : 0x28 ].rstrip())
                fileMode  = int(fileHeader[ 0x28 : 0x2D ].rstrip())
            fileSize  = int(fileHeader[ 0x30 : -2 ].rstrip())

            start = end
            end  += fileSize
            data  = self.raw[ start : end ]
            start = end

            if fileName == b'/': self.APIs = self.getAPIs(data)

    def getAPIs(self, ar_file):
        APIs = []
        for i in list(set(ar_file.split(b'\x00'))):
            try: APIs.append(i.decode('utf-8'))
            except: continue
        return APIs