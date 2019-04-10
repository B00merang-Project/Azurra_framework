#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ] &&               # theme exists
     [ -d "${D}/widgets" ]; then    # if is loopable

    cd "${D}/widgets"

    for F in *.scss; do
      if [ ! -L "${F}" ]; then
	      echo "${D}/widgets/${F}"
      fi
    done

    cd ../..

  elif [ -d "${D}" ]
  then

    cd "${D}"

    for SD in *; do
      if [ -d "${SD}/widgets" ]; then
    
        cd "${SD}/widgets"
        
        for F in *.scss; do
          if [ ! -L "${F}" ]; then
            echo "${D}/${SD}/widgets/${F}"
          fi
        done

        cd ../..
      fi
    done

    cd ..

  fi
done
