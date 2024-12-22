#!/bin/bash
nb_args=$#

#init time
time_start=$(date +%s)

if (( $# > 5 )) ;
then
	echo "error: too few argument"
	echo "time: 0 s"
	kill $$
else
	for i in $* ;
	do
		if [ $i == "-h" ] ;
		    	then
		    	if [ -e fichier_shell/help.txt ] ;
		    	then
		    		cat fichier_shell/help.txt
		    	else
		    		echo "error: file missing -> help.txt"
		    	fi
				echo "time: 0 s"
		    	kill $$
		fi
	done
	a=0
	if (( $# < 3 )) ;
	then
		a=1
		echo "error: argument missing"
		if [ -e fichier_shell/help.txt ] ;
		then
			cat fichier_shell/help.txt
		else
			echo "error: file missing -> help.txt"
		fi
		echo "time: 0 s"
		kill $$
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

	#verif File format
	verif_format=2
	if (( $(head -$verif_format $1 | grep .*";".*";".*";".*";".*";".*";".*";".* | wc -l) < $verif_format ));
	then
		echo "Warning: File didn't have good format"
	fi

	chemin_tab=$1
	type_station=$2
	consomateur_type=$3

	if (( $# == 4 )) ;
	then
		id_centrale=$4
	else
		id_centrale=-1
	fi

	#verif tmp
	if [ -e tmp ];
	then
		rm -r tmp
	fi
	mkdir tmp

	#verif executable c
	if [ ! -e Code_C/C-Wire-exe ] ;
	then
		echo "main.c compilation"
		make -C Code_C
	fi
	if [ ! -e Code_C/C-Wire-exe ];
	then
		a=1
		echo "error: compilation failed"
	fi

	#graphs
	if [ ! -e graphs ];
	then
		mkdir graphs
	fi

	#verif outpout
	if [ ! -e output ];
	then
		mkdir output
	fi

	#verif input
	if [ ! -e input ];
	then
		mkdir input
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
			echo "time: 0 s"
	    	kill $$
	fi

	#data processing
	if [ ! -e "input/$1" ];
	then
		cp $1 "input/$1"
	fi
	
	if (( id_centrale <= 0  )) ;
	then
		centrale_nb="[0-9]+"
	else
		centrale_nb=$id_centrale
	fi

	#delete lines based on HVB HVA LV comp indiv
	if [ $type_station == "hvb" ] ;
	then
		#hvb
		grep -E "^$centrale_nb;[0-9]+;-;-;" $chemin_tab | cut -d";" -f2,7- | tr "-" "0" > tmp/tmp.dat
		mv tmp/tmp.dat tmp/tab.dat
		
	elif [ $type_station == "hva" ] ;
	then
		#hva
		grep -E "^$centrale_nb;[0-9 -]+;[0-9]+;-;" $chemin_tab | cut -d";" -f3,7- | tr "-" "0" > tmp/tmp.dat
		mv tmp/tmp.dat tmp/tab.dat
	elif [ $type_station == "lv" ] ;
	then
		#lv
		#comp / indiv connect withs lv
		if [ $consomateur_type == "all" ] ;
		then
			grep -E "^$centrale_nb;-;[0-9 -]+;[0-9]+;" $chemin_tab | cut -d";" -f4,7- | tr "-" "0" > tmp/tmp.dat
		elif [ $consomateur_type == "comp" ] ;
		then
			grep -E "^$centrale_nb;-;[0-9 -]+;[0-9]+;[0-9 -]+;-;" $chemin_tab | cut -d";" -f4,7- | tr "-" "0" > tmp/tmp.dat
		elif  [ $consomateur_type == "indiv" ] ;
		then
			grep -E "^$centrale_nb;-;[0-9 -]+;[0-9]+;-;" $chemin_tab | cut -d";" -f4,7- | tr "-" "0" > tmp/tmp.dat
		fi
		mv tmp/tmp.dat tmp/tab.dat
	fi	

	#launch C programme
	if ([ $type_station == "lv"  ] && [ $consomateur_type == "all" ]);
	then
		minmax=1
	else
		minmax=0
	fi
	./Code_C/C-Wire-exe "tmp/tab.dat" $minmax

	#fichier result	
	#verif res_C
	if [ ! -e "tmp/res_c.csv" ];
	then
		echo "error: file res_c didn't exist"
		time_end=$(date +%s)
		res=$(( $time_end - $time_start ))
		echo "time: $res"
		kill $$
	fi

	#tier
	if (( $id_centrale > 0 )) ;
	then
		name="_$id_centrale"
	else
		name=""
	fi
	
	echo "Id_station:Capacity:Load" > output/"$type_station"_"$consomateur_type""$name".csv
	sort -t":" -n -r -k2 "tmp/res_c.csv" | cut -d":" -f-3 >> output/"$type_station"_"$consomateur_type""$name".csv
	#lv all
	if ([ $type_station == "lv"  ] && [ $consomateur_type == "all" ]);
	then
		echo "Id_station:Capacity:Load" > output/lv_all_minmax.csv
		sort -t":" -n -r -k2 "tmp/res_c.csv" | tail | sort -t":" -n -k4 | cut -d":" -f-3 >> output/lv_all_minmax.csv
		sort -t":" -n -r -k2 "tmp/res_c.csv" | head | sort -t":" -n -k4 | cut -d":" -f-3 >> output/lv_all_minmax.csv


		if [ $(tail -n +2 output/lv_all_minmax.csv | wc -l) != 0 ]
		then
			#graphs minmax
			gnuplot <<-EOF
			set terminal png font "Times new roman"
			set boxwidth 0.5
			set style fill solid
			set datafile separator ":"
			set output "graphs/lv_all_minmax.png"
			plot 'output/lv_all_minmax.csv' using 0:2 with boxes title "capacity" lt rgb "green", 'output/lv_all_minmax.csv' using 0:3 with boxes title "load" lt rgb "red"
			EOF
		fi
	fi
	
	if [ $(tail -n +2 output/${type_station}_${consomateur_type}${name}.csv | wc -l) != 0 ]
	then
		#graphs
		gnuplot <<-EOF
		set terminal png font "Times new roman"
		set boxwidth 0.5
		set style fill solid
		set datafile separator ":"
		set output "graphs/${type_station}_${consomateur_type}${name}.png"
		plot 'output/${type_station}_${consomateur_type}${name}.csv' using 0:2 with boxes title "capacity" lt rgb "green", 'output/${type_station}_${consomateur_type}${name}.csv' using 0:3 with boxes title "load" lt rgb "red"
		EOF
	fi

	time_end=$(date +%s)
	res=$(( $time_end - $time_start ))
	echo "time: $res s"
fi