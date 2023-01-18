#!/bin/bash

# Azurra string_ops v 0.1
# Run string modification ops on all theme folders
# WARNING: use with caution!

# PROGRAM VARS
OP=''         # call appropriate string op when iterating on folders
VAL=''        # used in search, append and replace ops
NEW_VAL=''    # used in replace ops
MOD=0         # used to prompt if operation is MOD
ARGS=2        # check if required number of args is received

# HELP
ops() {
  echo "Available options:"
  echo "  -fc <VALUE>              Find <VALUE> in all '_colors.scss' files"
  echo "  -fw <VALUE>              Find <VALUE> in all 'widgets/*.scss' files"
  echo "  -fi <VALUE>              Find <VALUE> in all '_imports.scss' files"
  echo "  -fp <VALUE>              Find <VALUE> in all '_properties.scss' files"
  echo "  -rg <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all '_gtk*.scss' files"
  echo "  -rc <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all '_colors.scss' files"
  echo "  -ri <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all '_imports.scss' files"
  echo "  -rw <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all 'widgets/*.scss' files"
  echo "  -rp <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all '_properties.scss' files"
  echo "  -rt <VALUE> <NEW_VALUE>  Replace <VALUE> with <NEW_VALUE> in all 'theme.rc' files"
  echo "  -di <VALUE>              Delete lines containing <VALUE> in all '_imports.scss' files"
  echo "  -dt <VALUE>              Delete lines containing <VALUE> in all 'theme.rc' files"
  echo "  -dw <VALUE>              Delete lines containing <VALUE> in all 'widgets/*.scss' files"
  echo "  -at <VALUE>              Add <VALUE> as a new line in all 'theme.rc' files"
}

help() {
  echo "Azurra string ops v1.2"
  echo "Run string modification ops on all theme folders"
  echo ""
  
  ops
}

# UTILS
# $1: target  $2: new value  $3: filename
replace() {
  sed -i "s@$1@$2@g" "$3"
}

delete() {
  sed -i "/$1/d" "$2"
}

# $1: target  $2: filename
file_contains() {
  if grep -q "$1" "$2"; then
    return 0
  fi
  
  return 1  
}

# iterate on all theme folders
run() {
  for dir in *; do
    if [ -f "$dir/theme.rc" ]  # if has valid configuration
    then
      $OP "$dir" "$VAL" "$NEW_VAL"
    fi
  done
}

parm_count_check() {
  if [ "$#" -ne $ARGS ]; then
    echo "Invalid number of arguments."
    ops
    
    exit 2
  fi
}

# OPERATIONS
colors_contains() {
  local theme_dir="$1"
  local value="$2"
  
  if file_contains "$value" "$theme_dir/_colors.scss"; then
    echo "Match in folder $theme_dir"
  fi
}

widgets_contains() {
  local theme_dir="$1"
  local value="$2"
  local hits=0

  for FILE in "$theme_dir/widgets/"*; do
    if [ ! -f "$FILE" ]; then continue; fi
    
    if file_contains "$value" "$FILE"; then
      echo "Match in file $FILE"
      hits=$((hits+1))
    fi
  done
  
  [ $hits -le 0 ] && echo "No matches found"
}

imports_contains() {
  local theme_dir="$1"
  local value="$2"
  
  if file_contains "$value" "$theme_dir/_imports.scss"; then
    echo "Match in folder $theme_dir"
  fi
}

properties_contains() {
  local theme_dir="$1"
  local value="$2"
  
  if file_contains "$value" "$theme_dir/_properties.scss"; then
    echo "Match in folder $theme_dir"
  fi
}

gtk_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  # replace in gtk*.scss files
  [ -f "$theme_dir/gtk.scss" ] && replace "$value" "$new_value" "$theme_dir/gtk.scss"
  [ -f "$theme_dir/gtk-light.scss" ] && replace "$value" "$new_value" "$theme_dir/gtk-light.scss"
  [ -f "$theme_dir/gtk-dark.scss" ] && replace "$value" "$new_value" "$theme_dir/gtk-dark.scss"
  
  echo "Replaced value in gtk*.scss files (if found)"
}

colors_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/_colors.scss"
  
  [ -f "$theme_dir/_colors_light.scss" ] && replace "$value" "$new_value" "$theme_dir/_colors_light.scss"
  [ -f "$theme_dir/_colors_dark.scss" ] && replace "$value" "$new_value" "$theme_dir/_colors_dark.scss"
  [ -f "$theme_dir/_colors_solid.scss" ] && replace "$value" "$new_value" "$theme_dir/_colors_solid.scss"
  [ -f "$theme_dir/_colors_solid_dark.scss" ] && replace "$value" "$new_value" "$theme_dir/_colors_solid_dark.scss"
  
  echo "Replaced value in '$theme_dir/_colors*.scss' (if found)"
}

imports_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/_imports.scss"
  
  echo "Replaced value in '$theme_dir/_imports.scss' (if found)"
}

widgets_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  # replace 'value' by 'new_value'
  for FILE in "$theme_dir"/widgets/*.scss; do
    [ -f $FILE ] && replace "$value" "$new_value" $FILE && echo "Replacing value in $FILE (if found)"
  done
}

widget_delete() {
  local theme_dir="$1"
  local value="$2"
  
  # replace 'value' by 'new_value'
  for FILE in "$theme_dir"/widgets/*.scss; do
    [ -f $FILE ] && delete "$value" $FILE && echo "Replacing value in $FILE (if found)"
  done
}

properties_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/_properties.scss"
  
  echo "Replaced value in '$theme_dir/_properties.scss' (if found)"
}

config_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/theme.rc"
  
  echo "Replaced value in '$theme_dir/theme.rc' (if found)"
}

imports_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/_imports.scss"
  
  echo "Deleted value in '$theme_dir/_imports.scss' (if found)"
}

config_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/theme.rc"
  
  echo "Deleted value in '$theme_dir/_imports.scss' (if found)"
}

config_append() {
  local theme_dir="$1"
  local string="$2"
  
  echo "$string" >> "$theme_dir/theme.conf"
}

OP="$!"
VAL="$2"
NEW_VAL="$3"

case $1 in
  -fc)
    OP="colors_contains"
  ;;
  -fw)
    OP="widgets_contains"
  ;;
  -fi)
    OP="imports_contains"
  ;;
  -fp)
    OP="properties_contains"
  ;;
  -rg)
    OP="gtk_replace"
    MOD=1
    ARGS=3
  ;;
  -rc)
    OP="colors_replace"
    MOD=1
    ARGS=3
  ;;
  -ri)
    OP="imports_replace"
    MOD=1
    ARGS=3
  ;;
  -rw)
    OP="widgets_replace"
    MOD=1
    ARGS=3
  ;;
  -rp)
    OP="properties_replace"
    MOD=1
    ARGS=3
  ;;
  -rt)
    OP="config_replace"
    MOD=1
    ARGS=3
  ;;
  -di)
    OP="imports_delete"
    MOD=1
  ;;
  -di)
    OP="config_delete"
    MOD=1
  ;;
  -dw)
    OP="widget_delete"
    MOD=1
  ;;
  -at)
    OP="config_append"
    MOD=1
  ;;
  *)
    echo -n "Invalid operation. "
    ops
    exit 1
  ;;
esac

parm_count_check $@

# warn user of potential catastrophic consequences
if [ $MOD -eq 1 ]
then

  read -p "Files will be altered. Continue? (y/n): " -n 1 -r
  echo ""	# new line

  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "Operation aborted."
    exit 1
  fi
fi

run
