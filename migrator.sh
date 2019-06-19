#!/bin/bash

# batch apply REGEX on all widget files
for F in *.*; do
  [ -f $F ] && sed -i 's/theme_//g' $F
  echo "$F migrated"
done
