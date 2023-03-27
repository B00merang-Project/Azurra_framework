#!/bin/bash

# Azurra string_ops v 0.5
# Run string modification ops on all theme folders
# WARNING: use with caution!

# PROGRAM VARS
OP=''         # call appropriate string op when iterating on folders
MOD=0         # used to prompt if operation is MOD (modifies files)
ARGS=2        # check if required number of args is received

# HELP
show_ops() {
  echo "Available options:"
  echo
  echo "For '_colors.scss'"
  echo "  -fc  <VALUE>                 Find <VALUE>"
  echo "  -rc  <VALUE> <NEW_VALUE>     Replace <VALUE> with <NEW_VALUE>"
  echo "  -dc  <VALUE>                 Delete lines containing <VALUE>"
  echo "  -acf <NAME>  <VALUE> <FIND>  Add SCSS snippet '$<NAME> : <VALUE>;' after line <FIND>"

  echo
  echo "For 'widgets/*.scss'"
  echo "  -fw  <VALUE>                 Find <VALUE>"
  echo "  -rw  <VALUE> <NEW_VALUE>     Replace <VALUE> with <NEW_VALUE>"
  echo "  -dw  <VALUE>                 Delete lines containing <VALUE>"
  
  echo
  echo "For '_imports.scss'"
  echo "  -fi  <VALUE>                 Find <VALUE>"
  echo "  -ri  <VALUE> <NEW_VALUE>     Replace <VALUE> with <NEW_VALUE>"
  echo "  -di  <VALUE>                 Delete lines containing <VALUE>"
  echo "  -at  <VALUE>                 Add \"@include '<VALUE>';\" as a new line"

  echo
  echo "For 'theme.rc'"
  echo "  -rt  <VALUE> <NEW_VALUE>     Replace <VALUE> with <NEW_VALUE>"
  echo "  -dt  <VALUE>                 Delete lines containing <VALUE>"
  echo "  -at  <VALUE>                 Add <VALUE> as a new line"

  echo
  echo "For '_properties.scss'"
  echo "  -fp  <VALUE>                 Find <VALUE>"
  echo "  -rp  <VALUE> <NEW_VALUE>     Replace <VALUE> with <NEW_VALUE>"
  echo "  -dp  <VALUE>                 Delete lines containing <VALUE>"
  echo "  -ap  <NAME>  <VALUE>         Add SCSS snippet '$<NAME> : <VALUE>;'"
  echo "  -apf <NAME>  <VALUE> <FIND>  Add SCSS snippet '$<NAME> : <VALUE>;' after line <FIND>"
}

help() {
  echo "Azurra string ops v1.2"
  echo "Run string modification ops on all theme folders"
  echo ""
  
  show_ops
}

# UTILS
# $1: value to replace    $2: new value   $3: filename
replace() {
  # warn if file contains
  file_contains "$1" "$3" && echo "Replacing value in $3"

  sed -i "s@$1@$2@g" "$3"
}

# $1: value to delete   $2: filename
delete() {
  file_contains "$1" "$2" && echo "Deleting value in $2"

  sed -i "/$1/d" "$2"
}

# $1: value to find   $2: filename
file_contains() {
  grep -q "$1" "$2" && return 0 || return 1
}

# $1: value to add    $2: value to find   $3: filename
insert_after() {
  sed -i "/$1/a $2" "$3"
}

# OPERATIONS
### Contains
colors_contains() {
  local theme_dir="$1"
  local value="$2"
  
  for FILE in "$theme_dir/_colors"*.scss; do
    file_contains "$value" "$FILE" && echo "Match in $FILE"
  done
}

widgets_contains() {
  local theme_dir="$1"
  local value="$2"

  for FILE in "$theme_dir/widgets/"*; do
    [ -f "$FILE" ] && file_contains "$value" "$FILE" && echo "Match in $FILE"
  done
}

imports_contains() {
  local theme_dir="$1"
  local value="$2"
  
  file_contains "$value" "$theme_dir/_imports.scss" && echo "Match in $theme_dir"
}

properties_contains() {
  local theme_dir="$1"
  local value="$2"
  
  file_contains "$value" "$theme_dir/_properties.scss" && echo "Match in $theme_dir"
}

### Replace
colors_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  for FILE in "$theme_dir/_colors"*.scss; do
    replace "$value" "$new_value" "$FILE"
  done
}

