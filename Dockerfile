FROM ubuntu:16.04

MAINTAINER Djuric Amine (adjuric@ulb.ac.be)
LABEL Description="Simulation of Urban MObility(SUMO)"

ENV SUMO_VERSION 0.32.0
ENV SUMO_HOME /opt/sumo
ENV SUMO_USER amine

# Install system dependencies.
RUN apt-get update && apt-get -qq install wget g++ make libxerces-c-dev libfox-1.6-0 libfox-1.6-dev python nano libproj-dev unzip sudo python3 bc

# Download and extract source code
RUN wget http://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz
RUN tar xzf sumo-src-$SUMO_VERSION.tar.gz && mv sumo-$SUMO_VERSION $SUMO_HOME && rm sumo-src-$SUMO_VERSION.tar.gz

#RUN wget www.dlr.de/ts/en/Portaldata/16/Resources/projekte/sumo/sumo-src-$SUMO_VERSION.zip
#RUN unzip sumo-src-$SUMO_VERSION.zip && mv sumo-$SUMO_VERSION $SUMO_HOME && rm sumo-src-$SUMO_VERSION.zip

# Configure and build from source.
RUN cd $SUMO_HOME && ./configure && make install

RUN export uid=1000 gid=1000
RUN mkdir -p amine/sumo
RUN echo "amine:x:${uid}:${gid}:Amine,,,:amine/sumo:/bin/bash" >> /etc/passwd
RUN echo "amine:x:${uid}:" >> /etc/group
RUN echo "amine ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/amine
RUN chmod 0440 /etc/sudoers.d/amine
RUN chown ${uid}:${gid} -R amine/sumo
USER amine
ENV HOME opt/sumo
CMD sumo-gui

RUN export SUMO_HOME="/opt/sumo"

RUN mkdir /usr/bin/amine

RUN mkdir /usr/bin/amine/EntireBxl

RUN mkdir /usr/bin/amine/BxlCenter

ADD map/* /usr/bin/amine/EntireBxl/

ADD map2/* /usr/bin/amine/BxlCenter/

RUN mkdir /usr/bin/amine/testDFROUTER/

ADD TestDFROUTER/* /usr/bin/amine/testDFROUTER/

RUN mkdir /usr/bin/amine/portDeBruxelles

ADD PortDeBruxelles/* /usr/bin/amine/portDeBruxelles/

ADD TestInductionLoop/* /usr/bin/amine/IL/

RUN mkdir /usr/bin/amine/IL/InductionLoopsStatistics/

#RUN /usr/bin/amine/portDeBruxelles/./osm2Sumo.sh

RUN /usr/bin/amine/IL/./osm2Sumo.sh

#RUN /usr/bin/amine/testDFROUTER/./osm2Sumo.sh 

ENTRYPOINT ["/usr/bin/amine/IL/init.sh"]

#ENTRYPOINT ["/usr/bin/amine/testDFROUTER/init.sh"]
