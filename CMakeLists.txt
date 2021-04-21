cmake_minimum_required(VERSION 3.17)
project(cosmos NONE)

enable_language(C CXX ASM)

set(COSMOS_ARCH amd64)
set(CMAKE_C_STANDARD 11)

add_executable(cosmos src/main.cpp src/arch/${COSMOS_ARCH}/boot.S src/arch/${COSMOS_ARCH}/entry.S src/arch/${COSMOS_ARCH}/multiboot.S
        src/arch/${COSMOS_ARCH}/memory.h src/util/compiler.h)

set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG -O3")
set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -O3")
target_compile_options(cosmos PRIVATE -g -nostdlibinc -nostdlib -ffreestanding -target x86_64-unknown-gnu
        -mno-red-zone -Wall -Wextra -msoft-float -mno-mmx -mno-sse -mcmodel=large -fno-pie -fno-rtti -fno-exceptions
        -fno-omit-frame-pointer)
target_link_options(cosmos PRIVATE -g -Wl,-T "${CMAKE_CURRENT_SOURCE_DIR}/tools/kernel.lds" -nostdlib
        -target x86_64-unknown-gnu -fuse-ld=lld -Wl,--no-pie -Wl,--no-dynamic-linker)
set_target_properties(cosmos PROPERTIES LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tools/kernel.lds")

if (WSL)
    add_custom_command(
            OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/kernel.iso"
            COMMAND wsl "../tools/scripts/mkiso.sh"
            WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
            DEPENDS "${CMAKE_CURRENT_LIST_DIR}/tools/iso/grub.cfg" cosmos
    )
else ()
    add_custom_command(
            OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/kernel.iso"
            COMMAND ../tools/scripts/mkiso.sh
            WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
            DEPENDS "${CMAKE_CURRENT_LIST_DIR}/tools/iso/grub.cfg" cosmos
    )
endif ()

add_custom_target(iso DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/kernel.iso")
target_compile_definitions(cosmos PRIVATE "SRC_DIR=\"${CMAKE_CURRENT_LIST_DIR}\"")