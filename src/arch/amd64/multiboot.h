#define MULTIBOOT_HEADER (0xE85250D6)
#define MULTIBOOT_X86 (0)
#define MULTIBOOT_CHECKSUM(architecture, length) (-(MULTIBOOT_HEADER + (architecture) + (length)))
#define MULTIBOOT_END_TAG (0)
#define MULTIBOOT_FRAMEBUFFER_TAG (5)