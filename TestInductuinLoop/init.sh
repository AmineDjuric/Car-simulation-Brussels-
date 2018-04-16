#!/bin/bash

mkdir /home/SumoStats/
cd /usr/bin/amine/IL/

endTime=50400
beginTime=0

# To let n vehicles depart between times beginTime and endTime set the options :
# -b beginTime -e endTime -p ((endTime - beginTime) / n)
n=300 
# float substraction (mandatory to use bc command)
# Why float ? because --period (-p) take a float number in parameter

# This command will generate a random traffic demand

i=280 # /!\ != 0 !!!
while [ "$i" -le "$n" ]
do
	echo "Step number: $i"
	var="$(echo "$((endTime-beginTime)) / $i" | bc -l)"
	echo $var

	# This command will generate a random traffic demand
	python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -b $beginTime -e $endTime -p $var --trip-attributes="departLane=\"best\" departPos=\"random\""
	
	sumo map.sumo.cfg

	mkdir /home/SumoStats/$i/
	chmod 755 /home/SumoStats/$i/
	mv /usr/bin/amine/IL/InductionLoopsStatistics/* /home/SumoStats/$i/
	i=$((i+1))
done

# on supprime le dossier InductionLoopsStatistics, qui est vide et qui ne sert que temporairement à stocker les données des inductions loops durant la simulation
sudo rm -r InductionLoopsStatistics

# Apres les simulations on stocke le résultats des détecteurs de chaque simulation dans /home/SumoStats/
# on va ensuite comparer les données calculer les données virtuelles (de chaque simulation) avec les données réelles.
# Les données réelles sont dans le fichier "1hour_data_port_area.csv" et le fichier "aggregate.py" transforme ce fichier en un fichier "formatted.txt"

# lançons donc le code qui créer le fichier .txt qui contiendra les données réelles:
python3 aggregate.py
python3 store.py

chmod 755 parseXML.py
chmod 755 formattedDict.txt

mv formattedDict.txt /home/SumoStats/
mv  parseXML.py /home/SumoStats/

cd /home/SumoStats/

file1=$"/home/SumoStats/formattedDict.txt/*"
file2=$"/home/SumoStats/parseXML.py/*"


for folders in /home/SumoStats/*
do 
 	for files in $folders/*
 	do
 		if [ "$files" != "$file1" ] && [ "$files" != "$file2" ]
		then
			# Cette condition permet de ne pas parcourir le fichier "formattedDict.txt" et "parseXML.py" et
			# uniquement parcourir le dossiers de chaque itérations qui contiennent les fichiers ".xml" des inductions loops.
			# on va parser chaque fichier .xml et les comparer les données avec les données réelles.

			iterationNb="$folders"
			iterationNb=${iterationNb##*/}

 			python3 parseXML.py $files $iterationNb
 			break
 		fi
 	done 
done

bash

 