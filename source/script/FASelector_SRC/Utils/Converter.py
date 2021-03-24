class CONVERTER:
    def __init__(self, endian):
        self.endian = endian

    def bytes2int(self, bytes):
        return int.from_bytes(bytes, byteorder=self.endian)