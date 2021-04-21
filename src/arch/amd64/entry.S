.text
.global entry64

entry64:
    mov $16, %cx
    mov %cx, %fs
    mov %cx, %gs
    mov %cx, %ss
    mov %cx, %ds
    mov %cx, %es

    movabs $boot_stack_bottom, %rsp // Start using the higher-half stack address, now that we can access those addresses

    mov %rax, %rdi
    mov %rbx, %rsi

    xor %rbp, %rbp

    // If we don't use this indirect route of invoking the main method, it will use relative addressing and keep using
    // lower half addresses.
    movabs $kernel_main, %rax
    call *%rax

    // kernel_main shouldn't return, but if it does, we halt the CPU.
1:  hlt
    jmp 1b
