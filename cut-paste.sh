#!/usr/bin/env bash

# Allows to easily move multiple windows at once from source tags to a target
# tag. Cut windows with Mod-y, and paste them with Mod-p.


Mod=${Mod:-Mod4}
CutKey=y
PasteKey=p

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}


# cut
hc keybind $Mod-$CutKey chain \
  . new_attr bool clients.focus.my_marked_client true \
  . set_attr clients.focus.minimized true

# paste
hc keybind $Mod-$PasteKey foreach CLIENT clients. \
   sprintf ATT "%c.my_marked_client" CLIENT and \
     . silent compare ATT "=" true \
     . sprintf IDATT "%c.winid" CLIENT \
         substitute M IDATT bring M \
     . remove_attr ATT \
