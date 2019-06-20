#!/bin/bash

# requires 'colors.sh'

fail() {
  # Show an error message and exit the script
  msg="$1"
  
  bg 'red' && fg 'white'
  echo "$msg$(dcol)"

  PARENT_COMMAND=$(ps -o comm= $PPID)
  pkill -f $PARENT_COMMAND
}

display() {
  # Show message
  msg="$1" && echo "$msg$(dcol)"
}

warn() {
  msg="$1" && echo "$(bg yellow)$(fg black)$msg$(dcol)"
}

table() {
  # Display in tables
  # Usage:
  
  # format=("%-3s" "%-15s" "%-0s")
  # content=("-e" "--example" "This is an example" )
  # table "$format" "$content"
  
  format=$1
  content=$2

  [ ${#format[@]} -ne ${#content[@]} ] && fail "Number of formatting and content differ"
  
  for i in "${!content[@]}"; do
    [ ! -z ${format[$i]} ] && table_format="$table_format ${format[$i]}" || table_format="$table_format %-0s"
  done
  
  printf "$table_format" "${content[@]}"
  printf "\n"
}
