#!/bin/bash

str_replace_in() {
  sed -i "s@$1@$2@g" "$3"
}

replace_in_widgets() {
  local theme_dir="$1"
  
  # replace 'theme_' by ''
  for F in "$theme_dir"/widgets/*.scss; do
    [ -f $F ] && str_replace_in 'theme_' '' $F
  done
}

find_in_colors() {
  res=$(grep '#FF000;' "$1/_colors.scss")
  
  # find '#FF000' in all _colors files
  [[ ! -z $res ]] && echo "$1 contains string"
}

find_in_widgets() {
  local theme_dir="$1"

  for F in "$theme_dir"/widgets/*; do
    res=$(grep '& {' "$F")
  
    # find '& {' widget files
    [[ ! -z $res ]] && echo "$F contains string"
  done
}

replace_in_imports() {
  # replace 'arg 1' by 'arg 2' in all _imports files
  str_replace_in 'Solaris_10_CDE' 'Solaris_9' $1/_imports.scss
}

replace_in_base_files() {
  # replace 
  [ -f $1/gtk.scss ] && str_replace_in 'palette' 'variant' $1/gtk.scss
  [ -f $1/gtk-light.scss ] && str_replace_in 'palette' 'variant' $1/gtk-light.scss
  [ -f $1/gtk-dark.scss ] && str_replace_in 'palette' 'variant' $1/gtk-dark.scss
}

add_config() {
  echo 'can_render=false' >>$1/theme.conf
}

invoke() {
  find_in_widgets $@
}

for dir in *; do
  if [ -f "$dir"/theme.conf ]; then     # if has valid configuration
    invoke "$dir"
  elif [ -f "$dir"/bundle.conf ]; then  # if is a bundle directory
    for bundle_dir in "$dir"/*; do
      if [ -f "$bundle_dir"/theme.conf ]; then  # process bundled themes
        invoke "$bundle_dir"
      fi    
    done
  fi
done
