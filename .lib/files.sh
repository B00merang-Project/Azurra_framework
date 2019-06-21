#!/bin/bash

# requires 'system.sh'

has_light() {
  has_light__theme_dir="$1"
  ret_val=1
  
  [ -f "$has_light__theme_dir"/gtk-light.scss ] && ret_val=0
  
  unset has_light__theme_dir
  return $ret_val
}

has_dark() {
  has_dark__theme_dir="$1"
  has_dark__ret_val=1
  
  [ -f "$has_dark__theme_dir"/gtk-dark.scss ] && has_dark__ret_val=0
  
  unset has_dark__theme_dir
  return $has_dark__ret_val
}

is_theme() {
  [ -f "$1"/theme.conf ] && return 0 || return 1
}

is_bundle() {
  [ -f "$1"/bundle.conf ] && return 0 || return 1
}

gen_simple_config() {
  gen_simple_config__name="$1"
  gen_simple_config__target_file="$2"
  
  echo "# use BASH syntax">>"$gen_simple_config__target_file"
  echo "name='$gen_simple_config__name'">>"$gen_simple_config__target_file"
  echo "author='$(get_full_username)'">>"$gen_simple_config__target_file"
}

gen_config() {
  gen_config__name="$1"
  gen_config__target_file="$2"
  gen_config__version='0.1'
  
  gen_simple_config "$gen_config__name" "$gen_config__target_file"
  
  echo "version='0.1'">>"$gen_config__target_file"

  echo "">>"$gen_config__target_file"
  
  echo "target_dir=''">>"$gen_config__target_file"
  echo "target_dir_dark=''">>"$gen_config__target_file"
  echo "target_dir_light=''">>"$gen_config__target_file"
}
