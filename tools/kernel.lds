ENTRY(_start)

KERNEL_OFFSET = 0xFFFFFF8000000000;
KERNEL_START = 1M;

SECTIONS {
    . = KERNEL_OFFSET + KERNEL_START;
    _kernel_start = .;
    .headers ALIGN(4K) : AT(ADDR(.headers) - KERNEL_OFFSET) { KEEP(*(.headers .headers.*)) }
    .text ALIGN(4K) : AT(ADDR(.text) - KERNEL_OFFSET) { *(.text .text.*) }
    .rodata ALIGN(4K) : AT(ADDR(.rodata) - KERNEL_OFFSET) { *(.rodata .rodata.*) }
    .data ALIGN(4K) : AT(ADDR(.data) - KERNEL_OFFSET) { *(.data .data.*) }
    .bss ALIGN(4K) : AT(ADDR(.bss) - KERNEL_OFFSET) { *(.bss .bss.*) }
    .init ALIGN(4K) : AT(ADDR(.init) - KERNEL_OFFSET) {
        __CTOR_LIST__ = .;
        *(.ctors .init .init.* .init_array)
        QUAD(0);
    }
    _kernel_end = .;
    /DISCARD/ : { *(.note.gnu.build-id) }
}