#!/bin/bash

#This code will automatically convert a map from OSM into a network in SUMO

cd /usr/bin/amine/IL/
netconvert --osm-files map.osm -o map.net.xml --roundabouts.guess --ramps.guess --junctions.join --tls.guess-signals --tls.discard-simple --tls.join
polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml
python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random\"" --seed 666 --vehicle-class bus

#dfrouter --net-file map.net.xml --routes-output map.rou.xml --emitters-output vehicles.xml --detector-files detectors.xml --measure-files data.csv --detectors-poi-output pointsOfInterest.xml  --revalidate-detectors
