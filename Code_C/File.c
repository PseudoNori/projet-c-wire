#include "params.h"

void parcour_infixe(pArbre a, FILE* flux){
    if(a!=NULL && a->filsD==NULL && a->filsG==NULL){
        fprintf(flux,"%.0Lf;%.0Lf;%.0Lf\n",a->id, a->capacity, a->consomation);
    }
    else if((a!=NULL)){
            parcour_infixe(a->filsG,flux);
            fprintf(flux,"%.0Lf;%.0Lf;%.0Lf\n",a->id, a->capacity, a->consomation);
            parcour_infixe(a->filsD,flux);
    }
}

pArbre extract(FILE* flux){
    pArbre a=NULL;
    long double i=0;

    if(fscanf(flux,"%Lf",&i)==-1){
    	printf("probleme fscanf\n");
    	exit(3);
    }
   	do{
    	a=insertAVL(a,flux,i);
        if(fscanf(flux,"%Lf",&i)==-1){
            i=fgetc(flux);
        }
	}while(i!=EOF);

    return a;
}
