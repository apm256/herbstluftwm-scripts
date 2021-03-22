# herbstluftwm-scripts

A script collection for [herbstluftwm](https://github.com/herbstluftwm/herbstluftwm).
Scripts can be called from `autostart`, or just tested by running them.


## Cut and paste windows

* Description: Allow to easily move multiple windows at once from source tags to a target
tag. Cut focused windows with `Mod-y`, and paste them with `Mod-p`.

* Source: [cut-paste.sh](cut-paste.sh)


## Switch previously focused window in a tag

* Description: Allow to switch previously window in a given tag. Previous windows are remembered on tag switches.

* Source: [lastwin.sh](lastwin.sh)


## Minimize and unminimize windows

* Description: Allow to minimize and un-minimize clients in a LIFO
  way (last minimized client will be un-minimized first).
  If only one window is minimized, `Mod-Unminimizekey` works like a toggle (use
  case: user minimizes only one window per tag most of the time).

* Source: [unminimize.sh](unminimize.sh)


## Easy-access alternative tag

* Description: Associate another tag (postfixed with "bis") to a master tag.
  User can toggle between "bis" tag and master tag with `Mod+b`, or move window between them with `Mod+Shift+b`.

* Use case example: easily associate a task-specific browser to a task-specific tag.

* Source: [bis.sh](bis.sh)


## Dynamic tags

* Description: Create/remove new tags in addition to those defined in `autostart`.
  `Mod-n` creates a tag; `Mod-Shift-n` removes it.
  When removing a tag, all remaining windows are merged to a dedicated `merge` tag. "Bis" tags from the `bis.sh` scripts are removed too, if exist.
  To avoid accidental removing of static tags, `Mod-Shift-n` only has an effect with tags created with this script.

* Warning: requires `dmenu`, or `get_name` function needs to be adapted.

* Source: [addtag.sh](addtag.sh)


## VIM-like marks for tags

* Description: Implement VIM-like marks for tags. One-letter mark can be
  set/unset on a tag (`Mod+Alt+[a-z]`/`Mod+Alt+Shift+[a-z]`); marked tags are focusable
  with `Mod+Ctrl+[a-z]`; and windows are movable to a marked tag with
  `Mod+Ctrl+Shift+[a-z]`.

* Attribute: The mark of a tag is available (i.e. to be displayed on the panel) with the following attribute: `tags.*.my_mark`

* Use case example: allow easy access to dynmaic tags created with `addtag.sh`.

* Source: [mark-tags.sh](mark-tags.sh)
