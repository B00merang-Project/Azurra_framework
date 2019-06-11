#!/bin/bash

BASE='Azurra'

dependor() {
  imports=0
  inheritances=0
  
  while IFS= read -r import || [ -n "$import" ]; do
    if [[ "$import" == *$BASE* ]]
    then
      display="${import//"'"/''}"
      display="${display//";"/''}"
      display="${display//'../'/''}"
      display="${display//'@import '/''}"
      
      theme="${display%%'/widgets/'*}"
      widget="${display#*'/widgets/'}"
      
      if [[ -z $1 ]]
      then
        printf "%-20s %-5s %-0s" "  $theme" "->" "$widget"
        printf "\n"
      elif [[ ! -z $1 ]] && [[ "$widget" == "$1" ]]
      then
        echo $2
      fi
      
      inheritances=$(($inheritances + 1 ))
    fi
    
    imports=$(($imports + 1))
    
  done < refs.scss
  
  if [[ -z $1 ]]
  then
    echo ""
    echo "$inheritances inheritances found over $imports imports."
  fi
}

if [ -f "$1/refs.scss" ]
then 
  echo "inheritances for $1"
  cd "$1"

  dependor $2

elif [ "$1" == "all" ]
then
  for D in *; do
    if [ -d "${D}" ] &&               # it's a directory
       [ "${D}" != "$BASE" ] &&	      # not the base theme
       [ -f "${D}/build.sh" ] &&      # is buildable
       [ -f "${D}/deploy.sh" ]        # is deployable
     then  

      cd ${D}

      for SD in *; do
        if [ -d "${SD}" ] &&               # it's a directory
           [ "${SD}" != "$BASE" ] &&	     # not the base theme
           [ -f "${SD}/build.sh" ] &&      # is buildable
           [ -f "${SD}/deploy.sh" ]        # is deployable
         then  

          cd ${SD}

          if [ -f "refs.scss" ]
          then
            if [[ -z $2 ]]
            then
              echo "inheritances for ${SD}"
              dependor
              echo ""
            else
              dependor $2 ${SD}
            fi
          fi
          
          cd ..
        fi
      done

      if [ -f "refs.scss" ]
      then
        if [[ -z $2 ]]
        then
          echo "inheritances for ${D}"
          dependor
          echo ""
        else
          dependor $2 ${D}
        fi
      fi
      
      cd ..
    fi
  done
else
  echo "Invalid."
fi
