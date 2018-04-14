#!/bin/bash

#This code will automatically convert a map from OSM into a network in SUMO


cd /usr/bin/amine/IL/
netconvert --osm-files map.osm -o map.net.xml --roundabouts.guess --ramps.guess --junctions.join --tls.guess-signals --tls.discard-simple --tls.join
polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml

