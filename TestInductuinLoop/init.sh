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
mkdir /home/SumoStats/Results/

# This folder contains all the files in from TestInductionLoop directory
# (It contains all the files necessary for the simulation)
cd /usr/bin/amine/IL/

# 50400 seconds = 14 hours 
# We have chosen 14 hours because the sample we used represent 14 hours of data collection
endTime=50400
beginTime=0

# To let n vehicles depart between times beginTime and endTime set the options :
# -b beginTime -e endTime -p ((endTime - beginTime) / n)
n=300 
i=298 # /!\ != 0 !!!

# if $i is equal to 1 and $n to 1000:
# this loop will run 1000 simulation with for the first lauch 1 vehicle generated and for the last 1000 vehicles
# $i is the step and also the number of vehicles generated at the step of the loop

while [ "$i" -le "$n" ]
do
	echo "Step number: $i"

	# float substraction (mandatory to use bc command)
	# Why float ? because --period (-p) take a float number in parameter
	var="$(echo "$((endTime-beginTime)) / $i" | bc -l)"
	
	# This command will generate a random traffic demand
	# See the file: randomTripsOptions.txt in the TestInductionLoop directory for more details
	python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -b $beginTime -e $endTime -p $var --trip-attributes="departLane=\"best\" departPos=\"random\""
	
	# We run the simulation with additional parameters specified in the config file named map.sumo.cfg
	sumo map.sumo.cfg

	# All the statistics from the induction loops are automatically send to the InductionLoopsStatistics directory
	# See the "file=" options in the inductionLoops.xml file.

	# We create a directory (with the iteration number as name) for each iteration.
	# Each directory contains the inductions loops output files (.xml) for this iteration. 
	mkdir /home/SumoStats/$i/
	mv /usr/bin/amine/IL/InductionLoopsStatistics/* /home/SumoStats/$i/
	i=$((i+1))
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
mv displayResults.py /home/SumoStats/Results/

cd /home/SumoStats/

file1=$"/home/SumoStats/formattedDict.txt/*"
file2=$"/home/SumoStats/parseXML.py/*"
file3=$"/home/SumoStats/writeFirstLine.py/*"
folder1=$"/home/SumoStats/Results"

# We are now in /home/SumoStats/
# This loop is going to parse all the files .xml of statistics of the inductions loops (previously stored in the SumoStats directory) 
# and to get back these data to compare them with the real data. Once the deviation value is calculated between the real speed and the virtual speed 
# (for every detector), we store the result in one .csv file (one per iteration) having for name, the number of the iteration.
# If you want to see the one of thes files type: nano Results/300.csv (example for the 300th iteration)

for folders in /home/SumoStats/*
do 
	if [ "$folders" != "$folder1" ]
	then
		iterationNb="$folders"
		iterationNb=${iterationNb##*/}

		if [ "$iterationNb" != "formattedDict.txt" ] && [ "$iterationNb" != "parseXML.py" ] && [ "$iterationNb" != "writeFirstLine.py" ]
		then
			python3 writeFirstLine.py $iterationNb
		fi

	 	for files in $folders/*
	 	do
	 		if [ "$files" != "$file1" ] && [ "$files" != "$file2" ] && [ "$files" != "$file3" ]
			then
	 			python3 parseXML.py $files $iterationNb
	 		fi
	 	done
	fi
done

# The final stage thus is to calculate then the average of the results of all the detectors by iteration and to show them 
# in a graph to determine the minimum average gap.
cd Results
python3 displayResults.py

bash
 