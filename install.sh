#!/bin/bash
# Install frofi: symlink the two scripts into ~/.local/bin and register the
# daemon to autostart at login. Re-running is safe (idempotent).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
bindir="${XDG_BIN_HOME:-$HOME/.local/bin}"
autostart="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"

mkdir -p "$bindir" "$autostart"
ln -sfn "$here/frofi"        "$bindir/frofi"
ln -sfn "$here/frofi-daemon" "$bindir/frofi-daemon"

cat > "$autostart/frofi.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=frofi
Comment=Resident window switcher daemon
Exec=$bindir/frofi-daemon
X-GNOME-Autostart-enabled=true
NoDisplay=true
EOF

echo "Installed:"
echo "  $bindir/frofi"
echo "  $bindir/frofi-daemon"
echo "  $autostart/frofi.desktop (autostart at login)"
echo
echo "Bind a key (e.g. Super+Tab) to:  $bindir/frofi"
echo "Bind slot keys (F1..F12) to:     $bindir/frofi focus-slot N"
echo "Start the daemon now with:        frofi-daemon &"
