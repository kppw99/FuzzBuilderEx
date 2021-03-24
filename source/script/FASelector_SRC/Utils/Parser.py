from Type.AR   import *
from Type.ELF  import *


class PARSER:
    def __init__(self, raw):
        self.raw = raw
        self.signature = self.checkSignature(raw[ : 0x10 ])
        self.handler = globals()[self.signature](self.raw)

    def checkSignature(self, sig):
        if (sig[ : 0x08 ] == b'!<arch>\n'): return 'AR'
        elif (sig[ : 0x04 ] == b'\x7fELF'): return 'ELF'
