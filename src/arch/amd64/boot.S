.code32
.text
.global _start

#include "memory.h"

_start:
    mov $PHYSICAL(boot_stack_bottom), %esp

    // Save Multiboot magic and pointer
    push %ebx
    push %eax

    call page_table_setup
    call long_mode_setup

    ljmp $0x8, $PHYSICAL(entry64)
1:  hlt
    jmp 1b
.size _start, . - _start

long_mode_setup:
    // Enable PAE
    mov %cr4, %eax
    or $0x20, %eax
    mov %eax, %cr4

    // Set LM bit
    mov $0xC0000080, %ecx
    rdmsr
    or $0x100, %eax
    wrmsr

    // Enable paging
    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

    // Copy multiboot information to registers
    mov 4(%esp), %eax
    mov 8(%esp), %ebx

    lgdt PHYSICAL(gdt_pointer)

    ret

page_table_setup:
    mov $PHYSICAL(boot_pages_l4), %eax
    mov %eax, %cr3

    // Set up recursive paging
    mov %eax, %ebx
    or $3, %ebx
    mov %ebx, 4080(%eax)

    mov $PHYSICAL(boot_pages_l3), %ebx
    or $3, %ebx // present, writable - proper permissions will be applied later by the C code
    mov %ebx, (%eax)
    mov %ebx, 4088(%eax) // also write it to the 511th entry of the L4 page table, causing any address equal to or above 0xFFFFFF8000000000 to be remapped to (addr - 0xFFFFFF8000000000)

    mov $PHYSICAL(boot_pages_l3), %eax
    mov $PHYSICAL(boot_pages_l2), %ebx
    or $3, %ebx // present, writable
    mov %ebx, (%eax)

    mov $PHYSICAL(boot_pages_l2), %edi
    mov $0x83, %esi // present, writable, 2 MiB
    mov $512, %ecx
.Lmap_loop:
    mov %esi, (%edi)
    add $0x200000, %esi
    add $8, %edi
    loop .Lmap_loop

    ret

.rodata
.global gdt
gdt:
.quad 0
.quad 0xaf9a000000ffff // Kernel code
.quad 0xcf92000000ffff // Kernel data
.quad 0xaffa000000ffff // Ring 3 code
.quad 0xcffa000000ffff // Ring 3 data
.quad 0 // TSS, will be filled by C code
.quad 0 // top 32 bits of TSS address
gdt_pointer:
.short . - gdt -1
.quad gdt

.bss
.global boot_stack_bottom
.global boot_pages_l4
.align 4096
boot_pages_l4:
.skip 4096
boot_pages_l3:
.skip 4096
boot_pages_l2:
.skip 4096
boot_stack:
.skip 16384
boot_stack_bottom: