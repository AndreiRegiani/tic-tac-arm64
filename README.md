# Tic-Tac-ARM64
Tic-Tac-Toe written in ARM 64-bit assembly (AArch64) for learning purposes.

## Runtime Requirements
* POSIX compatible OS: Linux, Android, ...
* ARMv8-A hardware or emulation
* System calls used: `read()`, `write()`, `exit()`
* No libc

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
./tictac_arm64  # qemu-aarch64
```

## Running on Android
```
adb push tictac_arm64 /sdcard
adb shell cp /sdcard/tictac_arm64 /data/local/tmp
adb shell chmod +x /data/local/tmp/tictac_arm64
adb shell /data/local/tmp/tictac_arm64
```