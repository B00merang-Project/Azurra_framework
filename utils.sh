#!/bin/bash

# Azurra Utils, a script to manage and generate themes with the Azurra Framework
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=0.3
description="Azurra Utils, version $version"

ROOT_DIR="$PWD"
BASE_THEME='Azurra'
WIKI=http://github.com/Elbullazul/Azurra_framework/wiki

IGNORE_BASE=0

# Imports from .lib (hidden folder)
#source '.lib/debug.sh'  # FOR DEBUG
source '.lib/colors.sh'
source '.lib/ui.sh'
source '.lib/files.sh'
source '.lib/system.sh'

# conditional functions
is_external() {
  [[ "$1" != "widgets/"* ]] && return 0 || return 1
}

hide_if_ignore_base() {
  [[ "$1" == "$BASE_THEME"/* ]] && [ $IGNORE_BASE -eq 0 ] && return 0 || return 1
}

# string operations
get_imports() {
  get_imports__target="$1"
  
  while IFS= read -r line || [ -n "$line" ]; do
    echo $(clean_line "$line")
  done < "$get_imports__target"/_imports.scss  
  
  unset line
}

sanitize() {
  sanitize__string="$1" && echo ${sanitize__string%/} | tr -s /
}

clean_line() {
  clean_line__string="$1"
  
  clean_line__string="${clean_line__string//"'"/''}"
  clean_line__string="${clean_line__string//";"/''}"
  clean_line__string="${clean_line__string//'../'/''}"
  clean_line__string="${clean_line__string//'@import '/''}"
  
  echo "$clean_line__string"
}

get_widget() {
  get_widget__line="$1" && echo "${get_widget__line#*'/widgets/'}"
}

get_theme() {
  get_theme__line="$1" && echo "${get_theme__line%%'/widgets/'*}"
}

# filter functions
is_found() {
  is_found__line="$1"
  shift
  
  search_filters=$@
  for search_filter in ${search_filters[@]}; do
    [[ "$is_found__line" == *"$search_filter"* ]] && return 1
  done
  
  return 0
}

filter_from_imports() {
  filter_from_imports__target="$1"
  shift
  
  filters=$@
  for import_to_filter in $(get_imports "$filter_from_imports__target"); do
    if [ -z $filters ]; then
      echo "$import_to_filter" && continue
    else
      ! is_found "$import_to_filter" $filters && echo "$import_to_filter"
    fi
  done
}

# display functions
show_help() {
  echo $description
  echo
  
  format=("%-4s" "%-12s" "%-0s")
  content=('-h' '--help'      'Shows help') && table $format $content
  content=('-v' '--version'   'Script version') && table $format $content
  content=('-d' '--depends'   'List of widgets inherited from other themes') && table $format $content
  content=('-c' '--children'  'List of themes using resources from theme <THEME>') && table $format $content
  content=('-n' '--widget'    'Restricts operation to <WIDGET>. Use with [-p -c -i]') && table $format $content
  content=('-w' '--new'       "Initialise a new theme <NAME> based on <SOURCE> ($BASE_THEME by default)") && table $format $content
  content=('-t' '--tree'      'Shows upstream themes inheritance tree') && table $format $content
  content=('-b' '--bundle'    'Creates bundle <BUNDLE>') && table $format $content
  content=('-i' '--implement' 'Implements <WIDGET> in <THEME> from <SOURCE>') && table $format $content
  
  echo
  echo "More information: <$WIKI>"
  
  exit
}

show_version() {
  echo $description
  echo "Copyright (c) 2019 The B00merang Group"
  echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
  
  exit
}

show_tree() {
  cat .lib/resources/azurra_theme_tree
  exit
}

# work functions
get_parents() {
  get_parents__target=$(sanitize "$1")
  get_parents__search_args="$2"
  
  ! is_theme "$get_parents__target" && fail "Directory '$get_parents__target' is not a theme"
  display "Dependencies for $get_parents__target"
  
  # counters
  zero=0  # for some reason the first variable that gets assigned 0 is considered empty
  get_parents__match_count=0
  get_parents__imports_total=0
  
  for import in $(filter_from_imports "$get_parents__target" "$get_parents__search_args"); do
    if is_external "$import"; then
      ! hide_if_ignore_base $import && echo $import &&
      get_parents__match_count=$(($get_parents__match_count + 1))
    fi
    get_parents__imports_total=$(($get_parents__imports_total + 1))
  done
  
  display "Found $get_parents__match_count external imports over $get_parents__imports_total imports"
  
  unset import get_parents__match_count get_parents__imports_total
}

get_related_dependencies() {
  get_related_dependencies__target=$(sanitize "$1")
  get_related_dependencies__search_args="$2"
  
  # counters
  zero=0  # for some reason the first variable that gets assigned 0 is considered empty
  get_related_dependencies__match_count=0
  get_related_dependencies__imports_total=0
  
  get_related_dependencies__imports=$(filter_from_imports "$get_related_dependencies__target" "$get_related_dependencies__search_args")
  
  [ ! -z "$get_related_dependencies__imports" ] && display "For theme $get_related_dependencies__target"
  
  for import in $get_related_dependencies__imports; do
    if is_external "$import"; then
      ! hide_if_ignore_base $import && echo " -$(get_widget "$import")" &&
      get_related_dependencies__match_count=$(($get_related_dependencies__match_count + 1))
    fi
    get_related_dependencies__imports_total=$(($get_related_dependencies__imports_total + 1))
  done
  
  # return child count
  return $get_related_dependencies__match_count
}

get_children() {
  get_children__target=$(sanitize "$1")
  
  ! is_theme "$get_children__target" && fail "Directory '$get_children__target' is not a theme"
  display "Children themes for $get_children__target"
  
  # counters
  zero=0  # for some reason the first variable that gets assigned 0 is considered empty
  get_children__match_count=0
  
  for DIR in */; do
    [[ "$DIR" == "$get_children__target" ]] && continue
  
    if is_theme "$DIR"; then
      get_related_dependencies "$DIR" "$get_children__target"
      get_children__match_count=$(($get_children__match_count + $?))
      
    elif is_bundle "$DIR"; then  # if is a bundle directory
      for BUNDLE_DIR in "$DIR"/*; do
        if is_theme "$BUNDLE_DIR"; then
          get_related_dependencies "$BUNDLE_DIR" "$get_children__target"
          get_children__match_count=$(($get_children__match_count + $?))
        fi
      done
    fi
  done
  
  display "$get_children__match_count children found"
}

string_replace() {
  string_replace__string="$1"
  string_replace__string_to_remove="$2"
  string_replace__string_to_insert="$3"
  
  echo "${string_replace__string/$string_replace__string_to_remove/$string_replace__string_to_insert}" 
}

make_new() {
  make_new__theme_name="$1"
  make_new__theme_dir="$ROOT_DIR/$1"
  
  [ ! -z "$2" ] && make_new__source_dir="$2" || make_new__source_dir=$BASE_THEME && BASE=$BASE_THEME
  make_new__source_dir="$ROOT_DIR"/"$make_new__source_dir"

  [ ! -d "$make_new__source_dir" ] && fail "Directory '$make_new__source_dir' does not exist"
  [ -d "$make_new__theme_dir" ] && fail "Theme already exists"
  
  display "Creating theme $make_new__theme_name"
  
  # at root
  mkdir -p "$make_new__theme_dir/widgets"
  cp -r "$make_new__source_dir/assets" "$make_new__theme_dir"
  cp "$make_new__source_dir/_vars.scss" "$make_new__theme_dir"
  
  # Adjust depth for parent in case of bundle
  PREFIX='..'
  make_new__eval_source_dir=$(dirname $make_new__theme_dir)
  is_bundle "$make_new__eval_source_dir" && PREFIX='../..'
  
  make_new__parent_imports=$(get_imports "$make_new__source_dir")
  
  for parent_import in $make_new__parent_imports; do
    [[ "$parent_import" == "widgets/"* ]] && parent_import="$(string_replace $parent_import widgets $(basename $make_new__source_dir)/widgets)"
    echo "@import '$PREFIX/$parent_import';">>"$make_new__theme_dir"/_imports.scss
  done
  
  cp "$make_new__source_dir/_colors.scss" "$make_new__theme_dir"
  has_dark "$make_new__source_dir" && cp "$make_new__source_dir/_colors_dark.scss" "$make_new__theme_dir"
  has_light "$make_new__source_dir" && cp "$make_new__source_dir/_colors_light.scss" "$make_new__theme_dir"
  
  cp "$make_new__source_dir/gtk.scss" "$make_new__theme_dir"  
  has_dark "$make_new__source_dir" && cp "$make_new__source_dir/gtk-dark.scss" "$make_new__theme_dir"
  has_light "$make_new__source_dir" && cp "$make_new__source_dir/gtk-light.scss" "$make_new__theme_dir"
  
  cp "$make_new__source_dir/_common.scss" "$make_new__theme_dir/_common.scss" 
  cp "$make_new__source_dir/_functions.scss" "$make_new__theme_dir/_functions.scss"
  cp "$make_new__source_dir/_colors_public.scss" "$make_new__theme_dir/_colors_public.scss"
  
  gen_config "$make_new__theme_name" "$make_new__theme_dir/theme.conf"
  
  success "Theme $make_new__theme_name created. Don't forget to edit the config"
  exit
}

make_new_bundle() {
  make_new_bundle__name="$1"
  make_new_bundle__bundle_dir="$ROOT_DIR/$make_new_bundle__name"
  
  [ -d $make_new_bundle__bundle_dir ] && fail "Directory '$make_new_bundle__name' exists"
  
  display "Creating bundle $make_new_bundle__name"
  
  mkdir "$make_new_bundle__bundle_dir"
  gen_simple_config "$make_new_bundle__name" "$make_new_bundle__bundle_dir/bundle.conf"
  
  success "Bundle created"
}

implement_widget() {
  implement__target="$(sanitize $1)"
  implement__base="$(sanitize $2)"
  implement__widget="$3"
  
  [ -z "$implement__base" ] && fail 'Missing widget source'
  [ -z "$implement__widget" ] && fail 'Missing widget to implement'
  [ ! -d "$implement__target" ] && fail "Target directory '$implement__target' does not exist"
  ! is_theme "$implement__base" && fail "'$implement__base' is not a theme directory"
  
  [ ! -f "$implement__base/widgets/_$implement__widget.scss" ] && fail "Widget '$implement__widget' not found in $implement__base/widgets"
  cp -r "$implement__base/widgets/_$implement__widget.scss" "$implement__target/widgets"
  
    # Adjust depth for parent in case of bundle
  PREFIX='../'
  implement__eval_source_dir=$(dirname $implement__target)
  is_bundle "$implement__eval_source_dir" && PREFIX='../../'
  
  # redo imports
  implement__imports=$(get_imports "$implement__target")
  rm "$implement__target"/_imports.scss
  
  for implement__import in $implement__imports; do
    if [[ "$implement__import" == 'widgets'* ]]; then
      implement__import=$implement__import
    elif [[ "$implement__import" == *"/widgets/$implement__widget" ]]; then
      implement__import="widgets/$implement__widget"
    else
      implement__import=$PREFIX$implement__import
    fi
    echo "@import '$implement__import';">>"$implement__target"/_imports.scss
  done

  exit
}

config_theme() {
  config_theme__target="$(sanitize $1)"
  
  nano "$config_theme__target"/theme.conf
  exit
}

# Main

# OPS
OP_PARENTS=get_parents
OP_CHILDREN=get_children
OP_NEW=make_new
OP_NEW_BUNDLE=make_new_bundle
OP_IMPLEMENT=implement_widget
OP_CONFIG=config_theme
OP_SHELL=utils_shell

# What function we run
OP=''

# process arguments
while [ "$1" != "" ]; do
  case $1 in
    -p | --parents )        shift
                            TARGET="$1"
                            OP=$OP_PARENTS
                            ;;
    -c | --children )       shift
                            TARGET="$1"
                            OP=$OP_CHILDREN
                            ;;
    -w | --widget )         shift
                            WIDGET="$1"
                            ;;
    -n | --new )            shift
                            TARGET="$1"
                            shift
                            BASE="$1"
                            OP=$OP_NEW
                            ;;
    -h | --help )           show_help
                            ;;
    -s | --show-base )      IGNORE_BASE=1
                            ;;
    -t | --tree )           show_tree
                            ;;
    -v | --version )        show_version
                            ;;
    -b | --bundle )         OP=$OP_NEW_BUNDLE
                            shift
                            TARGET="$1"
                            ;;
    -i | --implement )      OP=$OP_IMPLEMENT
                            shift
                            TARGET="$1"
                            shift
                            BASE="$1"
                            ;;
    --config )              OP=$OP_CONFIG
                            shift
                            TARGET="$1"
                            ;;
    -* )                    fail "Invalid_argument '$1'"
                            ;;
  esac
  shift
done

[ -z $OP ] && fail "Invalid operation. Use --help to see available actions."
[ -z $TARGET ] && fail "No targets selected. Run again with at least 1 target"

if [[ "$OP" == "$OP_NEW" || "$OP" == "$OP_NEW_BUNDLE" ]]; then
  $OP "$TARGET" "$BASE"
elif [[ "$OP" == "$OP_IMPLEMENT" ]]; then
  $OP "$TARGET" "$BASE" "$WIDGET"
elif [[ "$OP" == "$OP_CONFIG" ]]; then
  $OP "$TARGET"
else
  $OP "$TARGET" "$WIDGET"
fi
