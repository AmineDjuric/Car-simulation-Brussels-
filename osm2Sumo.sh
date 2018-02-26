#!/bin/bash

#This code will automatically convert a map from OSM into a network in SUMO

cd /usr/bin/amine/BxlCenter/
netconvert --osm-files map.osm -o map.net.xml --roundabouts.guess --ramps.guess --junctions.join --tls.guess-signals --tls.discard-simple --tls.join
polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml

python /opt/sumo/tools/randomTrips.py -n map.net.xml -e 4000 -l
python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml -e 4000 -l


# randomTrips.py options:
# http://sumo.dlr.de/wiki/Tools/Trip#randomTrips.py
