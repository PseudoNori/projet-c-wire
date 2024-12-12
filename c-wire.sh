#!/bin/bash
nb_args=$#
if (( $# > 5 )) ;
then
	echo "error: too few argument"
	kill $$
else
	for i in $* ;
	do
		if [ $i == "-h" ];
		    	then
		    	if [ -e fichier_shell/help.txt ] ;
		    	then
		    		cat fichier_shell/help.txt
		    	else
		    		echo "error: file missing -> help.txt"
		    	fi
		    	kill $$
		fi
	done
	a=0
	if (( $# < 3 )) ;
	then
		a=1
		echo "error: argument missing"
	fi

	##check argument
	#verif file
	if [ ! -e $1  ] ;
	then
		a=1
		echo "error: file missing -> $1"
	fi

	#verif file extension
	if [ ${1##*.} != "dat" ] && [ ${1##*.} != "csv" ] ;
	then
		a=1
		echo "error: file extension"
	fi

	#verif station type
	if [ $2 != "hvb" ] && [ $2 != "hva" ] && [ $2 != "lv" ] ;
	then
		a=1
		echo "error: station type, (hvb hva lv)"
		echo $2
	fi

	#verif consumer type
	if [ $3 != "comp" ] && [ $3 != "indiv" ] && [ $3 != "all" ] ;
	then
		a=1
		echo "error: consumer type, (comp indiv all)"
	fi

	#verif argument combinaison
	if ( [ $2 == "hvb" ] && ( [ $3 == "all" ] || [ $3 == "indiv" ] )) || ( [ $2 == "hva" ] && ( [ $3 = "all" ] || [ $3 == "indiv" ] )) ;
	then
		a=1
		echo "error: argument combinaison, (hvb + all/ hvb + indiv / hva + all/ hva + indiv)"
	fi

	chemin_tab=$2
	type_station=$3
	consomateur_type=$4
	id_centrale=-1
	
	##prb si le tableau n'est pas trier (ne pas utiliser tail) + prb d'affichage
	test= tail -1 $1 | cut -d";" -f1
	if (( $# == 4 )) && [ $4 <= test ];
	then
		id_centrale=$4
	elif (( $# == 4 )) && [ $4 > test ] ;
	then
		echo "error: incompatiblme Id (<$test)"
		a=1
	fi

	#verif executable c
#	if [ ! -e c-wire-exe ] && [ -e main.c ];
#	then
#		echo "main.c compilation"
#		`make`
#	elif [ -e main.c ] ;
#	then
#		a=1
#		echo "error: main.c doesn't exist"
#	fi
#	if [ ! -e c-wire-exe ];
#	then
#		a=1
#		echo "error: compilation failed"
#	fi

	#verif tmp
##changer l'extension de tmp?
	if [ -e tmp.csv ];
	then
		`rm tmp.csv`
	fi
	`touch tmp.csv`

	#graphs
##a voir l'extension du graphe.???
	if [ ! -e graphs.??? ];
	then
		a=1
		echo "error: graphs file doesn't exist"
	fi
	
	#help
	if (( $a == 1 )) ;
	then
	    	if [ -e fichier_shell/help.txt ] ;
	    	then
	    		cat fichier_shell/help.txt
	    	else
	    		echo "error: file missing -> help.txt"
	    	fi
	    	kill $$
	fi
	
##init time
	#traitement des données
	if (( id_centrale != -1  )) ;
	then
	    	#supprimer les ligne des mauvaise centrale.
	fi
	#suprimmer lignes en fonction de HVB HVB LV comp indiv
	#supprimer colomnes 2/3.
	
	#
##graphs
##fichier result
fi


