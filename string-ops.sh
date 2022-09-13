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
  echo "  -fc    --find-in-colors       <VALUE>"
  echo "  -fw    --find-in-widgets      <VALUE>"
  echo "  -fi    --find-in-imports      <VALUE>"
  echo "  -rg    --replace-in-gtk-files <VALUE> <NEW_VALUE>"
  echo "  -ri    --replace-in-imports   <VALUE> <NEW_VALUE>"
  echo "  -rw    --replace-in-widgets   <VALUE> <NEW_VALUE>"
  echo "  -di    --delete-in-imports    <VALUE>"
  echo "  -ac    --append-to-conf-file  <VALUE>"
}

help() {
  echo "Azurra string ops v0.1"
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
    if [ -f "$dir/theme.conf" ]  # if has valid configuration
    then
      $OP "$dir" "$VAL" "$NEW_VAL"
    elif [ -f "$dir/bundle.conf" ]  # if is a bundle directory
    then
      for bundle_dir in "$dir"/*
      do
        if [ -f "$bundle_dir/theme.conf" ]  # process bundled themes
        then
          $OP "$bundle_dir" "$VAL" "$NEW_VAL"
        fi    
      done
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

imports_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/_imports.scss"
  
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
  -fc|--find-in-colors)
    OP="colors_contains"
  ;;
  -fw|--find-in-widgets)
    OP="widgets_contains"
  ;;
  -fi|--find-in-imports)
    OP="imports_contains"
  ;;
  -rg|--replace-in-gtk-files)
    OP="gtk_replace"
    MOD=1
    ARGS=3
  ;;
  -ri|--replace-in-imports)
    OP="imports_replace"
    MOD=1
    ARGS=3
  ;;
  -rw|--replace-in-widgets)
    OP="widgets_replace"
    MOD=1
    ARGS=3
  ;;
  -di|--delete-in-imports)
    OP="imports_delete"
    MOD=1
  ;;
  -ac|--append-to-conf-file)
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
