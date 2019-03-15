#!/bin/bash

echo "Copying Windows 10 Acrylic"

#cp -aR assets ~/Github/Windows-10-Acrylic/gtk-3.0
cp -aR gtk.css ~/Github/Windows-10-Acrylic/gtk-3.0
cp -aR gtk-dark.css ~/Github/Windows-10-Acrylic/gtk-3.0
cp -aR gtk-widgets.css ~/Github/Windows-10-Acrylic/gtk-3.0

# rm -rf ~/Github/Windows-10-Acrylic-Dark/gtk-3.0/assets
#cp -aR assets-dark ~/Github/Windows-10-Acrylic-Dark/gtk-3.0
cp -aR gtk-dark.css ~/Github/Windows-10-Acrylic-Dark/gtk-3.0/gtk.css
cp -aR gtk-widgets.css ~/Github/Windows-10-Acrylic-Dark/gtk-3.0
