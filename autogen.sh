#!/bin/bash

BASE="Azurra"

# build
for D in *; do
  if [ -d "${D}" ] &&               # it's a directory
     [ "${D}" != "$BASE" ] &&	    # not the base theme
     [ -f "${D}/build.sh" ] &&      # is buildable
     [ -f "${D}/deploy.sh" ]; then  # is deployable
    echo "Building ${D}"

    cd "${D}"
    ./build.sh
    ./deploy.sh
    cd ..
  fi
done
