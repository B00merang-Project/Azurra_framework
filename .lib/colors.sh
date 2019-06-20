#!/bin/bash

declare -A colors

colors=( [purple]=54 [red]=124 [orange]=208 [yellow]=226 [lime]=154 [green]=40 [turquoise]=37 [blue]=21 [navy]=18 [black]=0 [gray]=243 [ash]=251 [white]=15 [cyan]=14 [forest]=34)

bg() {
  color "bg" $1
}
fg() {
  color "fg" $1
}
dcol() {
  tput sgr 0
}

color() {
  surface="$1"
  code="$2"
  
  [ -z ${colors[$code]} ] && echo "[WARNING] Bad color code: '$code'" && exit
  
  [[ $surface == 'bg' ]]  && tput setab ${colors[$code]}
  [[ $surface == 'fg' ]] && tput setaf ${colors[$code]}
}
