#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 1) desktop wallpaper (rootfs)
install -Dm0644 "$REPO_DIR/wallpapers/wallpaper.png" /usr/share/backgrounds/wallpaper.png
cat >/usr/share/glib-2.0/schemas/99_diagnostix.gschema.override <<'EOG'
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/wallpaper.png'
[org.gnome.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/wallpaper.png'
EOG
glib-compile-schemas /usr/share/glib-2.0/schemas/

# 2) GRUB theme (rootfs)
install -d /boot/grub/themes/diagnostix
cp -f "$REPO_DIR/grub/"*.png /boot/grub/themes/diagnostix/ 2>/dev/null || true
cp -f "$REPO_DIR/grub/theme.txt" /boot/grub/themes/diagnostix/theme.txt

# 3) GRUB theme (ISO tree) + configs
ISO_ROOT="/custom/iso"
install -d "$ISO_ROOT/boot/grub/themes/diagnostix"
cp -f "$REPO_DIR/grub/"*.png "$ISO_ROOT/boot/grub/themes/diagnostix/" 2>/dev/null || true
cp -f "$REPO_DIR/grub/theme.txt" "$ISO_ROOT/boot/grub/themes/diagnostix/theme.txt"

# ensure set theme is in both grub.cfg files
if ! grep -q 'set theme=/boot/grub/themes/diagnostix/theme.txt' "$ISO_ROOT/boot/grub/loopback.cfg" 2>/dev/null; then
  sed -i '1iset theme=/boot/grub/themes/diagnostix/theme.txt' "$ISO_ROOT/boot/grub/loopback.cfg"
fi

if ! grep -q 'set theme=/boot/grub/themes/diagnostix/theme.txt' "$ISO_ROOT/boot/grub/grub.cfg" 2>/dev/null; then
  awk '1; /terminal_output gfxterm/ && !x{print "set theme=/boot/grub/themes/diagnostix/theme.txt"; x=1}' \
    "$ISO_ROOT/boot/grub/grub.cfg" > /tmp/grub.new && mv /tmp/grub.new "$ISO_ROOT/boot/grub/grub.cfg"
fi

# ensure image modules present
grep -q 'insmod gfxterm' "$ISO_ROOT/boot/grub/grub.cfg" || sed -i '1i insmod gfxterm' "$ISO_ROOT/boot/grub/grub.cfg"
grep -q 'insmod png'     "$ISO_ROOT/boot/grub/grub.cfg" || sed -i '1i insmod png'     "$ISO_ROOT/boot/grub/grub.cfg"
grep -q 'insmod all_video' "$ISO_ROOT/boot/grub/grub.cfg" || sed -i '1i insmod all_video' "$ISO_ROOT/boot/grub/grub.cfg"

echo "Done. GRUB theme + wallpaper installed. Build the ISO."
