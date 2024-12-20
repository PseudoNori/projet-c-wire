#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

typedef struct AVLcsv{
    int id; // id number
    int height; 
    struct AVLcsv* filsG;
    struct AVLcsv* filsD;
	long double capacity;
    long double consomation;
}AVLcsv;

/////////////////////////////////////////////////////////////////////////////////////

typedef AVLcsv* pTree;

/////////////////////////////////////////////////////////////////////////////////////

pTree addAVL(FILE* flux, pTree a);

pTree crAVL(long double i);

int height(pTree a);

pTree rightRotate(pTree a);

pTree leftRotate(pTree a);

int getBalance(pTree a);

pTree insertAVL(pTree a, FILE* flux, long double i);

/////////////////////////////////////////////////////////////////////////////////////

void infixe_print(pTree a, FILE* flux);

pTree extract(FILE* flux);












