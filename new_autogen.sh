#!/bin/bash

QUEUE=$@

fail() {
  msg=$1

  echo "$msg"
  exit
}

for dir in $QUEUE; do
  if [ -f $dir/theme.conf ]; then  # if has valid configuration
    # Load variables from theme config. Variables allowed:
    # - name: theme name to display
    # - variant_dark: if it has a dark variant
    # - variant_light: if it has a light variant
    # - target_dir: where to copy the generated files
    source $dir/theme.conf
    
    # check if all required variables are set
    [ -z "$name" ] || [ -z $variant_light ] || [ -z $variant_dark ] || [ -z $target_dir ] && fail "Config file incomplete or empty"
    
    echo "Generating files for $name"
    
    # run SASS
    sass -C -q --sourcemap=none $dir/_common.scss $dir/gtk.css
    [ $variant_light == true ] && sass -C -q --sourcemap=none $dir/_common_light.scss $dir/gtk-light.css
    [ $variant_dark == true ] && sass -C -q --sourcemap=none $dir/_common_dark.scss $dir/gtk-dark.css
  
    # recopy assets
    rm -rf $target_dir/assets/ && cp -r $dir/assets $target_dir    
    
    # copy CSS files
    cp -aR  $dir/gtk.css $target_dir
    [ $variant_light == true ] && cp -aR  $dir/gtk-light.css $target_dir
    [ $variant_dark == true ] && cp -aR  $dir/gtk-dark.css $target_dir
    
    # verify deployment
    [ -d $target_dir/assets ] && [ -f $target_dir/gtk.css ] && echo "Deployment for $name successful" || fail "Deployment for $name failed"
  else
    fail "Not a valid directory"
  fi
done
