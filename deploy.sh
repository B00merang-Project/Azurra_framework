#!/bin/bash

# build
for D in *; do
  if [ -d "${D}" ]; then
    echo "Building ${D}"

    cd "${D}"
    ./run.sh
    cd ..
  fi
done

# macOS
echo "Copying macOS"
#cp -aR macOS_10.14/assets ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk.css ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk-dark.css ~/Github/macOS/gtk-3.20
cp -aR macOS_10.14/gtk-widgets.css ~/Github/macOS/gtk-3.20

#cp -aR macOS_10.14/assets ~/Github/macOS-Dark/gtk-3.20
cp -aR macOS_10.14/gtk-dark.css ~/Github/macOS-Dark/gtk-3.20/gtk.css
cp -aR macOS_10.14/gtk-widgets.css ~/Github/macOS-Dark/gtk-3.20

# Windows 10
echo "Copying Windows 10"
#cp -aR Win_10/assets ~/Github/Windows-10/gtk-3.20
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

echo "Copying iOS"

#cp -aR iOS_12/assets ~/Github/iOS/gtk-3.20
cp -aR iOS_12/gtk.css ~/Github/iOS/gtk-3.20
#cp -aR iOS_12/gtk-dark.css ~/Github/iOS/gtk-3.20
cp -aR iOS_12/gtk-widgets.css ~/Github/iOS/gtk-3.20

echo "Copying Windows XP"
#cp -aR Win_XP_Luna/assets ~/Github/Windows-XP/Windows\ XP\ Luna/gtk-3.20
cp -aR Win_XP_Luna/gtk.css ~/Github/Windows-XP/Windows\ XP\ Luna/gtk-3.20
cp -aR Win_XP_Luna/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Luna/gtk-3.20

#cp -aR Win_XP_Olive/assets ~/Github/Windows-XP/Windows\ XP\ Homestead/gtk-3.20
cp -aR Win_XP_Olive/gtk.css ~/Github/Windows-XP/Windows\ XP\ Homestead/gtk-3.20
cp -aR Win_XP_Olive/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Homestead/gtk-3.20

#cp -aR Win_XP_Metal/assets ~/Github/Windows-XP/Windows\ XP\ Metallic/gtk-3.20
cp -aR Win_XP_Metal/gtk.css ~/Github/Windows-XP/Windows\ XP\ Metallic/gtk-3.20
cp -aR Win_XP_Metal/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Metallic/gtk-3.20

#cp -aR Win_XP_Royale/assets ~/Github/Windows-XP/Windows\ XP\ Royale/gtk-3.20
cp -aR Win_XP_Royale/gtk.css ~/Github/Windows-XP/Windows\ XP\ Royale/gtk-3.20
cp -aR Win_XP_Royale/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Royale/gtk-3.20

#cp -aR Win_XP_Royale_Dark/assets ~/Github/Windows-XP/Windows\ XP\ Royale\ Dark/gtk-3.20
cp -aR Win_XP_Royale_Dark/gtk.css ~/Github/Windows-XP/Windows\ XP\ Royale\ Dark/gtk-3.20
cp -aR Win_XP_Royale_Dark/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Royale\ Dark/gtk-3.20

#cp -aR Win_XP_Embedded/assets ~/Github/Windows-XP/Windows\ XP\ Embedded/gtk-3.20
cp -aR Win_XP_Embedded/gtk.css ~/Github/Windows-XP/Windows\ XP\ Embedded/gtk-3.20
cp -aR Win_XP_Embedded/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Embedded/gtk-3.20

#cp -aR Win_XP_Zune/assets ~/Github/Windows-XP/Windows\ XP\ Zune/gtk-3.20
cp -aR Win_XP_Zune/gtk.css ~/Github/Windows-XP/Windows\ XP\ Zune/gtk-3.20
cp -aR Win_XP_Zune/gtk-widgets.css ~/Github/Windows-XP/Windows\ XP\ Zune/gtk-3.20

echo "Copying Solaris 11"
#cp -aR Solaris_11_Nimbus/assets ~/Github/Solaris-11/gtk-3.0
cp -aR Solaris_11_Nimbus/gtk.css ~/Github/Solaris-11/gtk-3.0
cp -aR Solaris_11_Nimbus/gtk-widgets.css ~/Github/Solaris-11/gtk-3.0

#cp -aR Solaris_11_Nimbus/assets ~/Github/Solaris-11-Light/gtk-3.0
cp -aR Solaris_11_Nimbus/gtk-light.css ~/Github/Solaris-11-Light/gtk-3.0/gtk.css
cp -aR Solaris_11_Nimbus/gtk-widgets.css ~/Github/Solaris-11-Light/gtk-3.0

#cp -aR Solaris_11_Nimbus/assets ~/Github/Solaris-11-Dark/gtk-3.0
cp -aR Solaris_11_Nimbus/gtk-dark.css ~/Github/Solaris-11-Dark/gtk-3.0/gtk.css
cp -aR Solaris_11_Nimbus/gtk-widgets.css ~/Github/Solaris-11-Dark/gtk-3.0
