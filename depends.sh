#!/bin/bash

BASE='Azurra'

dependor() {
  imports=0
  dependencies=0
  
  while IFS= read -r import || [ -n "$import" ]; do
    
    if [[ "$import" != *$BASE* ]] && [[ "$import" != "@import 'widgets/"* ]]
    then
      display="${import//"'"/''}"
      display="${display//";"/''}"
      display="${display//'../'/''}"
      display="${display//'@import '/''}"
      
      theme="${display%%'/widgets/'*}"
      widget="${display#*'/widgets/'}"
      
      printf "%-20s %-5s %-0s" "  $widget" "->" "$theme"
      printf "\n"
      
      dependencies=$(($dependencies + 1 ))
    fi
    
    imports=$(($imports + 1))
    
  done < refs.scss
  
  echo ""
  echo "$dependencies cross-dependencies found over $imports imports."
}

if [ -f "$1/refs.scss" ]
then 
  echo "Cross-dependencies for $1"
  cd "$1"

  dependor

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
            echo "Cross-dependencies for $SD"
          
            dependor
            
            echo ""
          fi
          
          cd ..
        fi
      done

      if [ -f "refs.scss" ]
      then
        echo "Cross-dependencies for $D"
      
        dependor
        
        echo ""
      fi
      
      cd ..
    fi
  done
else
  echo "Invalid."
fi
