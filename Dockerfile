FROM ubuntu:16.04

MAINTAINER Djuric Amine (adjuric@ulb.ac.be)
LABEL Description="Simulation of Urban MObility(SUMO)"

ENV SUMO_VERSION 0.32.0
ENV SUMO_HOME /opt/sumo
ENV SUMO_USER amine

# Install system dependencies.
RUN apt-get update && apt-get -qq install wget g++ make libxerces-c-dev libfox-1.6-0 libfox-1.6-dev python nano libproj-dev unzip

# Download and extract source code
RUN wget http://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz
RUN tar xzf sumo-src-$SUMO_VERSION.tar.gz && mv sumo-$SUMO_VERSION $SUMO_HOME && rm sumo-src-$SUMO_VERSION.tar.gz

#RUN wget www.dlr.de/ts/en/Portaldata/16/Resources/projekte/sumo/sumo-src-$SUMO_VERSION.zip
#RUN unzip sumo-src-$SUMO_VERSION.zip && mv sumo-$SUMO_VERSION $SUMO_HOME && rm sumo-src-$SUMO_VERSION.zip

# Configure and build from source.
RUN cd $SUMO_HOME && ./configure && make install

RUN adduser $SUMO_USER --disabled-password
# CMD sumo-gui

RUN mkdir /usr/bin/amine

RUN mkdir /usr/bin/amine/EntireBxl

RUN mkdir /usr/bin/amine/BxlCenter

ADD map/* /usr/bin/amine/EntireBxl/

ADD map2/* /usr/bin/amine/BxlCenter/

ADD osm2Sumo.sh /usr/bin/amine/BxlCenter/

RUN chmod 755 /usr/bin/amine/BxlCenter/osm2Sumo.sh

ADD typemap.xml /usr/bin/amine/BxlCenter/

RUN export SUMO_HOME="/opt/sumo"

RUN /usr/bin/amine/BxlCenter/./osm2Sumo.sh

ADD init.sh /usr/bin/

ENTRYPOINT ["/usr/bin/init.sh"] 



