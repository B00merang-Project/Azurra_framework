#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="assets.svg"
ASSETS_DIR="assets"

DARK_SRC_FILE="assets-dark.svg"
DARK_ASSETS_DIR="assets-dark"

HIDPI=1

INDEX="assets.txt"

declare -a args
args=("$@")

for f in ${!args[@]}
do
  case ${args[$f]} in
    -g|--gtk-2.0)
      HIDPI=0
    ;;
    -d|--dark)
      SRC_FILE=$DARK_SRC_FILE
      ASSETS_DIR=$DARK_ASSETS_DIR
    ;;
    -c|--clear)
      for i in `cat $INDEX`
      do
        rm $ASSETS_DIR/$i.png
        rm $DARK_ASSETS_DIR/$i.png
        
        if [ -f $ASSETS_DIR/$i@2.png ]; then
          rm $ASSETS_DIR/$i@2.png
        fi
        
        if [ -f $DARK_ASSETS_DIR/$i@2.png ]; then
          rm $DARK_ASSETS_DIR/$i@2.png
        fi
      done

      exit 0
    ;;
  esac
done

for i in `cat $INDEX`
  do
  if [ -f $ASSETS_DIR/$i.png ]; then
      echo $ASSETS_DIR/$i.png exists.
  else
      echo
      echo Rendering $ASSETS_DIR/$i.png
      $INKSCAPE --export-id=$i \
                --export-id-only \
                --export-png=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
      && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png 
  fi
  
  if [ $HIDPI -eq 1 ]; then
    if [ -f $ASSETS_DIR/$i@2.png ]; then
        echo $ASSETS_DIR/$i@2.png exists.
    else
        echo
        echo Rendering $ASSETS_DIR/$i@2.png
        $INKSCAPE --export-id=$i \
                  --export-dpi=180 \
                  --export-id-only \
                  --export-png=$ASSETS_DIR/$i@2.png $SRC_FILE >/dev/null \
        && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i@2.png 
    fi
  fi
done
exit 0
