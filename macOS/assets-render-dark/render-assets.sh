#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

ASSETS_DIR="assets"

HIDPI=1

for f in $@
do
  case $f in
    -g|--gtk-2.0)
      HIDPI=0
    ;;
    -c|--clear)
      for i in *.svg
      do
        extension="${i##*.}"
        name=${i%".$extension"}
        echo $ASSETS_DIR
        rm $ASSETS_DIR/$name.png
        rm $DARK_ASSETS_DIR/$name.png
        
        if [ -f $ASSETS_DIR/$name@2.png ]; then
          rm $ASSETS_DIR/$name@2.png
        fi
      done

      exit 0
    ;;
  esac
done

for i in *.svg
do
  extension="${i##*.}"
  name=${i%".$extension"}

  if [ -f $ASSETS_DIR/$name.png ]; then
    echo $ASSETS_DIR/$name.png exists.
  else
    echo
    echo Rendering $ASSETS_DIR/$name.png
    
    $INKSCAPE -z -e "$ASSETS_DIR/$name.png" -w 16 -h 16 "$i" >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$name.png
  fi
  
  if [ $HIDPI -eq 1 ]; then
    if [ -f $ASSETS_DIR/$name@2.png ]; then
        echo $ASSETS_DIR/$name@2.png exists.
    else
      echo
      echo Rendering $ASSETS_DIR/$name.png
      
      $INKSCAPE -z -e "$ASSETS_DIR/$name@2.png" -w 32 -h 32 "$i" >/dev/null \
      && $OPTIPNG -o7 --quiet $ASSETS_DIR/$name@2.png
    fi
  fi
done
