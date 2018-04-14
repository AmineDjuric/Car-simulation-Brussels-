# docker-sumo

## Build

1. Build the image with `sudo docker build -t amine/sumo -f ./Dockerfile .`

2. Run the image with
```
xhost +local:root && \
sudo docker run --name="SumoContainer" \
    -it \
    --rm --name SumoContainer \
	--user=$USER \
    --env="DISPLAY" \
    --workdir="/home/$USER" \
    --volume="/home/$USER:/home/$USER" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    amine/sumo \
    /bin/bash
```

3. For the simulation of Brussels which is already ready:
Go to `/usr/bin/amine` and execute the command: `sumo-gui map.sumo.cfg` on the map you want

4. Execute `sumo` or `sumo-gui` if you just want to launch the application.


## Useful commands : 
- Copy from host to container: `sudo docker cp /path/of/file/to/copy/filename containerID:/destination/in/container/ `

- Copy from container to host: `sudo docker cp containerID:/path/of/file/to/copy/filename /destination/in/host/`





