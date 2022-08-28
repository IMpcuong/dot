#!/bin/bash

# NOTE:
# + `docker ps -a` := shows a list of all images.
# + `awk ...` := prints the IDs of all images having the status equivalence with "Exited".
#             := the string inside double backslashes are represented for a regex pattern in `awk`. 
# + `tail -n +2` := omits/ignores the first line/record from the precedence command output.
# + `xargs docker rm` := removes all of the "Exited" images with the corresponded IDs.
docker ps -a | \
  awk '{ if ($5 ~ /.*Exited.*/) print $1 }' | \
  tail -n +2 | \
  xargs docker rm
