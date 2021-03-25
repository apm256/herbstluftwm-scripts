#!/usr/bin/env bash

# Implement VIM-like "marks" for tags. One-letter mark can be set/unset on
# a tag (MarkKey+[a-z]/UnmarkKey+[a-z]); marked tags are focusable with UseMarkKey+[a-z];
# and windows are movable to a marked tag with MoveToMarkKey+[a-z].
#
# (Can be useful to easy access of dynamic tags created with addtag.sh.)
#
# The mark of a tag is available (i.e. to be displayed on the panel) with the following attribute:
#   tags.*.my_mark

Mod=${Mod:-Mod4}
MarkKey=$Mod-Alt
UnmarkKey=$Mod-Shift-Alt
UseMarkKey=$Mod-Ctrl
MoveToMarkKey=$Mod-Shift-Ctrl

# get the absolute path of this script
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/$(basename "${BASH_SOURCE[0]}")

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}


init() {
   for key in {a..z} ; do
     hc keybind "$MarkKey-$key" spawn $SCRIPT_PATH mark "$key"
     hc keybind "$UnmarkKey-$key" spawn $SCRIPT_PATH unmark "$key"
     hc keybind "$UseMarkKey-$key" spawn $SCRIPT_PATH use "$key"
     hc keybind "$MoveToMarkKey-$key" spawn $SCRIPT_PATH move "$key"
   done
}

unmark_tag() {
  hc foreach TAG tags. \
     sprintf MARK "%c.my_mark" TAG and \
       , silent compare MARK = "$1" \
       , remove_attr MARK
}

mark_tag() {
  hc chain \
     . foreach TAG tags. \
         sprintf MARK "%c.my_mark" TAG and \
           , silent compare MARK = "$1" \
           , remove_attr MARK \
     . silent remove_attr tags.focus.my_mark \
     . new_attr string tags.focus.my_mark "$1"
}

search_mark() {
  hc mktemp int MARKEDTAGATT chain \
     . set_attr MARKEDTAGATT "-1" \
     . foreach TAG tags. \
         sprintf MARK "%c.my_mark" TAG and \
           , silent compare MARK = "$1" \
           , sprintf INDEXATT "%c.index" TAG \
               substitute INDEX INDEXATT set_attr MARKEDTAGATT INDEX \
     . and \
         , compare MARKEDTAGATT != "-1" \
         , substitute INDEX MARKEDTAGATT $2 INDEX
}

use_mark() {
  search_mark $1 "or : and '?' compare tags.focus.index = INDEX '?' use_previous : use_index"
}

move_mark() {
  search_mark $1 move_index
}


case "$1" in
  mark) mark_tag $2 ;;
  unmark) unmark_tag $2 ;;
  use) use_mark $2 ;;
  move) move_mark $2 ;;
  *) init ;;
esac
