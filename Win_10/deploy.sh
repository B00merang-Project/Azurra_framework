#!/bin/bash

echo "Copying Windows 10"
#cp -aR assets ~/Github/Windows-10/gtk-3.20
cp -aR gtk.css ~/Github/Windows-10/gtk-3.20
cp -aR gtk-dark.css ~/Github/Windows-10/gtk-3.20
cp -aR gtk-widgets.css ~/Github/Windows-10/gtk-3.20

#cp -aR assets-dark ~/Github/Windows-10/gtk-3.20/assets
cp -aR gtk-dark.css ~/Github/Windows-10-Dark/gtk-3.20/gtk.css
cp -aR gtk-widgets.css ~/Github/Windows-10-Dark/gtk-3.20
