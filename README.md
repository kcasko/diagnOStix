# DiagnOStiX

**Precision Diagnosis. Peak Performance.**

DiagnOStiX is a custom Ubuntu-based diagnostic OS designed for hardware troubleshooting and system repair.  
This repo contains the branding, themes, and automation scripts used to build the DiagnOStiX ISO via [Cubic](https://launchpad.net/cubic).

---

## 🎨 Features
- **Custom GRUB theme** with DiagnOStiX branding
- **Desktop wallpaper** pre-set on boot
- Scripts to automate installation into Cubic’s rootfs + ISO tree

---

## 📂 Layout
- `grub/` – GRUB theme files (`theme.txt`, `wallpaper.png`, `diagnostix-logo.png`)
- `wallpapers/` – Default desktop wallpaper
- `scripts/install_minimal.sh` – Helper script for Cubic integration

---

## 🚀 Usage (Cubic)
1. Clone this repo inside Cubic:
   ```bash
   git clone https://github.com/kcasko/diagnostix.git
   cd diagnostix


