#!/bin/bash

# build
echo "Building macOS"
cd macOS_10.14
./run.sh

echo "Building OS X Yosemite"
cd ../OS_X_10.10
./run.sh

echo "Building Windows 10"
cd ../Win_10
./run.sh

cd ..

# macOS
echo "Copying macOS"
cp -aR macOS_10.14/assets ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk.css ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk-dark.css ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk-widgets.css ~/Github/macOS/gtk-3.20

cp -aR macOS_10.14/assets ~/Github/macOS-Dark/gtk-3.20
cp -aR macOS_10.14/gtk-dark.css ~/Github/macOS-Dark/gtk-3.20/gtk.css
cp -aR macOS_10.14/gtk-widgets.css ~/Github/macOS-Dark/gtk-3.20

# Windows 10
echo "Copying Windows 10"
cp -aR Win_10/assets ~/Github/Windows-10/gtk-3.20
cp -aR Win_10/gtk.css ~/Github/Windows-10/gtk-3.20
cp -aR Win_10/gtk-dark.css ~/Github/Windows-10/gtk-3.20
cp -aR Win_10/gtk-widgets.css ~/Github/Windows-10/gtk-3.20

#cp -aR Win_10/assets ~/Github/Windows-10-Dark/gtk-3.20
cp -aR Win_10/gtk-dark.css ~/Github/Windows-10-Dark/gtk-3.20/gtk.css
cp -aR Win_10/gtk-widgets.css ~/Github/Windows-10-Dark/gtk-3.20

# OS X Yosemite
echo "Copying OS X Yosemite"
cp -aR OS_X_10.10/assets ~/Github/OS-X-Yosemite/gtk-3.20
cp -aR OS_X_10.10/gtk.css ~/Github/OS-X-Yosemite/gtk-3.20
cp -aR OS_X_10.10/gtk-dark.css ~/Github/OS-X-Yosemite/gtk-3.20
cp -aR OS_X_10.10/gtk-widgets.css ~/Github/OS-X-Yosemite/gtk-3.20
