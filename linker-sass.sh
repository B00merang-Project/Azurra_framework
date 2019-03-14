#!/bin/bash

TARGET="$1"
SRCDIR="$PWD"

cd "../../$TARGET/widgets"

for F in *; do
  if [ -f "${F}" ]; then
    cd "$SRCDIR"
    
    ln -s "../../$TARGET/widgets/${F}"
    
    cd "../../$TARGET/widgets"
  fi
done
