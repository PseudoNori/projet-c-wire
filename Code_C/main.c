#include "params.h"

int main(int argc,char *argv[]){
    FILE* input=NULL;
    FILE* output=NULL;
    pTree avl=NULL;

    input=fopen(argv[1], "r");
    if(input==NULL){
        printf("%s\n",argv[1]);
        printf("error fopen");
        exit(2);
    }
    avl=extract(input);  //argv1= nom du fichier
    output=fopen("../tmp/res_c.csv", "w");
    if(output==NULL){
        printf("error fopen res");
        exit(4);
    }
    infixe_print(avl,output);
return 0;
}

