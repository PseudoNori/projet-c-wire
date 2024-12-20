#include "params.h"

void infixe_print(pTree a, FILE* flux,int test){

//test=1 équivaut au cas lv all
	if(test==1){
		if(a!=NULL && a->filsD==NULL && a->filsG==NULL){
		    fprintf(flux,"%d:%.0Lf:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation, a->capacity - a->consomation);
		}
		else if((a!=NULL)){
		        infixe_print(a->filsG,flux);
		        fprintf(flux,"%d:%.0Lf:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation,a->capacity - a->consomation);
		        infixe_print(a->filsD,flux);
		}
	}
	else{
		if(a!=NULL && a->filsD==NULL && a->filsG==NULL){
		    fprintf(flux,"%d:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation);
		}
		else if((a!=NULL)){
		        infixe_print(a->filsG,flux);
		        fprintf(flux,"%d:%.0Lf:%.0Lf\n",a->id, a->capacity, a->consomation);
		        infixe_print(a->filsD,flux);
		}
	}
}

pTree extract(FILE* flux){
    pTree a=NULL;
    int i=0;

    if(fscanf(flux,"%d",&i)==-1){
    	printf("probleme fscanf\n");
    	exit(3);
    }
   	do{
    	a=insertAVL(a,flux,i);

        if(fscanf(flux,"%d",&i)==-1){
            i=fgetc(flux);
        }
	}while(i!=EOF);

    return a;
}
