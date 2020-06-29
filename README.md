# Tic-Tac-ARM64
Tic-Tac-Toe written in ARM 64-bit assembly (AArch64).

## Runtime Requirements
* POSIX compatible (tested on Ubuntu and Android)
* ARMv8-A hardware or emulation
* stdin/stdout
* No libc dependency
* System calls used: `read()`, `write()`, `exit()`

## Cross-compiling from Ubuntu x86-64
Dependencies:
```
$ sudo apt install gcc-aarch64-linux-gnu

# Emulation:
$ sudo apt install qemu-aarch64
```

Compiling & Running:
```
$ make
./tictac_arm64  # qemu-aarch64: runs without a dedicated VM
```

## Running on Android
No root required:
```
adb push tictac_arm64 /sdcard
adb shell cp /sdcard/tictac_arm64 /data/local/tmp
adb shell chmod +x /data/local/tmp/tictac_arm64
adb shell /data/local/tmp/tictac_arm64
```

## Match example
```
### Tic-Tac-ARM64 ###
Coordinates:

1 2 3
4 5 6
7 8 9

Make a move (1-9): 1
X - - 
- - - 
- - - 

Make a move (1-9): 1
>>> Invalid move, try again.

Make a move (1-9): 2
X O - 
- - - 
- - - 

Make a move (1-9): 3
X O X 
- - - 
- - - 

Make a move (1-9): 4
X O X 
O - - 
- - - 

Make a move (1-9): 5
X O X 
O X - 
- - - 

Make a move (1-9): 6
X O X 
O X O 
- - - 

Make a move (1-9): 7
X O X 
O X O 
X - - 

>>> Victory by X
```
