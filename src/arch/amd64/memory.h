#pragma once

#define KERNEL_OFFSET 0xFFFFFF8000000000
#define PHYSICAL(x) (x - KERNEL_OFFSET)
#define VIRTUAL(x) (x + KERNEL_OFFSET)