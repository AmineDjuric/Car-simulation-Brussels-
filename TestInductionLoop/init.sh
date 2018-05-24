#!/bin/bash

# Author: Djuric Amine
# Contact: adjuric@ulb.ac.be

# This code is called automatically when you run the docker, that's the ENTRYPOINT command in the Dockerfile

###########################################################################################################
#                                      GENERATE RANDOM TRAFFIC DEMAND                                     #
###########################################################################################################

mkdir /home/SumoStats/

# This folder will contain as many .csv files that there are iterations.
# For examples, at the 300th iteration there will be a file named 300.csv (more details will be later supplied)
mkdir /home/SumoStats/Results1/
mkdir /home/SumoStats/Results2/

# This folder contains all the files in from TestInductionLoop directory
# (It contains all the files necessary for the simulation)
cd /usr/bin/amine/IL/

# 50400 seconds = 14 hours 
# We have chosen 14 hours because the sample we used represent 14 hours of data collection
endTime=50400
beginTime=0


n=1
nmax=100
i=1 # /!\ != 0 !!!
k=3

while [ "$n" -le "$nmax" ]
do
	mkdir /home/SumoStats/n_$n/

	i=1
	while [ "$i" -le "$k" ]
	do
		mkdir /home/SumoStats/n_$n/i_$i/
		echo "#############################################################"
		echo "n = $n"
		echo "simulation numéro: $i"
		echo "#############################################################"

		# float substraction (mandatory to use bc command)
		# Why float ? because --period (-p) take a float number in parameter
		var="$(echo "$((endTime-beginTime)) / $n" | bc -l)"
		# This command will generate a random traffic demand
		# See the file: randomTripsOptions.txt in the TestInductionLoop directory for more details
		python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -b $beginTime -e $endTime -p $var --vehicle-class bus --trip-attributes="departLane=\"random\" departSpeed=\"max\" departPos=\"random\""
		
		# We run the simulation with additional parameters specified in the config file named map.sumo.cfg
		sumo map.sumo.cfg

		# All the statistics from the induction loops are automatically send to the InductionLoopsStatistics directory
		# See the "file=" options in the inductionLoops.xml file.

		# We create a directory (with the iteration number as name) for each iteration.
		# Each directory contains the inductions loops output files (.xml) for this iteration. 
		mv /usr/bin/amine/IL/InductionLoopsStatistics/* /home/SumoStats/n_$n/i_$i/

		i=$((i+1))
	done
	n=$((n+1))
done

# We delete the file InductionLoopsStatistics, which is empty and which serves only temporarily to store the data of the inductions loops during the simulation
sudo rm -r InductionLoopsStatistics

###########################################################################################################
#                                           GATHERING STATISTICS                                          #
###########################################################################################################

# We are then going to compare the virtual given data (of every simulation) with the real data.
# The real data are in the file "1hour_data_port_area.csv and the file " aggregate.py " transforms this file into a file "formatted.txt"

# We are in /usr/bin/amine/IL/
# aggregate.py will create a .txt file containing the number of trucks and their average speed by street.
# If you want to see the file, type : nano /usr/bin/amine/IL/formatted.txt
python3 aggregate.py

# This python script will create a dictionnary containing : { DetectorName : (speed,NbOfVehicles), ... }
# And save this dictionnry in a .txt file -> formattedDict.txt (see pickle library for more details)
python3 store.py

mv formattedDict.txt /home/SumoStats/
mv parseXML.py /home/SumoStats/
mv writeFirstLine.py /home/SumoStats/
cp displayResults.py /home/SumoStats/Results1/
mv displayResults.py /home/SumoStats/Results2/

cd /home/SumoStats/

folder1=$"/home/SumoStats/Results1/displayResults.py"
folder2=$"/home/SumoStats/Results2/displayResults.py"

# We are now in /home/SumoStats/
# This loop is going to parse all the files .xml of statistics of the inductions loops (previously stored in the SumoStats directory) 
# and to get back these data to compare them with the real data. Once the deviation value is calculated between the real speed and the virtual speed 
# (for every detector), we store the result in one .csv file (one per iteration) having for name, the number of the iteration.
# If you want to see the one of thes files type: nano Results1/300.csv (example for the 300th iteration)

for folders in /home/SumoStats/*/*
do 
	if [ "$folders" != "$folder1" ] && [ "$folders" != "$folder2" ]
	then
		
		iterationNb="$folders"
		subFolderNb=${iterationNb##*/}

		tmp=${iterationNb##*/SumoStats}
		tmp2=${tmp%/*}
		folderNb=${tmp2:1} 
		
		if [ "$iterationNb" != "formattedDict.txt" ] && [ "$iterationNb" != "parseXML.py" ] && [ "$iterationNb" != "writeFirstLine.py" ]
		then
			python3 writeFirstLine.py $folderNb $subFolderNb
		fi

 		for files in $folders/*
 		do
 			python3 parseXML.py $files $folderNb $subFolderNb
	 	done
	fi
done

# The final stage thus is to calculate then the average of the results of all the detectors by iteration and to show them 
# in a graph to determine the minimum average gap.

cd Results1/
python3 displayResults.py $nmax $k

bash
 
