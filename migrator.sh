#!/bin/bash

widget_replace() {
  theme_dir="$1"
  
  echo -ne "[    ] Migrating $dir"\\r
  
  # batch apply REGEX on all widget files
  for F in "$theme_dir"/widgets/*.scss; do
    [ -f $F ] && sed -i 's/theme_//g' $F
  done
  
  echo "[ OK ]"
  
  unset theme_dir
}

find_in_file() {
  res=$(grep '#FF000;' "$1/_colors.scss")
  
  [[ ! -z $res ]] && echo "$1 contains string"
}

invoke() {
  find_in_file $@
}

for dir in *; do
  if [ -f "$dir"/theme.conf ]; then     # if has valid configuration
    invoke "$dir"
  elif [ -f "$dir"/bundle.conf ]; then  # if is a bundle directory
    for bundle_dir in "$dir"/*; do
      if [ -f "$bundle_dir"/theme.conf ]; then
        invoke "$bundle_dir"
      fi    
    done
  fi
done
