#!/bin/bash


# Get mpv or mplayer windows as "sticky", i.e visible in all tags, either in a frame in the right,
# or in full frame using maximized.sh script.
# Mod-v toggles the sticky frame.
# Emit the hook "video_sticky_changed" when toggling sticky frame.
# One can query tags.*.my_videoframe attribute to know if a tag has a "sticky frame" and
# display the result on a panel.
# Warning: works "as is", but not 100% robust to frame manipulation.


Mod=${Mod:-Mod4}
StickyKey=v

# get the absolute path of this script
SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/$(basename "${BASH_SOURCE[0]}")
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

# initialize keybinding, mpv placement rule, and listen for "tag_changed" events
init() {
   hc keybind $Mod-$StickyKey spawn $SCRIPT_PATH toggle
   hc rule class~'(MPlayer|mpv)' focus=on index=1e # bring new mpv/mplayer to the right frame (if exists)
   hc --idle '(tag_changed|reload)' \
    | while read line ; do
        IFS=$'\t' read -ra args <<< "$line"
        case ${args[0]} in
            tag_changed)
                $SCRIPT_PATH bring
                ;;
            reload)
                exit
                ;;
        esac
    done
}

# toggle sticky frame
toggle() {
   hc silent attr tags.focus.my_videoframe && hide || show && bring
}

# show sticky frame
show() {
   hc and \
      . ! silent attr tags.focus.my_videoframe \
      . or \
        case: and \
           + compare tags.focus.tiling.focused_frame.client_count "=" 0 \
           + new_attr string tags.focus.my_videoframe 1 \
           + emit_hook video_sticky_changed \
        case: substitute FOCUS clients.focus.winid chain \
         , lock \
         , try and \
            X silent substitute STR tags.focus.my_unmaximized_layout load STR \
            X remove_attr tags.focus.my_unmaximized_layout \
            X try jumpto FOCUS \
         , new_attr string tags.focus.my_videoframe 1 \
         , split right 0.8 '' \
         , focus_edge -e right \
         , set_layout vertical \
         , jumpto FOCUS \
         , emit_hook video_sticky_changed \
         , unlock
}

# hide sticky frame
hide() {
   focus=$(hc try attr clients.focus.winid)
   hc and \
      . silent attr tags.focus.my_videoframe \
      . lock \
      . try and \
         , silent substitute STR tags.focus.my_unmaximized_layout load STR \
         , remove_attr tags.focus.my_unmaximized_layout \
         , try jumpto $focus \
      . try focus_edge -e right \
      . remove \
      . remove_attr tags.focus.my_videoframe \
      . try jumpto $focus \
      . emit_hook video_sticky_changed \
      . unlock
}


# bring mpv and mplayer instances to the sticky frame
bring() {
   focus=$(hc try attr clients.focus.winid)
   hc and \
     . silent attr tags.focus.my_videoframe \
     . chain \
        , lock \
        , try focus_edge -e right \
        , foreach CLIENT clients. \
            sprintf CLASS "%c.class" CLIENT \
              and X or : compare CLASS "=" "mpv" : compare CLASS "=" "MPlayer" \
                  X sprintf WINIDATTR "%c.winid" CLIENT \
                      substitute WINID WINIDATTR \
                        bring WINID \
        , and \
          X ! silent attr tags.focus.my_unmaximized_layout \
          X try jumpto $focus \
        , unlock
}


case $1 in
   bring) bring ;;
   toggle) toggle ;;
   show) show && bring ;;
   hide) hide ;;
   *) init ;;
esac
