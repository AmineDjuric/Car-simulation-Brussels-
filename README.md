# docker-sumo

## The Map
Get the map file here:
`https://www.dropbox.com/s/cwv5kumol9vl9cp/map.zip?dl=0`
(The file is too heavy for Github)
Extract the file and put it in the same directory  as the docker file


## Build

1. Build the image with `sudo docker build -t amine/sumo .`
2. Run the image with
```
docker run -it --rm\
    --env="DISPLAY" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --user=$USER \
    amine/sumo \
    bash
    
```

3. For the simulation of Brussels which is already ready:
Go to `/usr/bin/amine` and execute the command: `sumo-gui map.sumo.cfg`

5. Execute `sumo` or `sumo-gui` if you just want to launch the application.
