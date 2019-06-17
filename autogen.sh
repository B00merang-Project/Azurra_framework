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
    # - target_dir: where to copy the generated files
    source $dir/theme.conf
    
    # detect light and dark variants
    [ -f $dir/gtk-dark.scss ] && variant_dark=true || variant_dark=false
    [ -f $dir/gtk-light.scss ] && variant_light=true || variant_light=false
    
    # check if all required variables are set
    [ -z "$name" ] || [ -z $variant_light ] || [ -z $variant_dark ] || [ -z $target_dir ] && fail "Config file incomplete or empty"
    
    echo "Generating files for $name"
    
    # run SASS
    sass -C -q --sourcemap=none $dir/gtk.scss $dir/gtk.css
    [ $variant_light == true ] && sass -C -q --sourcemap=none $dir/gtk-light.scss $dir/gtk-light.css
    [ $variant_dark == true ] && sass -C -q --sourcemap=none $dir/gtk-dark.scss $dir/gtk-dark.css
  
    # copy CSS files
    cp -aR  $dir/gtk.css $target_dir
    [ $variant_light == true ] && cp -aR  $dir/gtk-light.css $target_dir
    [ $variant_dark == true ] && cp -aR  $dir/gtk-dark.css $target_dir
    
    # clean old assets and copy new ones
    rm -rf $target_dir/assets/ && cp -r $dir/assets $target_dir
    
    # if there is a light and/or dark target dir, copy corresponding resources
    if [ ! -z $target_dir_dark ]; then
      rm -rf $target_dir_dark/assets/ && cp -r $dir/assets $target_dir_dark
      cp -aR $dir/gtk-dark.css $target_dir_dark/gtk.css
    fi
    
    # verify deployment
    [ -d $target_dir/assets ] && [ -f $target_dir/gtk.css ] && echo "Deployment for $name successful" || fail "Deployment for $name failed"
  else
    fail "Not a valid directory"
  fi
done
