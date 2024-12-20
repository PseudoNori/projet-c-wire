#include "params.h"

void infixe_print(pTree a, FILE* flux){
    if(a!=NULL && a->filsD==NULL && a->filsG==NULL){
        fprintf(flux,"%c:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation);
    }
    else if((a!=NULL)){
            infixe_print(a->filsG,flux);
            fprintf(flux,"%c:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation);
            infixe_print(a->filsD,flux);
    }
}

pTree extract(FILE* flux){
    pTree a=NULL;
    long double i=0;

    if(fscanf(flux,"%Lf",&i)==-1){
    	printf("probleme fscanf\n");
    	exit(3);
    }
    
   do{
    	a=insertAVL(a,flux,i);
    	i=fgetc(flux);
	}while(i!=EOF);
   return a;
}
