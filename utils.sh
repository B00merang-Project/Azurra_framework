#!/bin/bash

# Azurra Utils, a script to manage and generate themes with the Azurra Framework
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=0.1
description="Azurra Utils, version $version"

BASE_THEME='Azurra'
IGNORE_BASE_THEME=true

# Exit codes
OK=0
ERROR=1
INVALID_ARG=2

# Return buffer for functions
RETURNED_VALUE[0]=''
STATIC[0]=0
STATIC[1]=0

#############################################
# FUNCTIONS
#############################################
ignore_base_theme() {
  if [[ $IGNORE_BASE_THEME == true ]]; then
    return 1    # bash false
  fi
  return 0      # bash true
}

clean_string() {
  string="$1"
  
  string="${string//"'"/''}"
  string="${string//";"/''}"
  string="${string//'../'/''}"
  string="${string//'@import '/''}"

  RETURNED_VALUE[0]="$string"
}

show_help() {
  echo $description
  echo

  echo "  -h   --help         " "Shows help"
  echo "  -v   --version      " "Script version"
  echo "  -p   --parents      " "List of widgets inherited from other themes Requires <target>"
  echo "  -c   --children     " "List of themes using resources from a theme. Requires <target>"
  echo "  -w   --widget       " "Use with -p or -c, restricts search to <widget>"
  echo "  -n   --new          " "Initialise a new theme directory. Requires <name> and -b <parent>"
  echo "  -i   --ignore-base  " "Ignore entries for $BASE_THEME"
  echo "  -b   --base         " "Specify new theme's parent (Azurra by default)"

  echo
  echo "More information: <http://github.com/Azurra_Utils/wiki>"
}

show_version() {
  echo $description
  echo "Copyright (c) 2019 The B00merang Group"
  echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
}

invalid_argument() {
  echo "Invalid argument '$1'"
}

get_arguments() {
  while [ "$1" != "" ]; do
    case $1 in
      -p | --parents )        shift
                              parent=$1
                              ;;
      -c | --children )       shift
                              child=$1
                              ;;
      -w | --widget )         shift
                              widget=$1
                              ;;
      -n | --new )            shift
                              name=$1
                              ;;
      -h | --help )           show_help
                              exit $OK
                              ;;
      -v | --version )        show_version
                              exit $OK
                              ;;
      -s | --show-base)       IGNORE_BASE_THEME=false
                              ;;
      -* )                    invalid_argument $1
                              exit $INVALID_ARG
    esac
    shift
  done
}

can_build() {
  if [ -f "$1/build.sh" ]; then
    return 1
  else
    return 0
  fi
}

has_refs() {
  if [ -f "$1/refs.scss" ]; then
    return 1
  else
    return 0
  fi
}

# 0=true, 1=false
has_refs() {
  if [ -f "$1/refs.scss" ]; then
     return 0
  fi
  return 1
}

can_build() {
  if [ -f "$1/build.sh" ]; then
    return 0
  fi
  return 1
}

is_theme_dir() {
  if can_build $1 && has_refs $1; then
    return 0
  fi
  return 1
}

