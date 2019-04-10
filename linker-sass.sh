#!/bin/bash

TARGET="Azurra"

if [ ! -z "$1" ]; then
  TARGET="$1"
fi

SRCDIR="$PWD"

cd "../../$TARGET/widgets"

for F in *; do
  if [ -f "${F}" ]; then
    cd "$SRCDIR"
    
    ln -s "../../$TARGET/widgets/${F}"
    
    cd "../../$TARGET/widgets"
  fi
done

cd "$SRCDIR"
rm linker-sass.sh
