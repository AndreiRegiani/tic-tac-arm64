# Tic-Tac-ARM64
Tic-Tac-Toe written in ARM 64-bit assembly (AArch64) for learning purposes.

```
Coordinates:

1 2 3
4 5 6
7 8 9

Enter position (1-9): 1
X - - 
- - - 
- - - 
```

## Runtime Requirements
* No libc dependency
* POSIX compatible: Linux, Android, ...
* ARMv8-A hardware or emulation
* System calls used: `read()`, `write()`, `exit()`
* stdin/stdout

## Cross-compiling from Ubuntu x86-64
Dependencies:
```
$ sudo apt install gcc-aarch64-linux-gnu

# Emulation:
$ sudo apt-get install qemu-aarch64
```

Compiling & Running:
```
$ make
./tictac_arm64  # qemu-aarch64: runs without a dedicated VM!
```

## Running on Android
No root required:
```
adb push tictac_arm64 /sdcard
adb shell cp /sdcard/tictac_arm64 /data/local/tmp
adb shell chmod +x /data/local/tmp/tictac_arm64
adb shell /data/local/tmp/tictac_arm64
```
