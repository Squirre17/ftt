.intel_syntax noprefix
.macro SAVE_CTX
	push rax
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	sub rsp, 8      // align 0x10
.endm

.macro RESTORE_CTX
	add rsp, 8
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rax
.endm

.global __fentry__
__fentry__:
    cmp QWORD PTR tracer_ptr, 0
    jz end

    SAVE_CTX

    // ·····
    // parent ret addr  <- rbp + 8
    // xxxxxx           <- rbp
    // ret addr         <- rsp + 0x40
    // rax
    // rcx
    // rdx
    // rsi
    // rdi
    // r8
    // r9
    // xxxxxx           <- rsp


    mov r9, rcx
    mov r8, rdx
    mov rcx, rsi
    mov rdx, rdi
    mov rdi, QWORD PTR [rsp+0x40]
    mov rsi, QWORD PTR [rsp+0x48] // parent return address(i.e the entry of caller)
    sub rsi, 6                     // call xxxx is 6 bytes, adjust ptr offset
    mov rax,QWORD PTR [tracer_ptr]
    call rax

    RESTORE_CTX
end:
    ret