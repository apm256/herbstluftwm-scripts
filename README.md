# herbstluftwm-scripts

A script collection for [herbstluftwm](https://github.com/herbstluftwm/herbstluftwm).
Scripts can be called from `autostart`, or just tested by running them.


## Cut and paste windows

* Description: Allow to easily move multiple windows at once from source tags to a target
tag. Cut focused windows with Mod-y, and paste them with Mod-p.

* Source: [cut-paste.sh](cut-paste.sh)


## Switch previously focused window in a tag

* Description: Allow to switch previously window in a given tag. Previous windows are remembered on tag switches.

* Source: [lastwin.sh](lastwin.sh)


## Minimize and unminimize windows

* Description: Allow to minimize and un-minimize clients in a LIFO
  way (last minimized client will be un-minimized first).
  If only one window is minimized, Mod-Unminimizekey works like a toggle (use
  case: user minimizes only one window per tag most of the time).

* Source: [unminimize.sh](unminimize.sh)
