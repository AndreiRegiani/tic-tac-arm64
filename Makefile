AS=aarch64-linux-gnu-as
LD=aarch64-linux-gnu-ld

all:
	 $(AS) -o main.o src/main.s
	 $(LD) -o tictac_arm64 main.o

clean:
	rm -f main.o