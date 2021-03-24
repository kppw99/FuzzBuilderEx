from Type.code.__BASE__ import __BASE__


class HEADER(__BASE__):
    def getFuncProto(self):
        import re
        compiler = re.compile(
            r'^((\w)+(\w| |\*)+\((\w|,| |\*|\n)+\);)$',
            re.MULTILINE
        )
        return [re.sub(r'\n( )+', ' ', i[0]) for i in (compiler.findall(self.code))]