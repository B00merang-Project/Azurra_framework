#!/bin/bash

migrate() {
  theme_dir="$1"
  
  # batch apply REGEX on all widget files
  for F in "$theme_dir"/widgets/*.scss; do
    [ -f $F ] && sed -i 's/theme_//g' $F
  done
  
  unset theme_dir
}

for dir in *; do
  if [ -f "$dir"/theme.conf ]; then     # if has valid configuration
    echo -ne "[    ] Migrating $dir"\\r
    migrate "$dir"
    echo "[ OK ]"
  elif [ -f "$dir"/bundle.conf ]; then  # if is a bundle directory
    for bundle_dir in "$dir"/*; do
      if [ -f "$bundle_dir"/theme.conf ]; then
        echo -ne "[    ] Migrating $bundle_dir"\\r
        migrate "$bundle_dir"
        echo "[ OK ]"
      fi    
    done
  fi
done
