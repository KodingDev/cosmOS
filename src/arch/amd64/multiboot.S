.code32
.section .headers, "a"

#include "multiboot.h"

multiboot_header:

.long MULTIBOOT_HEADER
.long MULTIBOOT_X86
.long multiboot_header_end - multiboot_header
.long MULTIBOOT_CHECKSUM(MULTIBOOT_X86, multiboot_header_end - multiboot_header)

// end tag

.short 0
.short 0
.long 8

multiboot_header_end: