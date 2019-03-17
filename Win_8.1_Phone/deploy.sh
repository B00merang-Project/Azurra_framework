#!/bin/bash

echo "Copying Windows Phone 8.1"

#cp -aR assets ~/Github/Windows-Phone-8.1/gtk-3.0
cp -aR gtk.css ~/Github/Windows-Phone-8.1/gtk-3.0
cp -aR gtk-dark.css ~/Github/Windows-Phone-8.1/gtk-3.0
cp -aR gtk-widgets.css ~/Github/Windows-Phone-8.1/gtk-3.0

#cp -aR assets-dark ~/Github/Windows-Phone-8.1-Dark/gtk-3.0/assets
cp -aR gtk-dark.css ~/Github/Windows-Phone-8.1-Dark/gtk-3.0/gtk.css
cp -aR gtk-widgets.css ~/Github/Windows-Phone-8.1-Dark/gtk-3.0
