#!/bin/bash

mkdir /home/SumoStats/
cd /usr/bin/amine/IL/


n=2
endTime=50400
beginTime=0

# To let n vehicles depart between times beginTime and endTime set the options :
# -b beginTime -e endTime -p ((endTime - beginTime) / n)

tmp=$((endTime-beginTime))

 # float substraction (mandatory to use bc command)

# Why float ? because --period (-p) take a float number in parameter

# This command will generate a random traffic demand
#python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -b $beginTime -e $endTime -p $var --trip-attributes="departLane=\"best\" departPos=\"random\""
nbOfSimulation=302
i=300
while [ "$i" -le "$nbOfSimulation" ]
do
	echo "Step number: $i"
	var="$(echo "$tmp / $i" | bc -l)"
	echo $var
	python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -b $beginTime -e $endTime -p $var --trip-attributes="departLane=\"best\" departPos=\"random\""
	sumo map.sumo.cfg

	mkdir /home/SumoStats/testNb$i/
	mv /usr/bin/amine/IL/InductionLoopsStatistics/* /home/SumoStats/testNb$i/

	i=$((i+1))
done

bash

