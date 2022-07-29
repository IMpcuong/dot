#!/bin/bash

python - "$@" <<'EOF'
import sys, os.path, glob

target = os.path.abspath(sys.argv[1])
for name in glob.glob("/proc/*/cwd"):
  if os.path.abspath(name) == target:
    print(name.split('/')[-2])
EOF