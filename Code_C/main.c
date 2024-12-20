#include "params.h"

int main(int argc,char *argv[]){
    FILE* input=NULL;
    FILE* output=NULL;
    pTree AVL=NULL;
	if(argc!=3){
		printf("error wrong argument \n");
		exit(5);
	}
	
    input=fopen(argv[1], "r");
    if(input==NULL){
        printf("%s\n",argv[1]);
        printf("error fopen \n");
        exit(2);
    }
    AVL=extract(input);  //argv1= nom du fichier

    output=fopen("tmp/res_c.csv", "w");
    if(output==NULL){
        printf("error fopen res \n");
        exit(4);
    }
    infixe_print(AVL,output,atoi(argv[2]));
return 0;
}

