class __BASE__:
    def __init__(self, file):
        self.file   = file
        self.code   = self.getCode()


    def getCode(self):
        with open(self.file, 'r') as f:
            return f.read()