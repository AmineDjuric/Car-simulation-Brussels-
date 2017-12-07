FROM ubuntu:16.04

MAINTAINER Djuric Amine (adjuric@ulb.ac.be)
LABEL Description="Simulation of Urban MObility(SUMO)"

ENV SUMO_VERSION 0.31.0
ENV SUMO_HOME /opt/sumo
ENV SUMO_USER amine

# Install system dependencies.
RUN apt-get update && apt-get -qq install \
    wget \
    g++ \
    make \
    libxerces-c-dev \
    libfox-1.6-0 libfox-1.6-dev \
    python2.7 \   

# Download and extract source code

RUN unzip sumo-src-$SUMO_VERSION.zip && \
    mv sumo-$SUMO_VERSION $SUMO_HOME && \
    rm sumo-src-$SUMO_VERSION.zip

# Configure and build from source.
RUN cd $SUMO_HOME && ./configure && make install

RUN adduser $SUMO_USER --disabled-password
# CMD sumo-gui

RUN mkdir /usr/bin/amine

ADD map/* /usr/bin/amine/


