#!/bin/bash

# Associate a tag ("bis" tag) to a given tag.
# Use case example: dedicate a browser to a specific tag.
# Toggle between "bis" and "normal" tag with Mod+GobisKey; move window with Mod+MoveToGoKey.

Mod=${Mod:-Mod4}
GobisKey=b
MoveToGoKey=Shift-b

# get the absolute path of this script
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/$(basename "${BASH_SOURCE[0]}")

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}


init() {
   hc keybind $Mod-$GobisKey spawn $SCRIPT_PATH use
   hc keybind $Mod-$MoveToGoKey spawn $SCRIPT_PATH move
}

bis_tag() {
   current_tag=$(hc attr tags.focus.name)

   if [[ $current_tag =~ bis$ ]]
   then
      tag=${current_tag%bis}
   else
      tag=${current_tag}bis
      hc and \
        . ! silent attr tags.by-name.$tag \
        . add $tag
   fi

   hc $1 $tag
}

case $1 in
   "use") bis_tag use ;;
   "move") bis_tag move ;;
   *) init ;;
esac
