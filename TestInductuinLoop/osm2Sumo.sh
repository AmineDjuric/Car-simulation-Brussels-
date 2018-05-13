#!/bin/bash

# This code will automatically convert a map from OSM into a network in SUMO


cd /usr/bin/amine/IL/

netconvert --osm-files map.osm -o map.net.xml --default.speed 13.8 --roundabouts.guess --ramps.guess --junctions.join true --tls.guess-signals true --tls.discard-simple true --tls.join true

# --junctions.join : Joins junctions that are close to each other (recommended for OSM import); default: false
# --tls.guess-signals : Interprets tls nodes surrounding an intersection as signal positions for a larger TLS. This is typical pattern for OSM-derived networks; default: false
# --tls.discard-simple : Does not instatiate traffic lights at geometry-like nodes loaded from other formats than XML; default: false
# --tls.join  : Tries to cluster tls-controlled nodes; default: false

polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml
