#!/bin/bash

QUEUE=$@

fail() {
  msg=$1

  echo "$msg"
  exit
}

sass_args="-C --sourcemap=none"

for dir in $QUEUE; do
  if [ -f "$dir"/theme.conf ]; then  # if has valid configuration
    # Load variables from theme config. Variables allowed:
    # - name: theme name to display
    # - target_dir: where to copy the generated files
    source "$dir"/theme.conf
    
    # detect light and dark variants
    [ -f "$dir"/gtk-dark.scss ] && variant_dark=true || variant_dark=false
    [ -f "$dir"/gtk-light.scss ] && variant_light=true || variant_light=false
    
    # check if all required variables are set
    [ -z "$name" ] || [ -z $variant_light ] || [ -z $variant_dark ] || [ -z "$target_dir" ] && fail "Config file incomplete or empty"
    
    echo "Generating files for $name"
    
    # run SASS
    sass $sass_args $dir/gtk.scss $dir/gtk.css
    [ $variant_light == true ] && sass $sass_args $dir/gtk-light.scss $dir/gtk-light.css
    [ $variant_dark == true ] && sass $sass_args $dir/gtk-dark.scss $dir/gtk-dark.css
  
    # copy CSS files
    cp -aR  "$dir"/gtk.css "$target_dir"
    [ $variant_light == true ] && cp -aR  "$dir"/gtk-light.css "$target_dir"
    [ $variant_dark == true ] && cp -aR  "$dir"/gtk-dark.css "$target_dir"
    
    # clean old assets and copy new ones
    rm -rf "$target_dir"/assets/ && cp -r "$dir"/assets "$target_dir"
    
    # if there are light and/or dark source and target dirs, copy corresponding resources
    if [ ! -z "$target_dir_dark" ]; then
      [ -d "$dir"/assets-dark ] && src="$dir"/assets-dark || src="$dir"/assets
      rm -rf "$target_dir_dark"/assets/ && cp -r $src "$target_dir_dark"/assets
      cp -aR "$dir"/gtk-dark.css "$target_dir_dark"/gtk.css
    fi
    
    if [ ! -z "$target_dir_light" ]; then
      [ -d "$dir"/assets-light ] && src="$dir"/assets-light || src="$dir"/assets
      rm -rf "$target_dir_light"/assets/ && cp -r $src "$target_dir_light"/assets
      cp -aR "$dir"/gtk-light.css "$target_dir_light"/gtk.css
    fi
    
    # verify deployment
    [ -d "$target_dir"/assets ] && [ -f "$target_dir"/gtk.css ] && echo "Deployment for $name successful" || fail "Deployment for $name failed"
  else
    [[ "$dir" == "-q" ]] && sass_args="$sass_args -q" && shift || fail "Not a valid directory '$dir'"
  fi
done
