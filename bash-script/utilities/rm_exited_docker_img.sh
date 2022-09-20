#!/bin/bash

# NOTE:
# + `docker ps -a` := shows a list of all containers.
# + `awk ...` := prints the IDs of all containers having the status equivalence with "Exited".
#             := the string inside double backslashes are represented for a regex pattern in `awk`.
# + `tail -n +2` := omits/ignores the first line/record from the precedence command output.
# + `xargs docker rm` := removes all of the "Exited" images with the corresponded IDs.
docker ps -a | \
  awk '{ if ($5 ~ /.*Exited.*/) print $1 }' | \
  tail -n +2 | \
  xargs docker rm

# NOTE: remove first matched `docker` image filtered by name.
docker images -a | \
  grep "image_name" | \
  head -n1 | \
  awk '{ print $3 }' | \
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
docker images -a --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | \
  tail -n+2 | \
  grep -i public | \
  awk '{ system("docker rmi " $1) }'

# Join:
docker inspect --format '{{join .Args " , "}}' container_name

# Json:
docker inspect --format '{{json .Mounts}}' container_name

# Lower:
docker inspect --format "{{lower .Name}}" container_name

# Upper:
docker inspect --format "{{upper .Name}}" container

# Println:
docker inspect --format='{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' container_name

# Split:
docker inspect --format '{{split .Image ":"}}'

# Title:
docker inspect --format "{{title .Name}}" container_name

# Hint: To find out what data can be printed, show all content as json:
docker container ls --format='{{json .}}'
docker images -a --format='{{json .}}'
