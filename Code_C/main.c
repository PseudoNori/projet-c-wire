#include "params.h"

int main(int argc,char *argv[]){
    FILE* input=NULL;
    FILE* output=NULL;
    pArbre AVL=NULL;

    input=fopen(argv[1], "r");
    if(input==NULL){
        printf("%s\n",argv[1]);
        printf("error fopen");
        exit(2);
    }
    AVL=extract(input);  //argv1= nom du fichier

    output=fopen("../tmp/res_c.dat", "w");
    if(output==NULL){
        printf("error fopen res");
        exit(4);
    }
    parcour_infixe(AVL,output);
return 0;
}

