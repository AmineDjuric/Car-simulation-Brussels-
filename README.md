# docker-sumo

## Build

1. Build the image with `sudo docker build -t amine/sumo -f ./Dockerfile .`

2. Run the image with
```
xhost +local:root && \
sudo docker run --name="SumoContainer" \
    -it \
    --rm --name SumoContainer \
	--user=amine \
    --env="DISPLAY" \
    --workdir="/home/amine" \
    --volume="/home/amine:/home/amine" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    amine/sumo \
    /bin/bash
```


## Useful commands : 
- To get the container id : `containterId=$(sudo docker ps -aq --filter name=SumoContainer)`

- Copy from host to container: `sudo docker cp /path/of/file/to/copy/filename $containterId:/destination/in/container/ `

- Copy from container to host: `sudo docker cp $containterId:/path/of/file/to/copy/filename /destination/in/host/`

- To stop the container : `sudo docker stop SumoContainer`

- To erase all the docker images on you computer (not only SumoContainer's image) : `sudo docker system prune -a` 




