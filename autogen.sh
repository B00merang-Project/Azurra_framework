#!/bin/bash

BASE="Azurra"
QUEUE="$@"

# compile all if no theme specified
if [[ -z "$QUEUE" ]]
then
  QUEUE=*
fi

for dir in $QUEUE
do
  if [ -d "$dir" ] &&               # it's a directory
     [ "$dir" != "$BASE" ] &&	      # not the base theme
     [ -f "$dir/build.sh" ] &&      # is buildable
     [ -f "$dir/deploy.sh" ]; then  # is deployable
    echo "Building $dir"

    cd "$dir"
    ./build.sh
    ./deploy.sh
    cd ..
  elif [ -f "$dir" ]; then
    # don't warn of root dir files
    echo "$dir" > /dev/null
  else
    echo "Invalid directory ($dir)."
  fi
done
