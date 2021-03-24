## Description of Directory
- **eval_script:** evaluation script for code coverage
- **script:** seed_maker.py and FASelector.py (including source code of FASelector)
- **src:** source code of fuzzbuilderex

## Make FuzzBuilderEx
```
$ mkdir build && cd build
$ cmake ../build/src
$ make all
```

## Usage for FASelector
```
# Installation FASelector
$ /bin/bash ./FASelector.sh

# Usage
$ /bin/bash ./FASelector.sh [target library] [test binary] [source code directory]
```
