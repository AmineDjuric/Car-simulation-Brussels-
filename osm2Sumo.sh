#!/bin/bash

#This code will automatically convert a map from OSM into a network in SUMO

cd /usr/bin/amine/BxlCenter/
netconvert --osm-files map.osm -o map.net.xml --roundabouts.guess --ramps.guess --junctions.join --tls.guess-signals --tls.discard-simple --tls.join
polyconvert --net-file map.net.xml --osm-files map.osm --type-file typemap.xml -o map.poly.xml

python /opt/sumo/tools/randomTrips.py -n map.net.xml -r map.rou.xml --verbose --trip-attributes="departLane=\"best\" departSpeed=\"max\" departPos=\"random\"" --verbose true
#--period=2.0 --binomial=2 


# randomTrips.py options:
# http://sumo.dlr.de/wiki/Tools/Trip#randomTrips.py

# -n NETFILE, --net-file=NETFILE
#                        define the net file (mandatory)
#
# -r ROUTEFILE, --route-file=ROUTEFILE
#                        generates route file with duarouter
#
# -b BEGIN, --begin=BEGIN begin time
#
# -e END, --end=END     end time (default 3600)
#
# -p PERIOD, --period=PERIOD
#                        Generate vehicles with equidistant departure times and
#                        period=FLOAT (default 1.0). If option --binomial is
#                        used, the expected arrival rate is set to 1/period.
#
#
# -s SEED, --seed=SEED  random seed
#
# -l, --length          weight edge probability by length
#
# -L, --lanes           weight edge probability by number of lanes
#
# --binomial=N          If this is set, the number of departures per seconds
#                        will be drawn from a binomial distribution with n=N
#                        and p=PERIOD/N where PERIOD is the argument given to
#                        option --period. Tnumber of attemps for finding a trip
#                        which meets the distance constraints
#
# --validate            Whether to produce trip output that is already checked
#                       for connectivity
#
# -v, --verbose         tell me what you are doing
