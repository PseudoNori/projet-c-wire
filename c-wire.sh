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

	chemin_tab=$1
	type_station=$2
	consomateur_type=$3
	id_centrale=-1

	#verif tmp
	if [ -e tmp ];
	then
		`rm -r tmp`
	fi
	`mkdir tmp`
	
	#verif ID
	test=`sed "1,1d" $1 | sort | tail -1 | cut -d";" -f1`
	if (( $# == 4 )) && (( $4 <= $test )) ;
	then
		id_centrale=$4
	elif (( $# == 4 )) && (( $4 > $test )) ;
	then
		echo "error: incompatiblme Id (< $test)"
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

	#graphs
	if [ ! -e graphs ];
	then
		a=1
		echo "error: graphs file doesn't exist"
	fi
	
	#help
	if (( $a == 1 )) ;
	then
	    	if [ -e fichier_shell/help.txt ] ;
	    	then
	    		echo time: 0.0s
	    		cat fichier_shell/help.txt
	    	else
	    		echo "error: file missing -> help.txt"
	    	fi
	    	kill $$
	fi
	
	#init time
	time_start=$(date +%s)

	#data processing
	`cp $1 tmp/tab.dat`
	if (( id_centrale > -1  )) ;
	then
		#delete bad central lines.
	    	`grep "^$id_centrale;.*;.*;.*;.*;.*;.*;.*" tmp/tab.dat > tmp/tmp.dat`
	    	`mv tmp/tmp.dat tmp/tab.dat`
	fi
	
	#delete lines based on HVB HVA LV comp indiv
	if [ $type_station == "hvb" ] ;
	then
		#hvb
		`grep -E "^[0-9]+;[0-9]+;-;-;-;-;[0-9]+;-" tmp/tab.dat >> tmp/tmp.dat`
		#comp connect withs hvb
		`grep -E "^[0-9]+;[0-9]+;-;-;[0-9]+;-;-;[0-9]+" tmp/tab.dat >> tmp/tmp.dat`
		`mv tmp/tmp.dat tmp/tab.dat`

		#delete column
		`more tmp/tab.dat | cut -d";" -f2,5- > tmp/tmp.dat`
		`mv tmp/tmp.dat tmp/tab.dat`
		
		
	elif [ $type_station == "hva" ] ;
	then
		#hva
		`grep -E "^[0-9]+;[0-9]+;[0-9]+;-;-;-;[0-9]+;-" tmp/tab.dat >> tmp/tmp.dat`
		#comp connect withs hva
		`grep -E "^[0-9]+;-;[0-9]+;-;[0-9]+;-;-;[0-9]+" tmp/tab.dat >> tmp/tmp.dat`
		`mv tmp/tmp.dat tmp/tab.dat`

		#delete column
		`more tmp/tab.dat | cut -d";" -f3,5- > tmp/tmp.dat`
		`mv tmp/tmp.dat tmp/tab.dat`
	elif [ $type_station == "lv" ] ;
	then
		#lv
		`grep -E "^[0-9]+;-;[0-9]+;[0-9]+;-;-;[0-9]+;-" tmp/tab.dat >> tmp/tmp.dat`
		#comp / indiv connect withs lv
		if [ $consomateur_type == "all" ] || [ $consomateur_type == "comp" ] ;
		then
			`grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;-;[0-9]+" tmp/tab.dat >> tmp/tmp.dat`
		fi
		if [ $consomateur_type == "all" ] || [ $consomateur_type == "indiv" ] ;
		then
			`grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;-;[0-9]+" tmp/tab.dat >> tmp/tmp.dat`
		fi
		`mv tmp/tmp.dat tmp/tab.dat`

		#delete column
		`more tmp/tab.dat | cut -d";" -f4,5- > tmp/tmp.dat`
		`mv tmp/tmp.dat tmp/tab.dat`
	fi
	`cat tmp/tab.dat | tr "-" "0" > tmp/tmp.dat`
	`mv tmp/tmp.dat tmp/tab.dat`

#launche C programme
	
	kill $$
##graphs
##fichier result
	#time_end=$(date +%s)
	#res= (( &time_end - $time_start ))
	#echo "time: $res"
fi
