#!/bin/bash

#containterId=$(sudo docker inspect -f '{{.Id}}' SumoContainer)
containterId=$(sudo docker ps -aq --filter name=SumoContainer)

mkdir /home/SumoStats/
mkdir /home/SumoStats/testNb$1
#sudo chmod 755 /home/SumoStats/
sudo docker cp /usr/bin/amine/IL/InductionLoopsStatistics/* $containterId:/home/SumoStats/

