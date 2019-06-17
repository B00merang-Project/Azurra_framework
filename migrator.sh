#!/bin/bash

for F in *.*; do
  [ -f $F ] && [ $F != "migrator.sh" ] && sed -i 's/theme_//g' $F
  echo "$F"
done
