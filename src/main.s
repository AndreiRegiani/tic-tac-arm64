/*
 *  Tic-Tac-ARM64 by @AndreiRegiani
*/

// System calls (linux/include/uapi/asm-generic/unistd.h)
.equ    SYS_read,   63
.equ    SYS_write,  64
.equ    SYS_exit,   93

// File descriptors
.equ    stdin,      0
.equ    stdout,     1

// Gameplay constants
.equ    x_mark,     'X'
.equ    o_mark,     'O'

.data
board:          .byte   '-', '-', '-', '-', '-', '-', '-', '-', '-'
current_player: .byte   x_mark
new_line:       .byte   '\n'
space:          .byte   ' '
input_position: .byte   0, 0

// Strings
welcome_string:     .ascii  "### Tic-Tac ARM64 ###\nCoordinates:\n\n1 2 3\n4 5 6\n7 8 9\n"
welcome_string_len = . - welcome_string

enter_position_str:     .ascii  "\nEnter position (1-9): "
enter_position_str_len = . - enter_position_str

invalid_str:     .ascii  "Invalid move, try again.\n"
invalid_str_len = . - invalid_str

.text
.globl _start

_start:
	bl      welcome

    .main_loop:
    bl      check_game_over
    cmp     x0, #4
    beq     .game_over
    bl      make_move
    bl      draw_board
    bl      switch_player
    b       .main_loop

    .game_over:
    bl      exit

welcome:
    mov     x0, stdout
	ldr     x1, =welcome_string
	mov     x2, welcome_string_len
	mov     x8, SYS_write
	svc     #0
    ret

check_game_over:
    /*  Returns on x0:
    0 = in progress
    1 = player 1 won
    2 = player 2 won
    3 = draw
    4 = game over 
    */
    mov     x0, #0
    ret

draw_board:
    mov     x9, #0 // counter

    .loop: 
    cmp     x9, #9
    bge     .endloop

    mov     x0, stdout
    adr     x1, board
    add     x1, x1, x9
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    adr     x1, space
    svc     #0

    cmp     x9, #2
    beq     .line_print
    cmp     x9, #5
    beq     .line_print
    cmp     x9, #8
    beq     .line_print
    b       .skip_print

    .line_print:
    mov     x0, stdout
    ldr     x1, =new_line
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    .skip_print:
    add     x9, x9, #1
    b       .loop

    .endloop:
    ret

make_move:
    mov     x0, stdout
	ldr     x1, =enter_position_str
	mov     x2, enter_position_str_len
	mov     x8, SYS_write
	svc     #0

    mov     x0, stdin
    ldr     x1, =input_position
    mov     x2, #2
    mov     x8, SYS_read
    svc     #0

    mov     x13, x1
    ldrb    w14, [x13]
    sub     w14, w14, '1' // ASCII offset, now "0"=0x00, "1"=0x01

    ldr     x10, =board
    ldr     x11, =current_player
    ldrb    w12, [x11]

    // Verify the desired slot is empty
    ldrb    w13, [x10, x14]
    cmp     x13, '-'
    bne     .invalid_move
    strb    w12, [x10, x14]
    ret

    .invalid_move:
    mov     x0, stdout
	ldr     x1, =invalid_str
	mov     x2, invalid_str_len
	mov     x8, SYS_write
	svc     #0
    b       make_move

switch_player:
    ldr     x11, =current_player
    ldrb    w12, [x11]

    cmp     w12, x_mark
    beq     .select_player_2
    bne     .select_player_1

    .select_player_1:
    mov     w12, x_mark
    strb    w12, [x11]
    ret

    .select_player_2:
    mov     w12, o_mark
    strb    w12, [x11]
    ret

exit:
    mov     x0, #0 // EXIT_SUCCESS
	mov     x8, SYS_exit
	svc     #0
    ret
