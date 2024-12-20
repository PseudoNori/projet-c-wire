
all: C-Wire-exe

Avl.o : Avl.c params.h
	gcc -c Avl.c -lm -o Avl.o
	
File.o : File.c params.h
	gcc -c File.c -lm -o File.o

main.o : main.c Avl.o File.o params.h
	gcc -c main.c -lm -o main.o

C-Wire-exe : main.o Avl.o File.o
	gcc main.o Avl.o File.o -o C-Wire-exe -lm

clean:
	rm -f *.o
	rm -f C-Wire-exe
