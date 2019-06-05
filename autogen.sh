#!/bin/bash

BASE="Azurra"

if [[ ! -z "$@" ]]
then
  for arg in "$@"
  do
    if [ -d "$arg" ] &&               # it's a directory
       [ "$arg" != "$BASE" ] &&	      # not the base theme
       [ -f "$arg/build.sh" ] &&      # is buildable
       [ -f "$arg/deploy.sh" ]; then  # is deployable
      echo "Building $arg"

      cd "$arg"
      ./build.sh
      ./deploy.sh
      cd ..
    else
      echo "Invalid directory ($arg)."
    fi
  done

  exit 0
fi

# build
for D in *; do
  if [ -d "${D}" ] &&               # it's a directory
     [ "${D}" != "$BASE" ] &&	      # not the base theme
     [ -f "${D}/build.sh" ] &&      # is buildable
     [ -f "${D}/deploy.sh" ]; then  # is deployable
    echo "Building ${D}"

    cd "${D}"
    ./build.sh
    ./deploy.sh
    cd ..
  fi
done
