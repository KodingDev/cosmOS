#include "util/compiler.h"

extern "C" __unused void kernel_main() {
    *((char*) 0x000b8000) = 'A';
}