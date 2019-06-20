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

gen_config() {
  gen_config__name="$1"
  gen_config__target_dir="$1"
  
  gen_config__author="$USER"
  gen_config__version='0.1'
  
  echo "# use BASH syntax">>"$gen_config__target_dir"/theme.conf
  echo "name='$gen_config__name'">>"$gen_config__target_dir"/theme.conf
  echo "author='$(get_full_username)'">>"$gen_config__target_dir"/theme.conf
  echo "version='0.1'">>"$gen_config__target_dir"/theme.conf

  echo "">>"$gen_config__target_dir"/theme.conf
  
  echo "target_dir=''">>"$gen_config__target_dir"/theme.conf
  echo "target_dir_dark=''">>"$gen_config__target_dir"/theme.conf
  echo "target_dir_light=''">>"$gen_config__target_dir"/theme.conf
}
