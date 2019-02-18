#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -f "${D}/build.sh" ] &&      # is buildable
     [ -f "${D}/deploy.sh" ] &&     # is deployable
     [ "${D}" = "WinXP_"* ]; then

    cd "${D}/widgets"
    
    cp -R ../../iOS_12/widgets/_treeview.scss .
    
    cd ../..
    
  fi
done

