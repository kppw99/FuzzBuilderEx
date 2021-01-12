from Type.code.C import C
from Type.FOLDER import FOLDER
from Utils.Parser import PARSER

import json
import os


def getAPIs(filename):
    with open(filename, 'rb') as f:
        parser = PARSER(f.read())
        return set(parser.handler.APIs)


def argument():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument(dest = "library", help = "current ar archive file")
    parser.add_argument(dest = "testProgram", help = "ELF executable")
    parser.add_argument(dest = "src", help = "path to source files")
    args = parser.parse_args()

    return args


def main():
    args = argument()

    l_apis = getAPIs(args.library)
    t_apis = getAPIs(args.testProgram)
    c_apis = l_apis & t_apis

    '''
    headers = FOLDER(args.src).getFiles('h')
    for h in headers:
        print(h)
        from Type.code.HEADER import HEADER
        handler = HEADER(h)
        for i in handler.getFuncProto():
            print(i)
        print('================================================================')
    '''

    candidates = {
        'candidates': { }
    }

    path = 'seeds.conf'
    os.makedirs(path, exist_ok=True)

    for c in FOLDER(args.src).getFiles('c'):
        filename = c.split('/')[-1].split('.')[0]
        candidates['candidates'][filename] = (
            {
                'filename': c.split('/')[-1],
                'filepath': c,
                "functions": []
            }
        )

        handler = C(c)
        for i in handler.getFuncProto():
            candidates['candidates'][filename]['functions'].append(i)

            params = handler.getElements(i)
            for type in params[2].keys():
                if params[1] in c_apis and type in ['char *', 'const char *', 'int']:
                    for p in params[2][type]:
                        candidate = {
                            'targets': [[ params[1], p[0] ]],
                            'files': [ f"{candidates['candidates'][filename]['filename'].split('.')[0]}.bc" ]
                        }
                        
                        with open(f'{path}/{p[0]}_{params[1]}.conf', 'w', encoding='utf-8') as f:
                            f.write(f'# {i}\n')
                            json.dump(candidate, f, indent=4)

    with open(f'{path}/__all__.conf', 'w', encoding='utf-8') as f:
        json.dump(candidates['candidates'], f, indent=4)


if __name__ == "__main__":
    main()