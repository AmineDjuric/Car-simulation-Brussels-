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

3. When the simulation ends, you have to open another terminal (without closing the docker !) and type:

( - `containterId=$(sudo docker ps -aq --filter name=SumoContainer)`

 - `sudo docker cp $containterId:/home/SumoStats/ /home/amine/Desktop`

)


 -> `sudo docker cp SumoContainer:/home/SumoStats/ /home/amine/Desktop`



## Useful commands : 
- Copy from host to container: `sudo docker cp /path/of/file/to/copy/filename containerID:/destination/in/container/ `

- Copy from container to host: `sudo docker cp containerID:/path/of/file/to/copy/filename /destination/in/host/`





