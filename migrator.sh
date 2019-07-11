#!/bin/bash

str_replace_in() {
  sed -i "s@$1@$2@g" "$3"
}

replace_in_widgets() {
  theme_dir="$1"
  
  # replace 'theme_' by ''
  for F in "$theme_dir"/widgets/*.scss; do
    [ -f $F ] && str_replace_in 'theme_' '' $F
  done
  
  unset theme_dir
}

find_in_colors() {
  res=$(grep '#FF000;' "$1/_colors.scss")
  
  # find '#FF000' in all _colors files
  [[ ! -z $res ]] && echo "$1 contains string"
}

replace_in_imports() {
  # replace 'iOS_12' by 'iOS' in all _imports files
  str_replace_in 'Android_4.4/widgets/treeview' 'Android/widgets/treeview' $1/_imports.scss
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
  replace_in_imports $@
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
