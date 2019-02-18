#!/bin/bash

echo "Copying macOS"
#cp -aR assets ~/Github/macOS/gtk-3.20
cp -aR gtk.css ~/Github/macOS/gtk-3.20
cp -aR gtk-dark.css ~/Github/macOS/gtk-3.20
cp -aR gtk-widgets.css ~/Github/macOS/gtk-3.20

#rm -rf ~/Github/macOS-Dark/gtk-3.20/assets
#cp -aR assets-dark ~/Github/macOS-Dark/gtk-3.20/assets
cp -aR gtk-dark.css ~/Github/macOS-Dark/gtk-3.20/gtk.css
cp -aR gtk-widgets.css ~/Github/macOS-Dark/gtk-3.20

