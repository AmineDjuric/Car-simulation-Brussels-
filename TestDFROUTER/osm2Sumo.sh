#!/bin/bash

#This code will automatically convert a map from OSM into a network in SUMO

cd /usr/bin/amine/DFROUTER/
netconvert --osm-files map.osm -o map.net.xml --roundabouts.guess --ramps.guess --junctions.join --tls.guess-signals --tls.discard-simple --tls.join
polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml

dfrouter --max-search-depth 100000 --keep-unfinished-routes --net-file map.net.xml --routes-output map.rou.xml --emitters-output vehicles.xml --detector-files detectors2.xml --measure-files dataTEST.csv --detectors-poi-output pointsOfInterest.xml  --revalidate-detectors 

#python /opt/sumo/tools/detector/flowrouter.py --net-file map.net.xml --routes-output map.rou.xml --emitters-output vehicles.xml --detector-file detectors2.xml --detector-flow-files dataTEST.csv --flow-poi-output pointsOfInterest.xml --params="departLane=\"best\" departSpeed=\"max\" type=\"bus" --revalidate-detectors

