#! /usr/bin/bash

# NOTE: Required super-user's privileges.
ps aux | grep docker | \
  awk '{ print $2 }' | \
  xargs -I {} sh -c "strings /proc/{}/environ" | \
  grep -i reg

docker volume create gitlab-runner-config
docker run -d --name gitlab-runner --restart always \
  -v '/var/run/docker.sock:/var/run/docker.sock' \
  -v '/home/runner/gitlab-runner:/etc/gitlab-runner' \
  -e 'http_proxy=http://10.10.10.10:1111' \
  -e 'https_proxy=http://10.10.10.10:1111' \
  -e 'no_proxy=https://gitlab.org.com' \
  gitlab/gitlab-runner:latest

declare -x container=$1
docker container inspect $container -f "table {{.Config}}"

# NOTE: Required super-user's privileges.
systemctl restart docker; chmod 666 /var/run/docker.sock

declare -a volumes=($(docker volume ls | tail -n+2 | awk '{ print $2 }'))
for v in ${volumes[@]}; do
  printf "%s\n" $v
  if [[ $v == *"gitlab"* ]]; then
    docker volume inspect $v
    break
  fi
done
