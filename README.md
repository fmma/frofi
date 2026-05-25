# frofi

A resident window switcher daemon for X11 / EWMH desktops. A single
long-running process keeps a live window list and renders an
override-redirect GTK popup on demand, so the switcher appears in a few
milliseconds rather than the few hundred a cold launcher costs.

The name is a contraction of "Frederik" and "rofi": frofi replaces a
rofi-based window switcher with an always-resident equivalent.

## Features

- Per-workspace window list, active window preselected, type-to-filter.
- Workspaces overview mode listing every workspace's windows at once,
  each group behind a labeled divider; empty workspaces and groups whose
  windows all filter out hide their divider.
- Stable F1-F12 slots, per workspace, held in memory for the daemon's
  lifetime; slots keep their holes when a window closes and reclaim the
  lowest empty index. A daemon restart starts from empty slots.
- Per-window tags held in memory for the daemon's lifetime, shown
  inline as `[tag]`.
- Layout-mode glyph per row: `▣` floating, `■` maximized, `◧`/`◨` left
  or right half-tile, with the monitor number when more than one is
  attached.
- Built-in drun-style application launcher (Ctrl+R re-reads desktop
  files to pick up installed or removed apps). Tab cycles windows,
  workspaces, and the launcher; Shift+Tab cycles back.
- Direct keyboard actions: Enter activates and dismisses, Ctrl+Enter
  activates a window while leaving the switcher open, Delete closes,
  Alt+Left/Right move a window across workspaces, Ctrl+Alt+Left/Right
  switch workspace, Alt+Up/Down reorder a slot, Ctrl+T edits a tag
  inline, F1-F12 jump to a slot.
- Layout-mode actions mirroring GNOME: Super+Up maximizes, Super+Down
  floats, Super+Left/Right half-tiles, Super+Shift+Left/Right move the
  window to the previous or next monitor (clamped, not wrapped).

## How it works

The daemon reads the window list through libwnck, which stays current via X
events, so showing the switcher spawns no subprocesses. Window actions
(activate, close, move, switch workspace) are sent as X messages. Clients
talk to the daemon over a Unix socket; the `frofi` wrapper sends the one-line
command with `socat` to avoid paying Python startup on every keypress.

## Dependencies

- Python 3 with PyGObject (`python3-gi`).
- GTK 3 and libwnck 3 GObject introspection data
  (`gir1.2-gtk-3.0`, `gir1.2-wnck-3.0`).
- `socat` (optional; the wrapper falls back to a Python client without it).

On Debian/Ubuntu:

```
sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-wnck-3.0 socat
```

## Install

```
./install.sh
```

This symlinks `frofi` and `frofi-daemon` into `~/.local/bin` and registers the
daemon to autostart at login. Then bind keys to the wrapper:

- A switcher key (e.g. Super+Tab) to `frofi`.
- Slot keys F1-F12 to `frofi focus-slot N`.

## Usage

```
frofi                 show the switcher (starts the daemon if needed)
frofi focus-slot N    activate the window in slot N, no UI
frofi-daemon          run the daemon in the foreground
```

Set `FROFI_DEBUG=1` to log show latency to stderr.
