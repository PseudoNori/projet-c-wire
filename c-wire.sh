#!/bin/bash
nb_args=$#
if (( $# >= 5 )) ;
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
	#check argument
	if [ ! -e $1  ] ;
	then
		a=1
		echo "error: file missing -> $1"
	fi
###### verif l'éxtension du fichier!
	if [ ! -e $1  ] ;
	then
		a=1
		echo "error: file missing"
	fi
########
	if [ $2 != "hvb" ] || [ $2 != "hva" ] || [ $2 != "lv" ] ;
	then
		a=1
		echo "error: station type, (hvb hva lv)"
	fi
	if [ $3 != "comp" ] || [ $3 != "indiv" ] || [ $3 != "all" ] ;
	then
		a=1
		echo "error: consumer type, (comp indiv all)"
	fi
	
	chemin_tab=$1
	type_station=$2
	consomateur_type=$3

##prb si le tableau n'est pas trier ( ne pas utiliser tail)
	test= tail -1 $1 | cut -d";" -f1
	if (( $# == 4 )) && [ $4 <= test ];
	then
		id_centrale=$4
	else
		echo "error: incompatoblme Id (<$test)"
		a=1
	fi
	
	if (( $a == 1 )) ;
	then
		kill $$
	fi
fi



