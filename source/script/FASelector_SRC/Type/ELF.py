import Utils.Converter as cvt

class ELF:
    def __init__(self, raw):
        self.raw        = raw
        self.endian     = 'little'
        self.symtab     = b''
        self.strtab     = b''
        self.APIs       = []

        self.parse()


    def parse(self):
        self.parseElfHeader()
        self.parseSectionHeader()
        self.parseSymbolTable()


    def parseElfHeader(self):
        elf_header = self.raw[ : 0x34 ]

        e_ident         = elf_header[ : 0x10 ]  
        ei_magic        = e_ident[ : 0x4 ]
        ei_class        = e_ident[ 0x4 : 0x5 ][0]
        ei_data         = e_ident[ 0x5 : 0x6 ][0]
        ei_version      = e_ident[ 0x6 : 0x7 ][0]
        ei_osabi        = e_ident[ 0x7 : 0x8 ][0]
        ei_abiversion   = e_ident[ 0x8 : 0x9 ][0]
        ei_pad          = e_ident[ 0x9 : ]

        if ei_data == 2: self.endian = "big" # {"little endian": 1, "big endian": 2}
        self.cvt = cvt.CONVERTER(self.endian)

        self.e_type      = self.cvt.bytes2int(elf_header[ 0x10 : 0x12 ])
        self.e_machine   = self.cvt.bytes2int(elf_header[ 0x12 : 0x14 ])
        self.e_version   = self.cvt.bytes2int(elf_header[ 0x14 : 0x18 ])
        self.e_entry     = self.cvt.bytes2int(elf_header[ 0x18 : 0x1C ])
        self.e_phoff     = self.cvt.bytes2int(elf_header[ 0x1C : 0x20 ])
        self.e_shoff     = self.cvt.bytes2int(elf_header[ 0x20 : 0x24 ])
        self.e_flags     = self.cvt.bytes2int(elf_header[ 0x24 : 0x28 ])
        self.e_ehsize    = self.cvt.bytes2int(elf_header[ 0x28 : 0x2A ])
        self.e_phentsize = self.cvt.bytes2int(elf_header[ 0x2A : 0x2C ])
        self.e_phnum     = self.cvt.bytes2int(elf_header[ 0x2C : 0x2E ])
        self.e_shentsize = self.cvt.bytes2int(elf_header[ 0x2E : 0x30 ])
        self.e_shnum     = self.cvt.bytes2int(elf_header[ 0x30 : 0x32 ])
        self.e_shstrndx  = self.cvt.bytes2int(elf_header[ 0x32 : ])


    def parseSectionHeader(self):
        start = self.e_shoff
        for i in range(self.e_shnum):
            section_header = self.raw[ start : start + 0x28 ]
            sh_name      = self.cvt.bytes2int(section_header[ 0x00 : 0x04 ])
            sh_type      = self.cvt.bytes2int(section_header[ 0x04 : 0x08 ])
            sh_flags     = self.cvt.bytes2int(section_header[ 0x08 : 0x0C ])
            sh_addr      = self.cvt.bytes2int(section_header[ 0x0C : 0x10 ])
            sh_offset    = self.cvt.bytes2int(section_header[ 0x10 : 0x14 ])
            sh_size      = self.cvt.bytes2int(section_header[ 0x14 : 0x18 ])
            sh_link      = self.cvt.bytes2int(section_header[ 0x18 : 0x1C ])
            sh_info      = self.cvt.bytes2int(section_header[ 0x1C : 0x20 ])
            sh_addralign = self.cvt.bytes2int(section_header[ 0x20 : 0x24 ])
            sh_entsize   = self.cvt.bytes2int(section_header[ 0x24 : 0x28 ])

            if sh_type == 2: self.symtab = self.raw[ sh_offset : sh_offset + sh_size ]
            elif sh_type == 3:
                # TODO: need to be more sophisticated
                raw = self.raw[ sh_offset : sh_offset + sh_size ]
                if not b'.symtab' in raw: self.strtab = raw

            start += 0x28


    def parseSymbolTable(self):
        for symtab in [self.symtab[ i : i + 0x10 ] for i in range(0, len(self.symtab), 0x10) ]:
            sym_name    = self.cvt.bytes2int(symtab[ : 0x4 ])
            sym_value   = symtab[ 0x4 : 0x8 ]
            sym_size    = symtab[ 0x8 : 0xC ]
            sym_info    = self.cvt.bytes2int(symtab[ 0xC : 0xD ])
            sym_other   = symtab[ 0xD : 0xE ]
            sym_shndx   = symtab[ 0xE : ]
            
            # (sym_info == 0x02) == [ STB_LOCAL | STT_FUNC ]
            # (sym_info == 0x12) == [ STB_GLOBAL | STT_FUNC ]
            if sym_info & 0xF == 0x2: 
                try: self.APIs.append(self.strtab[ sym_name : ].split(b'\x00')[0].decode('utf-8'))
                except: continue


# http://www.skyfree.org/linux/references/ELF_Format.pdf
# https://lyres.tistory.com/35
