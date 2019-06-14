#!/bin/bash

QUEUE=$@

fail() {
  msg=$1

  echo "$msg"
  exit
}

for dir in $QUEUE; do
  if [ -f $dir/theme.conf ]; then  # if has valid configuration
    source $dir/theme.conf
  
    [ -z $variant_light ] || [ -z $variant_dark ] || [ -z $target_dir ] && fail "Config file incomplete or empty"
  
    if [ $variant_light == true ]; then
      echo "Light variant detected"
    fi
    if [ $variant_dark == true ]; then
      echo "Dark variant detected"
    fi
    if [ ! -z $target_dir ]; then
      echo "Deploy to $target_dir once ready"
    fi
  else
    fail "Not a valid directory"
  fi
done
