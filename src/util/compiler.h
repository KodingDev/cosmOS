#pragma once

#include <stddef.h>

#define ATTRIB(x) __attribute__((x))
#define alloca(x) __builtin_alloca(x)

#define __noreturn _Noreturn
#define __unused ATTRIB(unused)
#define __packed ATTRIB(packed)
#define __interrupt ATTRIB(interrupt)
