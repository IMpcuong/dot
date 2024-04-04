#!/bin/bash

declare DOCKER_RUN_OPTIONS="-i --rm"
declare IMAGE_NAME="pahud/aws-sam-cli"

# Only allocate tty if we detect one
if [ -t 0 ] && [ -t 1 ]; then
  DOCKER_RUN_OPTIONS="${DOCKER_RUN_OPTIONS} -t"
fi

docker --version
declare -i container=$(docker ps -a | wc -l)
if (( "${container}" > 1 )); then
  docker rm $(docker ps -a -q)
  docker container prune # Remove all stopped containers.
fi
docker images -a --format "table {{ .ID }}\t{{ .Repository }}\t{{ .Tag }} | \
  awk '{ print $2 }' | \
  grep sam
if (( $? != 0 )); then docker pull ${IMAGE_NAME}; fi

docker run ${DOCKER_RUN_OPTIONS} \
  --env "HOME=/home/samcli" \
  "${IMAGE_NAME}:latest" \
  sam --version
docker ps -a --format "table {{ .ID }}\t{{ .Image }} | \
  grep sam | \
  awk '{ print $1 }' | \
  xargs docker inspect --format "{{ .Config.Env }}

docker run ${DOCKER_RUN_OPTIONS} \
  --privileged \
  -p 9999:80 \
  --mount type=bind,source=$(pwd),target=/home/samcli \
  "${IMAGE_NAME}:latest" \
  sam build -t "$(pwd)/template.yaml"
ls -halt
docker run -id --rm "${IMAGE_NAME}:latest" sam deploy --config-file ./samconfig.toml --config-env test --debug
docker ps -a
