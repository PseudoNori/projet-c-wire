#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

typedef struct AVLcsv{
    //int type;    // 1=HV_B 2=HV_A 3=LV
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

pTree crAVL(int i);

int height(pTree a);

pTree rightRotate(pTree a);

pTree leftRotate(pTree a);

int getBalance(pTree a);

pTree insertAVL(pTree a, FILE* flux, int i);

/////////////////////////////////////////////////////////////////////////////////////

void infixe_print(pTree a, FILE* flux);

pTree extract(FILE* flux);












