#!/bin/bash

# A script to quickly generate a list, bundle or all indexed themes
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=2.1
description="Azurra Autogen, version $version"

LOCK_ADD=false
ROOT_DIR="$PWD"
BASE_THEME='Azurra'
WIKI=http://github.com/Elbullazul/Azurra_framework/wiki

# OPS
GEN_AND_DEPLOY=build
GEN_ONLY=just_sass
DEPLOY_ONLY=just_deploy
SCRIPT=run_script

BUNDLE_DISPLAY=false

# FOR DEBUG
breakpoint() {
  read -p "Breakpoint at $(basename $0), line $BASH_LINENO. Continue? " var
}

# Coloring functions
cyan() {
  [ -z $1 ] && tput setab 12 || tput setaf 12
}

blue() {
  [ -z $1 ] && tput setab 4 || tput setaf 4
}

green() {
  [ -z $1 ] && tput setab 2 || tput setaf 2
}

red() {
  [ -z $1 ] && tput setab 1 || tput setaf 1
}

reset() {
  tput sgr 0
}

white() {
  [ -z $1 ] && tput setab 7 || tput setaf 7
}

gray() {
  [ -z $1 ] && tput setab 237 || tput setaf 237
}

# Support functions
show_help() {
  echo $description
  echo
  
  echo "Usage:  ./autogen.sh <ARGUMENTS> <TARGETS>"
  echo
  
  echo "Generates and deploys CSS and asset files"
  echo
  
  echo "  -h   --help         " "Shows help"
  echo "  -v   --version      " "Script version"
  echo "  -q   --quiet        " "Silences ALL SASS warnings"
  echo "  -a   --all          " "Generates and deploys all themes with valid configuration"
  echo "  -d   --deploy       " "Deploys current files"
  echo "  -c   --compile      " "Run SASS compiler only (no deployment)"
  
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

# Functions for reusability & recursion
fail() {
  msg="$1"
  end="$2"
  
  red
  echo "$msg$(reset)"
  
  exit
}

display() {
  msg="$1"
  end="$2"
  
  if [[ $BUNDLE_DISPLAY == true ]]; then
    [ ! -z $end ] && echo -n "└─ " || echo -n "├─ "
  fi
  echo "$msg"
  
  unset msg
}

has_light() {
  has_light__theme_dir="$1"
  ret_val=1
  
  [ -f "$has_light__theme_dir"/gtk-light.scss ] && ret_val=0
  
  unset has_light__theme_dir
  return $ret_val
}

has_dark() {
  has_dark__theme_dir="$1"
  ret_val=1
  
  [ -f "$has_dark__theme_dir"/gtk-dark.scss ] && ret_val=0
  
  unset has_dark__theme_dir
  return $ret_val
}

clean() {
  clean__theme_dir="$1"
  
  [ -f "$clean__theme_dir"/gtk.css ] && rm "$clean__theme_dir"/gtk.css
  [ -f "$clean__theme_dir"/gtk-dark.css ]  && rm "$clean__theme_dir"/gtk-dark.css
  [ -f "$clean__theme_dir"/gtk-light.css ] && rm "$clean__theme_dir"/gtk-light.css
  
  # Remove previous files
  [ -f "$clean__theme_dir"/gtk-widgets.css ] && echo "Force-cleaning $clean__theme_dir" && rm "$clean__theme_dir"/gtk-widgets.css
  
  unset clean__theme_dir
}

load_config() {
  # Load variables
  # <name, author, version, target_dir, target_dir_dark, target_dir_light>
  # from theme config

  load_config__dir="$1"
  source "$load_config__dir"/theme.conf
  
  # check if all required variables are set
  [ -z "$name" ] || [ -z "$version" ] || [ -z "$target_dir" ] && fail "For '$build__theme_dir': config file incomplete or empty"
}

gen_sass() {
  gen_sass__theme_dir="$1"
  
  clean "$gen_sass__theme_dir"
  
  # sass_args is set in main()
  sass $sass_args $gen_sass__theme_dir/gtk.scss $gen_sass__theme_dir/gtk.css
  [ $? -ne 0 ] && fail "SASS error in stylesheet"
  # Abort if SASS error
  
  if has_dark "$gen_sass__theme_dir"; then
    sass $sass_args $gen_sass__theme_dir/gtk-dark.scss $gen_sass__theme_dir/gtk-dark.css
    [ $? -ne 0 ] && fail "SASS error in dark stylesheet"
  fi
  
  if has_light "$gen_sass__theme_dir"; then
    sass $sass_args $gen_sass__theme_dir/gtk-light.scss $gen_sass__theme_dir/gtk-light.css
    [ $? -ne 0 ] && fail "SASS error in light stylesheet"
  fi
  
  unset gen_sass__theme_dir
}

deploy() {
  deploy__theme_dir="$1"
  
  target="$2"
  target_dark="$3"
  target_light="$4"
  
  # verify files are OK
  [ ! -f "$deploy__theme_dir"/gtk.css ] && fail "Stylesheet missing. Aborting"
  [ ! -z $target_dark ] && [ ! -f "$deploy__theme_dir"/gtk-dark.css ] && fail "Dark stylesheet missing. Aborting"
  [ ! -z $target_light ] && [ ! -f "$deploy__theme_dir"/gtk-light.css ] && fail "Light stylesheet missing. Aborting"

  # remove previously generated files. always back up your work!
  clean "$target"
  [ ! -z "$target_dark" ] && clean "$target_dark"
  [ ! -z "$target_light" ] && clean "$target_light"

  # copy CSS files
  cp "$deploy__theme_dir"/gtk.css "$target"
  has_dark "$deploy__theme_dir" && cp "$deploy__theme_dir"/gtk-dark.css "$target"
  has_light "$deploy__theme_dir" && cp "$deploy__theme_dir"/gtk-light.css "$target"
  
  # clean old assets and copy new ones
  rm -rf "$target"/assets/ && cp -r "$deploy__theme_dir"/assets "$target"
  
  # if there are dark source and target dirs, copy corresponding resources
  if [ ! -z "$target_dark" ]; then
    [ -d "$deploy__theme_dir"/assets-dark ] && src="$deploy__theme_dir"/assets-dark || src="$deploy__theme_dir"/assets
    rm -rf "$target_dark"/assets/ && cp -r "$src" "$target_dark"/assets
    cp "$deploy__theme_dir"/gtk-dark.css "$target_dark"/gtk.css
  fi
  
  # if there are light source and target dirs, copy corresponding resources
  if [ ! -z "$target_light" ]; then
    [ -d "$deploy__theme_dir"/assets-light ] && src="$deploy__theme_dir"/assets-light || src="$deploy__theme_dir"/assets
    rm -rf "$target_light"/assets/ && cp -r "$src" "$target_light"/assets
    cp "$deploy__theme_dir"/gtk-light.css "$target_light"/gtk.css
  fi
  
  # verify deployment
  
  # test main target
  [ ! -d "$target"/assets ] && fail "Failed to deploy assets to '$target'"
  [ ! -f "$target"/gtk.css ] && fail "Failed to deploy stylesheet to '$target'"
  has_dark "$deploy__theme_dir" && [ ! -f "$target"/gtk-dark.css ] && fail "Failed to deploy $(gray)dark$(red) stylesheet to '$target'"
  has_light "$deploy__theme_dir" && [ ! -f "$target"/gtk-light.css ] && fail "Failed to deploy $(white)light$(red) stylesheet to '$target'"

  # test secondary targets
  [ ! -z "$target_dark" ] && [ ! -d "$target_dark"/assets ] && fail "Failed to deploy assets to '$target_dark'"
  [ ! -z "$target_dark" ] && [ ! -f "$target_dark"/gtk.css ] && fail "Failed to deploy $(gray)dark$(red) stylesheet to '$target_dark'"
  
  [ ! -z "$target_light" ] && [ ! -d "$target_light"/assets ] && fail "Failed to deploy assets to '$target_light'"
  [ ! -z "$target_light" ] && [ ! -f "$target_light"/gtk.css ] && fail "Failed to deploy $(white)light$(red) stylesheet to '$target_light'"
  
  unset deploy__theme_dir target target_dark target_light
}

# Work meta-functions
build() {
  build__theme_dir="$1"
  
  load_config "$build__theme_dir"
  
  display "Generating files for $(cyan fg)$name$(reset)"
  
  gen_sass "$build__theme_dir"

  # imported from config
  deploy "$build__theme_dir" "$target_dir" "$target_dir_dark" "$target_dir_light"
  
  display "Deployment for $name $(green)successful$(reset)" 'end'

  unset build__theme_dir
}

just_sass() {
  display "Compiling $1"
  
  gen_sass $@
  
  display "Done." 'last'
}

just_deploy() {
  display "Deploying $1"
  
  load_config $@

  # imported from config
  deploy "$1" "$target_dir" "$target_dir_dark" "$target_dir_light"
  
  display "Done." 'last'
}

# Main
OP=$GEN_AND_DEPLOY
sass_args="-C --sourcemap=none"

declare -a QUEUE

# process arguments
while [ "$1" != "" ]; do
  case $1 in
    -q | --quiet )          sass_args="$sass_args -q"
                            ;;
    -a | --all )            QUEUE=*/
                            LOCK_ADD=true
                            ;;
    -c | --compile )        OP=$GEN_ONLY
                            ;;
    -d | --deploy )         OP=$DEPLOY_ONLY
                            ;;
    -h | --help )           show_help
                            ;;
    -v | --version )        show_version
                            ;;
    *)                      [ $LOCK_ADD == false ] && QUEUE+=("$1")
                            ;;
  esac
  shift
done

for dir in ${QUEUE[@]}; do
  # ignore base theme
  if [[ "$dir" != "$BASE_THEME"* ]]; then

    if [ -f "$dir"/theme.conf ]; then     # if has valid configuration
      $OP "$dir"
      echo
    elif [ -f "$dir"/bundle.conf ]; then  # if is a bundle directory
      source "$dir"/bundle.conf
      
      bundle_name=$name
      
      echo "Processing $bundle_name bundle"
      BUNDLE_DISPLAY=true
      
      for bundle_dir in "$dir"/*; do
        [ -f "$bundle_dir"/theme.conf ] && $OP "$bundle_dir"
      done
      
      BUNDLE_DISPLAY=false
      echo "Bundle $bundle_name completed"
      echo
    else
      fail "Not a valid directory '$dir'"
    fi
  
  fi
done