imports_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/_imports.scss"
}

widgets_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  for FILE in "$theme_dir"/widgets/*.scss; do
    [ -f $FILE ] && replace "$value" "$new_value" $FILE
  done
}

properties_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/_properties.scss"
}

config_replace() {
  local theme_dir="$1"
  local value="$2"
  local new_value="$3"
  
  replace "$value" "$new_value" "$theme_dir/theme.rc"
}

### Delete
imports_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/_imports.scss"
}

widget_delete() {
  local theme_dir="$1"
  local value="$2"
  
  # replace 'value' by 'new_value'
  for FILE in "$theme_dir"/widgets/*.scss; do
    [ -f $FILE ] && delete "$value" $FILE
  done
}

colors_delete() {
  local theme_dir="$1"
  local value="$2"
  
  for FILE in "$theme_dir/_colors"*.scss; do
    delete "$value" "$FILE"
  done
}

config_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/theme.rc"
}

props_delete() {
  local theme_dir="$1"
  local value="$2"
  
  delete "$value" "$theme_dir/_properties.scss"
}

### Insert/append/add
config_append() {
  local theme_dir="$1"
  local string="$2"
  
  echo "$string" >> "$theme_dir/theme.rc"
}

imports_append() {
  local theme_dir="$1"
  local string="$2"
  
  echo "@import '$string';" >> "$theme_dir/_imports.scss" 
}

props_insert() {
  local theme_dir="$1"
  local var_name="$2"
  local var_value="$3"
  
  echo "\$$var_name : $var_value;" >> "$theme_dir/_my_properties.scss"
}

props_insert_after() {
  local theme_dir="$1"
  local var_name="$2"
  local var_value="$3"
  local insert_after="$4"
  
  insert_after "$insert_after" "\$$var_name : $var_value\;" "$theme_dir/_properties.scss" 
}

colors_insert_after() {
  local theme_dir="$1"
  local var_name="$2"
  local var_value="$3"
  local insert_after="$4"
  
  for FILE in "$theme_dir/_colors"*.scss; do
    insert_after "$insert_after" "\$$var_name : $var_value\;" "$FILE"
  done
}

# PROGRAM
case $1 in
  -fc)  OP="colors_contains"     ;;
  -fw)  OP="widgets_contains"    ;;
  -fi)  OP="imports_contains"    ;;
  -fp)  OP="properties_contains" ;;
  -rc)  OP="colors_replace"      ;  MOD=1;  ARGS=3 ;;
  -ri)  OP="imports_replace"     ;  MOD=1;  ARGS=3 ;;
  -rw)  OP="widgets_replace"     ;  MOD=1;  ARGS=3 ;;
  -rp)  OP="properties_replace"  ;  MOD=1;  ARGS=3 ;;
  -rt)  OP="config_replace"      ;  MOD=1;  ARGS=3 ;;
  -di)  OP="imports_delete"      ;  MOD=1;;
  -dc)  OP="colors_delete"       ;  MOD=1;;
  -dt)  OP="config_delete"       ;  MOD=1;;
  -dw)  OP="widget_delete"       ;  MOD=1;;
  -dp)  OP="props_delete"        ;  MOD=1;;
  -at)  OP="config_append"       ;  MOD=1;;
  -ai)  OP="imports_append"      ;  MOD=1;;
  -ap)  OP="props_insert"        ;  MOD=1;  ARGS=3 ;;
  -apf) OP="props_insert_after"  ;  MOD=1;  ARGS=4 ;;
  -acf) OP="colors_insert_after" ;  MOD=1;  ARGS=4 ;;
  -h)   show_ops; exit;          ;;

  *)    echo -n "Invalid operation. "
        show_ops
        exit 1;;
esac

# see if correct number of arguments received
if [ "$#" -ne $ARGS ]; then
  echo "Command requires $(($ARGS - 1)) argument(s)"
  
  exit 2
fi

# warn user of potential catastrophic consequences
if [ $MOD -eq 1 ]
then

  read -p "Files will be altered. Continue? [y/N]: " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "Canceled"
    exit 1
  fi
fi

# run op on all theme folders and pass all arguments, except the first 2: script (0) name and flag (1)
for dir in *; do
  # [ -d "$dir" ] && $OP "$dir" "${@:2}"
  [ -f "$dir/theme.rc" ] && $OP "$dir" "${@:2}"
done
