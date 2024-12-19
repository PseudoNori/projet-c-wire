#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include<unistd.h>
typedef struct AVLcsv{
    //int type;    // 1=HV_B 2=HV_A 3=LV
    int id; // num id
    int capacity;
    int consomation;
    struct AVLcsv* filsG;
    struct AVLcsv* filsD;
    int height;
}AVLcsv;

typedef AVLcsv* pArbre;

/*void linebreak(FILE* fichier){
    while(*fichier != '\n'){
        fgetc(fichier);
    }
}
*/
void nextsemicolon(FILE* fichier){
    fgetc(fichier);
    while(fgetc(fichier)!=';'){
       // fgetc(fichier);
    }
}



/*int extractvalue(FILE* fichier, int cap){
    fscanf(fichier, %d, cap);
    return cap;
}
*/
int height(pArbre a){
    if (a == NULL)
        return 0;
    return a->height;
}

pArbre addAVL(FILE* flux, pArbre a){
    int capa, cons;
    char tab[100];
    if(fscanf(flux,"%d",&capa)==-1){
    	printf("probleme nanana");
    	exit(3);
    }
    fscanf(flux,"%d", &cons);
    a->capacity=a->capacity + capa;
    a->consomation=a->consomation + cons;
    fgets(tab, 99,flux);
    return a;
}

pArbre crAVL(int i){
    pArbre a;
    a=malloc(sizeof(AVLcsv));
    a->capacity=0;
    /*if (a->capacity<=0){
        exit(1);
    }*/
    /*a->type=t;
    if (a->type<=0 || a->type>=4){
        exit(1);
    }*/
    a->id=i;
    if (a->id<=0){
        exit(1);
    }
    a->consomation=0;
    /*if (a->consomation<=0){
        exit(1);
    } */
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


pArbre insertAVL(pArbre a, FILE* flux, int i){
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
/*extract(FILE* entre, int nbcentrale, int t){
    int cen, int t, int cap, char* typeID, char* typeIDtmp;
    a=fgetc(fichier);
    while(a!=nbcentrale){
        linebreak(fichier);
        a=fgetc(fichier);
    }
    while(a==nbcentrale || ){    
        for(int i=0, i<t-1, i++){
            nextsemicolon(fichier);
        }
        fscanf(fichier,%d, &typeID);
        typeIDtmp=typeID;
        fscanf(fichier, %lf, &cap)
        linebreak(fichier);
        while(typeIDtmp==typeID && ){
            for(int j=0, j<t, j++){
                nextsemicolon;                  
            }
            
        }
            case 1:
                sort()
                break;
            case 2:
                nextsemicolon(fichier);
                sort;
                break;
            case 3:
                nextsemicolon(fichier);
                nextsemicolon(fichier);
                sort;
                break;
        }
    }
}*/


void extract(FILE* flux,int nbcent, int type, int constype){
    pArbre a=NULL;
    char i=fgetc(flux);
    
   	do{
    	a=insertAVL(a,flux,i);
    	printf("%c \n",i);
    	i=fgetc(flux);	
	}while(i!=EOF);
	printf("%c %d %d \n",a->id, a->capacity, a->consomation);
}

int main(int argc,char*argv[]){
    FILE* input=NULL;
    FILE* output=NULL;
    input=fopen(argv[1], "r");
    if(input==NULL){
    printf("%s\n",argv[1]);
    printf("pascoolbro");
    exit(2);
    }
    if(argv[2]<=0){
    	exit(2);
    }
    extract(input,atoi(argv[2]),atoi(argv[3]),atoi(argv[4]));  //argv1= nom du fichier argv2=num_centrale argv3=type argv4=consomateur
    
return 0;
}