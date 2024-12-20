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

typedef AVLcsv* pTree; // pointer on AVLcsv are now pTree


pTree addAVL(FILE* flux, pTree a){
    long double capa, cons;
    char tab[100];

    if(fscanf(flux,";%Lf;%Lf",&capa,&cons)==-1){
    	printf("error fscanf");
    	exit(3);
    }

    a->capacity=a->capacity + capa;
    a->consomation=a->consomation + cons;
    fgets(tab, 99,flux);
    return a;
}

pTree crAVL(int i){
    pTree a;
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

int height(pTree a){
    if (a == NULL)
        return 0;
    return a->height;
}

pTree rightRotate(pTree a){
    pTree p = a->filsG;
    pTree c = p->filsD;
    p->filsD = a;
    a->filsG = c;
    a->height = fmax(height(a->filsG),height(a->filsD)) + 1;
    p->height = fmax(height(p->filsG),height(p->filsD)) + 1;
    return p;
}

pTree leftRotate(pTree a){
    pTree p = a->filsD;
    pTree c = p->filsG;
    p->filsG = a;
    a->filsD = c;
    a->height = fmax(height(a->filsG),height(a->filsD)) + 1;
    p->height = fmax(height(p->filsG),height(p->filsD)) + 1;
    return p;
}

int getBalance(pTree a){
    if (a == NULL)
        return 0;
    return height(a->filsG) - height(a->filsD);
}

pTree insertAVL(pTree a, FILE* flux, int i){
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
	// Rotations
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
    char i=fgetc(flux);
    
   	do{
    	a=insertAVL(a,flux,i);
    	//printf("%c \n",i);
    	i=fgetc(flux);
	}while(i!=EOF);
    return a;
}

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

