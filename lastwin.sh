#!/bin/bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# allow to switch to the last active window on a given tag using Mod+LastwinKey.

Mod=${Mod:-Mod4}
LastwinKey=Shift-equal

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

# set the keybind
hc keybind $Mod-$LastwinKey substitute LASTWIN tags.focus.my_last_win jumpto LASTWIN

# main
hc --idle '(focus_changed|reload)' \
    | while read line ; do
        IFS=$'\t' read -ra args <<< "$line"
        case ${args[0]} in
            focus_changed)
                hc and \
                   . try new_attr string tags.focus.my_last_win ${args[1]} \
                   . try new_attr string tags.focus.my_current_win ${args[1]} \
                   . compare tags.focus.my_current_win "!=" ${args[1]} \
                   . substitute CURRENTWIN tags.focus.my_current_win \
                       set_attr tags.focus.my_last_win CURRENTWIN \
                   . set_attr tags.focus.my_current_win ${args[1]} \
                ;;
            reload)
                exit
                ;;
        esac
    done
