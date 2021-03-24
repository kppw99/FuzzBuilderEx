class FOLDER:
    def __init__(self, root):
        self.root   = root if root.endswith('/') else f'{root}/'
        self.valid  = self.isValid()


    def isValid(self):
        import os
        return os.path.exists(self.root)


    def getFiles(self, endswith=''):
        import glob
        if endswith: endswith = f'.{endswith}'
        return [f for f in glob.glob(self.root + '**', recursive=True) if f.endswith(endswith)]
