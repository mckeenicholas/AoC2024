section .data
	filename db "input.txt", 0
	READ_CHUNK_SIZE equ 43
	BUFFER_SIZE equ 22000
	BLOCK_SIZE equ 43
	
section .bss
	buf resb BUFFER_SIZE
	out_buf resb 64
	buf_idx resd 1
	fd resq 1
	len resq 1
	
section .text
global _start:
	
test_combo:
	xor r11, r11                 ; loop index
	
.loop_start:
	cmp r11, 42
	jge .success
	
	mov al, byte [rdi + r11]
	cmp al, '#'
	jne .next_iteration
	
	mov al, byte [rsi + r11]
	cmp al, '#'
	jne .next_iteration
	
	xor rax, rax
	ret
	
.next_iteration:
	inc r11
	jmp .loop_start
	
.success:
	mov rax, 1
	ret
	
_start:
	
	mov rax, 2                   ; SYS_OPEN
	lea rdi, [filename]
	mov rsi, 0                   ; O_RDONLY
	syscall
	
	mov [fd], rax
	
	mov rax, 0                   ; SYS_READ
	mov rdi, [fd]
	lea rsi, [buf]
	mov rdx, BUFFER_SIZE
	syscall
	mov [len], rax               ; length of bytes
	
.add_combos:
	xor rcx, rcx                 ; outer loop index
	xor rbx, rbx                 ; inner loop index
	xor rdx, rdx                 ; counter
	
.outer_loop:
	cmp rcx, [len]
	jge .done
	
	lea rdi, [buf]
	add rdi, rcx
	
	xor rbx, rbx
	
.inner_loop:
	
	cmp rbx, [len]
	jge .next_outer
	
	lea rsi, [buf]
	add rsi, rbx
	
	call test_combo
	add rdx, rax
	
	add rbx, BLOCK_SIZE
	jmp .inner_loop
	
.next_outer:
	add rcx, BLOCK_SIZE
	jmp .outer_loop
	
.done:
	shr rdx, 1
	mov [out_buf], rdx
	
	mov rax, 1                   ; SYS_WRITE
	mov rdi, 1                   ; stdout fd
	lea rsi, [out_buf]
	mov rdx, 8
	syscall
	
	mov rax, 60                  ; exit
	xor rdi, rdi                 ; exit code 0
	syscall
