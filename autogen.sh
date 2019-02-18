#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -f "${D}/build.sh" ] &&      # is buildable
     [ -f "${D}/deploy.sh" ]; then  # is deployable
    echo "Building ${D}"

    cd "${D}"
    ./build.sh
    ./deploy.sh
    cd ..
  fi
done

