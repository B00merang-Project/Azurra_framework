#!/bin/bash

# requires 'colors.sh'

display() {
  msg="$@" && echo "$(bg blue)$(fg white)$msg$(dcol)"
}

success() {
  msg="$@" && echo "$(bg forest)$(fg white)$msg$(dcol)"
}

warn() {
  msg="$@" && echo "$(bg yellow)$(fg black)$msg$(dcol)"
}

fail() {
  # Show an error message and exit the script
  msg="$@" && echo "$(bg 'red')$(fg 'white')$msg$(dcol)"

  exit
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
  
  unset table_format
}
