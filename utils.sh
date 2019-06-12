#!/bin/bash

# Azurra Utils, a script to manage and generate themes with the Azurra Framework
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=0.1
description="Azurra Utils, version $version"

# Operation codes
OP_EXIT=0
OP_NEW=1
OP_PARENTS=2
OP_CHILDREN=3

# Exit codes
CODE_OK=0
CODE_FAIL=1
CODE_UNKOWN=2

#############################################
# FUNCTIONS
#############################################

TARGET=0
OP=0
WIDGETS=0
ALL=0

for arg in "$@"
do
  case $arg in
    -p|--parents)
    ;;
    
    -c|--children)
    ;;
    
    -w|--widget)
    ;;
    
    -n|--new)
    
    ;;
  
    -h|--help)
      echo $description
      echo
    
      echo "  -h   --help         " "Shows help"
      echo "  -v   --version      " "Script version"
      echo "  -p   --parents      " "List of widgets inherited from other themes Requires <target>"
      echo "  -c   --children     " "List of themes using resources from a theme. Requires <target>"
      echo "  -a   --all          " "Use with -p or -c, do operation for all themes"
      echo "  -w   --widget       " "Use with -p or -c, restricts search to <widget>"
      echo "  -n   --new          " "Initialise a new theme directory. Requires <name> and <parent> (Azurra by default)"

      echo
      echo "More information: <http://github.com/Azurra_Utils/wiki>"
      
      OP=$OP_EXIT
    ;;
    
   -v|--version)
      echo $description
      echo "Copyright (c) 2019 The B00merang Group"
      echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
      
      OP=$OP_EXIT
    ;;
    
    -*)
      echo "Unknown action: $arg"
      # interrupt
      exit
    ;;
  esac
done

case $OP in
  "$OP_EXIT")
    exit $CODE_OK
  ;;
  "$OP_NEW")
  
  ;;
  "$OP_PARENT")
  
  ;;
  "$OP_CHILDREN")
  
  ;;
esac
