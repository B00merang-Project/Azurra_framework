#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -f "${D}/build.sh" ]; then   # is buildable
    echo "Building ${D}"

    cd "${D}"
    ./build.sh
    cd ..
  fi
done
