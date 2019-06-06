#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -f "${D}/build.sh" ] &&      # is buildable
     [ -f "${D}/deploy.sh" ]        # is deployable
   then

    cd "${D}"
    echo "${D}"
    resolve refs.scss
    cd ..
    
  fi
done

