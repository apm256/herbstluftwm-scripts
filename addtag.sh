#!/usr/bin/env bash

# Add a new dynamic tag.
# Mod-NewtagKey to add a new tag. (Require dmenu.)
# Mod-RemovetagKey to remove a tag. All remaining windows will be merged in a dedicated
#  tag called "merge". "bis" tags from the bis.sh are handled, and removed too.


Mod=${Mod:-Mod4}
NewtagKey=n
RemovetagKey=Shift-n

# get the absolute path of this script
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/$(basename "${BASH_SOURCE[0]}")

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}


init() {
  hc add merged
  hc keybind $Mod-$NewtagKey spawn $SCRIPT_PATH new
  hc keybind $Mod-Shift-$RemovetagKey substitute TAG tags.focus.name and \
    . compare tags.focus.my_tmp_tag '=' true \
    . lock \
    . use merged \
    . set_layout grid \
    . merge_tag TAG merged \
    . try sprintf TAGBIS "%cbis" TAG silent merge_tag TAGBIS merged \
    . unlock
}

get_name() {
   dm() { "${dmenu_command[@]:-dmenu}" "$@" ;}
   DMENU_CONFIG="-b -fn -*-fixed-medium-*-*-*-15-*-*-*-*-*-* -nb rgb:35/45/55 -nf rgb:D0/D0/D0 -sb rgb:66/76/86 -sf rgb:FF/FF/FF"
   echo "" | dmenu $DMENU_CONFIG -p "add temporary tag: "
}

add_tag() {
   hc chain \
    . add $1 \
    . use $1 \
    . silent new_attr bool tags.focus.my_tmp_tag true
}


case "$1" in
  new) 
    tag=$(get_name)
    if [ ! -z "$tag" ] ; then add_tag $tag ; fi ;;
  *) init ;;
esac



