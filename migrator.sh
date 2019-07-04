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

replace_in_imports() {
  sed -i 's/iOS_12/iOS/g' $1/_imports.scss
}

replace_in_base_files() {
  [ -f $1/gtk.scss ] && sed -i 's/palette/variant/g' $1/gtk.scss
  [ -f $1/gtk-light.scss ] && sed -i 's/palette/variant/g' $1/gtk-light.scss
  [ -f $1/gtk-dark.scss ] && sed -i 's/palette/variant/g' $1/gtk-dark.scss
}

invoke() {
  replace_in_base_files $@
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
