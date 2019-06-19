#!/bin/bash

# Azurra Utils, a script to manage and generate themes with the Azurra Framework
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=0.2
description="Azurra Utils, version $version"

BASE_THEME='Azurra'
IGNORE_BASE_THEME=true
WIKI=http://github.com/Elbullazul/Azurra_framework/wiki

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
  echo "  -p   --parents      " "List of widgets inherited from other themes Requires <TARGET>"
  echo "  -c   --children     " "List of themes using resources from a theme. Requires <TARGET>"
  echo "  -w   --widget       " "Use with -p or -c, restricts search to <WIDGET>"
  echo "  -n   --new          " "Initialise a new theme directory. Requires <NAME> and -b <PARENT>"
  echo "  -i   --ignore-base  " "Ignore entries for $BASE_THEME"
  echo "  -b   --base         " "Specify new theme's parent (Azurra by default)"

  echo
  echo "More information: <$WIKI>"
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

# 0=true, 1=false
ignore_base_theme() {
  [[ $IGNORE_BASE_THEME == true ]] && return 1 || return 0
}

has_refs() {
  [ -f "$1/_imports.scss" ] && return 0 || return 1
}

can_build() {
  [ -f "$1/theme.conf" ] && return 0 || return 1
}

is_theme_dir() {
  can_build $1 && has_refs $1 && return 0 || return 1
}

is_bundle_dir() {
  [ -f "$1/bundle.conf" ] && return 0 || return 1
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
  
  read_parents_from_file $theme_dir/_imports.scss $searched_widget
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

altfound() {
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
      
      if altfound $clean_line $searched_theme_name && altfound $clean_line $searched_widget; then
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
  
  [[ ${theme_dir%/} != ${searched_theme%/} ]] && read_children_from_file $theme_dir/_imports.scss $theme_dir $searched_theme $searched_widget
}

#############################################
# MAIN
#############################################
get_arguments $@

if [ ! -z $name ]; then
  cp -a Azurra $name
  echo "$name theme created. You now have to configure it in theme.conf"
  
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
