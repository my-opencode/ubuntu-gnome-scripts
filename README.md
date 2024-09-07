# Ubuntu Gnome Scripts

Collection of Ease-of-Life utilities for Ubuntu and Gnome. \
Must be set to executable `chmod +x script-file-name.sh`

## List

- install-appimage.sh
      - Simplifies integrating .AppImage applications with the Gnome application directory.
      - Takes the path to the .AppImage file as argument
  - Makes the .AppImage executable.
  - Places the .AppImage file to the ~/Application directory (customizable).
  - Extracts the icon from the .AppImage and places it in the ~/Application directory.
  - Extracts the .desktop file from the .AppImage.
  - Edits the .destkop file to point to the ~/Application install.
  - Places the .desktop file into the /usr/share/applications directory.
  example: `./install-appimage.sh ~/Downloads/krita-*.AppImage`
