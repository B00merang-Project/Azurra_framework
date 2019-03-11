#!/bin/bash

SRCDIR="$PWD"

cd '../../Win_7/widgets'

for F in *; do
    if [ -f "${F}" ]; then
        cd "$SRCDIR"
        
        ln -s "../../Win_7/widgets/${F}"
        
        cd '../../Win_7/widgets'
        #ln -s "../../Win_7/widgets${F}" ${F}
    fi
done