is_bundle_dir() {
  if can_build $1; then
    for d in $1/*; do
      if is_theme_dir $d; then
        return 0
      fi
    done
  fi
  return 1
}

get_parents() {
  theme_dir=$1
  searched_widget=$2
  
  display_headers=0
  
  if [ ! -z $searched_widget ]; then
    display_headers=1
  fi
  
  if [ $display_headers ]; then
    ignore_base_theme && echo -n "All "
    echo "Parents for $theme_dir"
  fi
  
  read_parents_from_file $theme_dir/refs.scss $searched_widget
  dependency_count=${RETURNED_VALUE[0]}
  import_count=${RETURNED_VALUE[1]}
  unset RETURNED_VALUE
  
  if [ $display_headers ]; then
    echo ""
    echo "$dependency_count dependencies found over $import_count imports"
    echo "------"
  fi
}

pretty_print() {
  theme_name=$1
  widget_name=$2

  printf "%-30s %-5s %-0s" "  $widget_name" "->" "$theme_name"
  printf "\n"
}

newfound() {
  output_string=$1
  find_string=$2
  
  if [ ! -z $find_string ]; then
    if [[ $output_string == *"$BASE_THEME" ]]; then
      ignore_base_theme && return 1   # don't show if won't show
    fi
    
    [[ $output_string != *$find_string* ]] && return 1  # don't show if not present
  fi
  return 0
}

is_found() {
  output_string=$1
  find_string=$2
  
  if [[ "$output_string" != *"$BASE_THEME"* ]]; then
    # if we search something and don't find it, return false
    [ ! -z $find_string ] && [[ "$output_string" != *"$find_string"* ]] && return 1
    return 0
  elif [[ "$output_string" == *$BASE_THEME* ]] && ignore_base_theme && [ -z "$find_string" ]; then
    return 0
  fi
  return 1
}

read_parents_from_file() {
  file=$1
  searched_widget_name=$2
  
  # counters
  imports=0
  dependencies=0
  
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" != "@import 'widgets/"* ]]; then    # ignore theme overrides
      clean_string "$line"
      
      clean_line=${RETURNED_VALUE[0]}
      unset RETURNED_VALUE
      
      theme_name="${clean_line%%'/widgets/'*}"
      widget_name="${clean_line#*'/widgets/'}"

      if is_found $clean_line $searched_widget_name; then
        pretty_print $theme_name $widget_name
        dependencies=$(($dependencies + 1))
      fi
    fi
    
    imports=$(($imports + 1))
  done < $file
  
  RETURNED_VALUE[0]=$dependencies
  RETURNED_VALUE[1]=$imports
}

read_children_from_file() {
  file=$1
  current_theme_name=$2
  searched_theme_name=$3
  searched_widget=$4
  
  childs=${STATIC[0]}
  total=${STATIC[1]}
  local_child_widgets=0
  
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" != "@import 'widgets/"* ]]; then    # ignore theme overrides
      clean_string "$line"
      
      clean_line=${RETURNED_VALUE[0]}
      unset RETURNED_VALUE
      
      theme_name="${clean_line%%'/widgets/'*}"
      widget_name="${clean_line#*'/widgets/'}"
      
      if newfound $clean_line $searched_theme_name && newfound $clean_line $searched_widget; then
        pretty_print $widget_name $current_theme_name
        childs=$(($childs + 1))
        local_child_widgets=$(($childs + 1))
      fi
    fi
  done < $file
  
  [ $local_child_widgets -gt 0 ] && total=$(($total + 1))
  
  STATIC[0]=$childs
  STATIC[1]=$total
}

get_children() {
  theme_dir=$1
  searched_theme=$2
  searched_widget=$3
  
  # counters
  imports=0
  dependencies=0
  
  [[ ${theme_dir%/} != ${searched_theme%/} ]] && read_children_from_file $theme_dir/refs.scss $theme_dir $searched_theme $searched_widget
}

#############################################
# MAIN
#############################################
get_arguments $@

if [ ! -z $name ]; then
  cp -a Azurra $name
  echo "$name theme created. You'll have to manually edit build and deploy scripts"
  
  exit $OK
fi

if [ ! -z $parent ]; then
  OP=get_parents
  ARGS=($widget)
  if [[ $parent == 'all' ]]; then
    QUEUE=*
  elif [[ $parent == $BASE_THEME ]]; then
    IGNORE_BASE_THEME=false
  else
    QUEUE=$parent
  fi
elif [ ! -z $child ]; then
  OP=get_children
  ARGS=($child $widget)
  QUEUE=*
  
  if [[ $child == 'all' ]]; then
    echo "Invalid argument 'all'. Try again with a valid theme name"
    exit $INVALID_ARG
  elif [[ $child == $BASE_THEME ]]; then
    IGNORE_BASE_THEME=false
  fi
  
  echo "Children of $child"
fi

for dir in $QUEUE; do
  if is_theme_dir $dir; then
    $OP $dir ${ARGS[@]}
  elif is_bundle_dir $dir; then
    for sub_dir in $dir/*; do
      is_theme_dir $sub_dir && $OP $sub_dir ${ARGS[@]}
    done
  fi
done

[[ $OP == get_children ]] && echo "${STATIC[0]} exports over ${STATIC[1]} themes"
unset STATIC
unset RETURN_VALUE
