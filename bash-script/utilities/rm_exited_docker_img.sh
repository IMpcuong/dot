#!/bin/bash

# NOTE:
# + `docker ps -a` := shows a list of all containers.
# + `awk ...` := prints the IDs of all containers having the status equivalence with "Exited".
#             := the string inside double backslashes are represented for a regex pattern in `awk`.
# + `tail -n +2` := omits/ignores the first line/record from the precedence command output.
# + `xargs docker rm` := removes all of the "Exited" images with the corresponded IDs.
docker ps -a |
  awk '{ if ($5 ~ /.*Exited.*/) print $1 }' |
  tail -n +2 |
  xargs docker rm

# The problem appeared when any fields from the stdout of the `docker ps -a` command contained
# the whitespace charater(s).
# Solved:
docker ps -a |
  awk '{ \
    for (line = 1; line <= NF; line++) { \
      if ($line ~ /.*Exited.*/) print $1 \
    } \
  }' | xargs docker rm -f

# NOTE: remove first matched `docker` image filtered by name.
docker images -a |
  grep "image_name" |
  head -n1 |
  awk '{ print $3 }' |
  xargs docker rmi -f

# Format command and log output: https://docs.docker.com/config/formatting/

# Exp:
# REPOSITORY                                  TAG                   IMAGE ID       CREATED       SIZE
# public.ecr.aws/sam/emulation-go1.x          rapid-1.33.0-x86_64   bb8f731c5f80   24 hours ago  842MB
# <none>                                      <none>                cae96ded44db   23 hours ago  834MB
# public.ecr.aws/sam/emulation-provided.al2   rapid-1.33.0-x86_64   1db3aa36ed22   22 hours ago  260MB
# <none>                                      <none>                1363266407ff   21 hours ago  252MB
# public.ecr.aws/sam/emulation-go1.x          latest                bb23c9751bfd   10 days ago   817MB
# public.ecr.aws/sam/emulation-provided.al2   latest-x86_64         56b0367ae68e   10 days ago   236MB
# ubuntu                                      latest                2dc39ba059dc   2 weeks ago   77.8MB
docker images -a --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" |
  tail -n+2 |
  grep -i public |
  awk '{ system("docker rmi " $1) }'

docker images -a | awk '/<none>/ { system("docker rmi -f " $3) }'

# Remove all exited docker images from our system.
docker images -a --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" |
  tail -n+2 |
  awk '/<none>/ { print $1 }' |
  xargs docker rmi -f

# Having the semantics as identical as the precedence command:
docker images -a --format "table {{ .ID }}\t{{ .Tag }}" |
  grep none |
  awk '{ print $1 }' |
  xargs docker rmi -f

# Get the digest from the image index of the image docker.io/library/debian:buster, for the amd64 CPU architecture and the linux operating system:
docker manifest inspect --verbose docker.io/library/debian:buster |
  jq -r 'if type=="object"
    then .Descriptor.digest
    else .[] | select(.Descriptor.platform.architecture=="amd64" and .Descriptor.platform.os=="linux") | .Descriptor.digest
    end'

# Join:
docker inspect --format '{{ join .Args " , " }}' container_name

# Json:
docker inspect --format '{{ json .Mounts }}' container_name

# Lower:
docker inspect --format "{{ lower .Name }}" container_name

# Upper:
docker inspect --format "{{ upper .Name }}" container_name

# Println:
docker inspect --format='{{ range .NetworkSettings.Networks }}{{ println .IPAddress }}{{end}}' container_name

# Split:
docker inspect --format '{{ split .Image ":" }}'

# Title:
docker inspect --format "{{ title .Name }}" container_name

docker inspect --format '{{ .Config.WorkingDir }}' container_name

# Hint: To find out what data can be printed, show all content as json:
docker container ls --format='{{ json . }}'
docker images -a --format='{{ json . }}'

# If you want to list only IDs from all images/containers:
# -> Just using option `-q, --quiet` := only show image/container IDs.
docker images -q
docker ps -a -q

# Stop/remove all Docker containers/images:
# Container:
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# Image:
docker rmi $(docker ps -a -q)

# Showing Docker filesystems' status:
docker system df

# Docker network commands:
docker network ls
# NETWORK ID     NAME                        DRIVER    SCOPE
# 8abfbeca3be0   bridge                      bridge    local
# 07bf14fbbe0f   host                        host      local
# cba7ab72b35a   none                        null      local
docker network inspect host
docker network inspect bridge

docker network connect bridge container_name

docker network disconnect bridge container_name
docker network disconnect host container_name
docker network create --driver bridge \
  --subnet 172.28.0.0/16 \
  --gateway 172.28.5.254 \
  --opt "dns=8.8.8.8" --opt "dns=127.0.0.11" my_network

docker network create --driver bridge \
  --opt "dns=8.8.8.8" --opt "dns=127.0.0.11" my_network

docker run --name my_container --network my_network -d nginx
docker exec my_container /bin/bash cat /etc/resolv.conf

docker network inspect --format='{{ range .IPAM.Config }} {{ .Gateway }} {{ end }}' bridge |
  awk -F "/" 'NR == 1 { print $1 }'

# NOTE: Monitoring docker-containers' resources usage with:
docker stats --all
docker stats $(docker ps | grep -v "NAMES" | awk '{ print $NF }' | tr "\n" " ")

# NOTE: Mount exact volumes for cAdvisor to collect desired metrics' data.
docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=127.0.0.1:11111:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:v0.47.2
