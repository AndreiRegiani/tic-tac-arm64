/*
 *  Tic-Tac-ARM64 by @AndreiRegiani
 *  GPL-3.0 License
*/
.arch armv8-a

// System calls [linux/include/uapi/asm-generic/unistd.h]
.equ    SYS_read,   63
.equ    SYS_write,  64
.equ    SYS_exit,   93

// File descriptors
.equ    stdin,      0
.equ    stdout,     1

// Gameplay
.equ    x_mark,     'X'
.equ    o_mark,     'O'

.data
board:          .byte   '-', '-', '-', '-', '-', '-', '-', '-', '-'
current_player: .byte   x_mark
input_position: .byte   0, 0
total_moves:    .byte   0
space:          .byte   ' '
new_line:       .byte   '\n'

// Strings
welcome_str:     .ascii  "### Tic-Tac-ARM64 ###\nCoordinates:\n\n1 2 3\n4 5 6\n7 8 9\n"
welcome_str_len = . - welcome_str

enter_position_str:     .ascii  "\nMake a move (1-9): "
enter_position_str_len = . - enter_position_str

invalid_str:     .ascii  ">>> Invalid move, try again.\n"
invalid_str_len = . - invalid_str

win_str:     .ascii  "\n>>> Victory by "
win_str_len = . - win_str

gameover_str:     .ascii  "\n>>> Game over: it's a draw!\n"
gameover_str_len = . - gameover_str


.text
.globl _start


_start:
    bl      welcome

    .main_loop:
    bl      make_move
    bl      draw_board
    bl      check_game_over
    bl      switch_player
    b       .main_loop


welcome:
    mov     x0, stdout
    ldr     x1, =welcome_str
    mov     x2, welcome_str_len
    mov     x8, SYS_write
    svc     #0
    ret


check_game_over:
    ldr     x1, =current_player
    ldrb    w2, [x1]

    /* Load 3x3 board into the registers:

        w10  w11  w12

        w13  w14  w15

        w16  w17  w18
        
    */
    ldr     x9, =board
    ldrb    w10, [x9, #0]
    ldrb    w11, [x9, #1]
    ldrb    w12, [x9, #2]
    ldrb    w13, [x9, #3]
    ldrb    w14, [x9, #4]
    ldrb    w15, [x9, #5]
    ldrb    w16, [x9, #6]
    ldrb    w17, [x9, #7]
    ldrb    w18, [x9, #8]

    .win_case_1:
    /*
        X X X
        - - -
        - - -
    */
    cmp     w10, w2  // w10 = board[0], w2 = current_player
    bne     .win_case_2
    cmp     w11, w2 // w11 = board[1], w2 = current_player
    bne     .win_case_2
    cmp     w12, w2 // w12 = board[2], w2 = current_player
    bne     .win_case_2
    b       player_won

    .win_case_2:
    /*
        - - -
        X X X
        - - -
    */
    cmp     w13, w2
    bne     .win_case_3
    cmp     w14, w2
    bne     .win_case_3
    cmp     w15, w2
    bne     .win_case_3
    b       player_won

    .win_case_3:
    /*
        - - -
        - - -
        X X X
    */
    cmp     w16, w2
    bne     .win_case_4
    cmp     w17, w2
    bne     .win_case_4
    cmp     w18, w2
    bne     .win_case_4
    b       player_won

    .win_case_4:
    /*
        X - -
        X - -
        X - -
    */
    cmp     w10, w2
    bne     .win_case_5
    cmp     w13, w2
    bne     .win_case_5
    cmp     w16, w2
    bne     .win_case_5
    b       player_won

    .win_case_5:
    /*
        - X -
        - X -
        - X -
    */
    cmp     w11, w2
    bne     .win_case_6
    cmp     w14, w2
    bne     .win_case_6
    cmp     w17, w2
    bne     .win_case_6
    b       player_won

    .win_case_6:
    /*
        - - X
        - - X
        - - X
    */
    cmp     w12, w2
    bne     .win_case_7
    cmp     w15, w2
    bne     .win_case_7
    cmp     w18, w2
    bne     .win_case_7
    b       player_won

    .win_case_7:
    /*
        X - -
        - X -
        - - X
    */
    cmp     w10, w2
    bne     .win_case_8
    cmp     w14, w2
    bne     .win_case_8
    cmp     w18, w2
    bne     .win_case_8
    b       player_won

    .win_case_8:
    /*
        - - X
        - X -
        X - -
    */
    cmp     w12, w2
    bne     .return
    cmp     w14, w2
    bne     .return
    cmp     w16, w2
    bne     .return
    b       player_won

    .return:
    ret


player_won:
    mov     x0, stdout
    ldr     x1, =win_str
    mov     x2, win_str_len
    mov     x8, SYS_write
    svc     #0

    mov     x0, stdout
    ldr     x1, =current_player
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    mov     x0, stdout
    ldr     x1, =new_line
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    b       exit


game_over:
    bl      draw_board
    
    mov     x0, stdout
    ldr     x1, =gameover_str
    mov     x2, gameover_str_len
    mov     x8, SYS_write
    svc     #0

    b       exit


draw_board:
    mov     x9, #0 // counter

    .loop: 
    cmp     x9, #9
    bge     .end_loop

    mov     x0, stdout
    adr     x1, board
    add     x1, x1, x9
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    adr     x1, space
    svc     #0

    cmp     x9, #2
    beq     .new_line
    cmp     x9, #5
    beq     .new_line
    cmp     x9, #8
    beq     .new_line
    b       .skip_print

    .new_line:
    mov     x0, stdout
    ldr     x1, =new_line
    mov     x2, #1
    mov     x8, SYS_write
    svc     #0

    .skip_print:
    add     x9, x9, #1
    b       .loop

    .end_loop:
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
    sub     w14, w14, '1' // ASCII offset, now "1" = 0x01, "9" = 0x09

    // Check input is valid (1-9)
    cmp     w14, #0
    b.lt    .invalid_move
    cmp     w14, #9
    b.gt    .invalid_move

    ldr     x10, =board
    ldr     x11, =current_player
    ldrb    w12, [x11]

    // Check the desired slot is empty
    ldrb    w13, [x10, x14]
    cmp     x13, '-'
    bne     .invalid_move
    strb    w12, [x10, x14]

    // Increment total_moves
    ldr     x14, =total_moves
    ldrb    w15, [x14]
    add     w15, w15, #1
    strb    w15, [x14]

    // Check for draw (game over)
    cmp     w15, #9
    b.eq    game_over

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
