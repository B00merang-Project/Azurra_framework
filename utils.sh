#!/bin/bash

# Azurra Utils, a script to manage and generate themes with the Azurra Framework
# Author: Christian Medel <cmedelahumada@gmail.com>
# License: GPLv3

version=0.1
description="Azurra Utils, version $version"

# Exit codes
OK=0
ERROR=1
INVALID_ARG=2

#############################################
# FUNCTIONS
#############################################
show_help() {
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
}

show_version() {
  echo $description
  echo "Copyright (c) 2019 The B00merang Group"
  echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
}

invalid() {
  echo "Invalid argument '$1'"
}

while [ "$1" != "" ]; do
  case $1 in
    -p | --parents )        shift
                            parent=$1
                            ;;
    -c | --children )       shift
                            children=$1
                            ;;
    -w | --widget )         shift
                            children=$1
                            ;;
    -n | --new )            shift
                            name=$1
                            ;;
    -h | --help )           show_help
                            exit $OK
                            ;;
    -v | --version )        show_version
                            exit $OK
                            ;;
    * )                     invalid $1
                            exit $INVALID_ARG
  esac
  shift
done
