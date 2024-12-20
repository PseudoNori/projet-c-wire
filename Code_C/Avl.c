#include "params.h"

int height(pArbre a){
    if (a == NULL)
        return 0;
    return a->height;
}

pArbre addAVL(FILE* flux, pArbre a){
    long double capa, cons;
    char tab[100];

    if(fscanf(flux,";%Lf;%Lf",&capa,&cons)==-1){
    	printf("probleme fscanf");
    	exit(3);
    }

    a->capacity=a->capacity + capa;
    a->consomation=a->consomation + cons;
    fgets(tab, 99,flux);
    return a;
}

pArbre crAVL(long double i){
    pArbre a;
    a=malloc(sizeof(AVLcsv));
    a->capacity=0;
    a->id=i;
    if (a->id<=0){
        exit(1);
    }
    a->consomation=0;
    a->filsG=NULL;
    a->filsD=NULL;
    a->height=1;
    return a;
}

pArbre rightRotate(pArbre a){
    pArbre p = a->filsG;
    pArbre c = p->filsD;

    p->filsD = a;
    a->filsG = c;

    a->height = fmax(height(a->filsG),height(a->filsD)) + 1;
    p->height = fmax(height(p->filsG),height(p->filsD)) + 1;
    return p;
}

pArbre leftRotate(pArbre a){
    pArbre p = a->filsD;
    pArbre c = p->filsG;

    p->filsG = a;
    a->filsD = c;

    a->height = fmax(height(a->filsG),height(a->filsD)) + 1;
    p->height = fmax(height(p->filsG),height(p->filsD)) + 1;
    return p;
}

int getBalance(pArbre a){
    if (a == NULL)
        return 0;
    return height(a->filsG) - height(a->filsD);
}

pArbre insertAVL(pArbre a, FILE* flux, long double i){
    if(a==NULL){
        a=crAVL(i);
        a=addAVL(flux, a);
        return a;
    }
    if (i < a->id){
        a->filsG=insertAVL(a->filsG,flux,i);
    }
    else if (i > a->id){
        a->filsD=insertAVL(a->filsD,flux,i);
    }   
    else {
        a=addAVL(flux,a);
        return a;
    }
    a->height = 1 + fmax(height(a->filsG),
                        height(a->filsD));

    int balance = getBalance(a);

    if (balance > 1 && i < a->filsG->id){
        return rightRotate(a);
    }
    if (balance < -1 && i > a->filsD->id){
        return leftRotate(a);
    }
    if (balance > 1 && i > a->filsG->id){
        a->filsG =  leftRotate(a->filsG);
        return rightRotate(a);
    }

    if (balance < -1 && i < a->filsD->id){
        a->filsD = rightRotate(a->filsD);
        return leftRotate(a);
    }
    return a;
}
