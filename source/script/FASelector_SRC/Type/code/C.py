from Type.code.__BASE__ import __BASE__

import re


class C(__BASE__):
    def getFuncProto(self):
        compiler = re.compile(
            r'^((\w)+(\w| |\*)+\((\w|,| |\*|\n)+\))',
            re.MULTILINE
        )
        return [re.sub(r'\n( )+', ' ', i[0]) for i in (compiler.findall(self.code))]


    def getElements(self, prototype):
        raw = list(
            filter(
                None,
                prototype.split('(')[0].split(' ')
            )
        )
        
        if raw[-1][0] == '*':
            raw[-1] = raw[-1][ 1 : ]
            raw.insert(-1, '*')
        
        ret     = ' '.join(raw[ : -1 ])
        fName   = raw[-1]
        params  = self.getParams(re.search(r'\(.+\)', prototype)[0][ 1 : -1 ])

        return [ret, fName, params]


    def getParams(self, raw_params):
        params = {}
        index = 0

        for param in raw_params.split(','):
            index += 1

            param = param.strip().split(' ')
            if param[-1][0] == '*':
                param[-1] = param[-1][ 1 : ]
                param.insert(-1, '*')

            new = [index, param[-1]]
            type = ' '.join(param[ : -1 ])

            if not type in params: params[type] = [new]
            else: params[type] += [new]

        return params
