#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -f "${D}/deploy.sh" ]; then  # is deployable

    cd "${D}"
    ./deploy.sh
    cd ..
  fi
done
