#!/bin/bash

declare -x cred="admin:password"

declare -x encoded=$(
  python - <<EOF
#!/usr/bin/env python

import base64
encoded = base64.b64encode(b"$cred")
print(encoded)
EOF
)

# Get all images from all registry projects:
declare -x artifact_url="https://registry.harbor.io/api/v2.0/projects/devops/repositories/something/artifacts"
declare -a tags=$(
  curl -sSX 'GET' "$artifact_url" \
    -H "authorization: Basic $encoded" \
    -H 'accept: application/json' |
    jq '.[].tags | .[].name' |
    while read -r tag; do
      grep -E "(\d{1,}\.){2,}\d{1,}" <<<"$tag" |
        sed 's/"//g' |
        awk '{ print substr($1, 5, 2) }'
    done
)

declare -i major_ver=0 minor_ver=1
# FIXME: If we pull an older artifact version from the private registry, this operation shall be false.
#   The reason behind this seems like nonsense based on the decending timeline order
#   from the stdout of `docker images -a` command.
declare -i latest_ver=$(($(docker images -a | awk '{ if ($1 ~ /^registry.*/) print substr($2, 5, 2) }' | head -n1) + 1))
declare -x usr="impcuong" img="something" registry="registry.harbor.io/devops"

for tag in $tags; do
  printf "+ Habor $s's image tag: %s\n" "$img" "$tag"
  if [[ -n "$latest_ver" ]]; then
    latest_ver=$(($(echo "$tags" | head -n1) + 1))
  fi
done

if (($latest_ver > 19)); then
  let "minor_ver +=1"
  let "latest_ver = 0"
  if (($minor_ver > 8)); then
    let "major_ver += 1"
    let "latest_ver = 0"
  fi
fi

docker build --tag "$usr/$img:$major_ver.$minor_ver.$latest_ver" .
docker build --tag "$usr/$img:latest" .

docker tag "$usr/$img:$major_ver.$minor_ver.$latest_ver" "$registry/$img:$major_ver.$minor_ver.$latest_ver"
docker tag "$usr/$img:latest" "$registry/$img:latest"

docker push "$registry/$img:$major_ver.$minor_ver.$latest_ver"
docker push "$registry/$img:latest"
