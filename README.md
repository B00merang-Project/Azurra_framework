
![azurra-logo](https://raw.githubusercontent.com/B00merang-Project/Azurra_framework/assets/azurra_framework.png)

The Azurra Framework is a handy tool for creating and managing GTK themes.


**Author**: [Elbullazul](https://github.com/Elbullazul/)

**Current version**: 0.1-alpha

---

**Dependencies**
- `sassc`, or any other up-to-date SCSS parser
- `bash 4` or higher, required for the autogen script
- `python 3.6` or higher, for utils.py
- `imagemagick`, for asset rendering
- `optipng`, for PNG compression

---

## Getting started

Included files:
`Azurra`: Source theme you can use to create your own derivative. Find more base themes on the [b00merang Azurra repository](https://github.com/B00merang-Project/Azurra_framework)

`example`: This is a plain theme that mirrors the Azurra base theme. You can start by editing this empty example by adding/editing the colors and then importing the widgets you want to customize.

`autogen.sh`: This script runs the SASS compiler on the target theme and deploys the rendered file to the target specified in theme.conf. Run `./autogen.sh --help` for more details.

<br>

In the **example** theme, you can find the following folders:
- `assets`: This folder will be copied to the target directory once deployed. Place image and other resources here.

- `widgets`: You can copy a widget file from Azurra/widgets here and edit the SASS code to change the ruleset for that particular widget. You **have** to manually update the import line in `_imports.scss` to point to `widgets/<WIDGET>` instead.

<br>

And the following files:
- `_colors.scss`: The colors used in the rendering process. Edit them and start a generation to see changes.

- `_colors_public.scss`: This defines system color names that GNOME uses to render some applications. *Modifications to this file are discouraged.*

- `_common.scss`: This is where the theme structure is defined. It stores global settings and some rules about spacing and rarely used widgets. *Modifications to this file are discouraged.*

- `_functions.scss`: Contains functions to edit colors with GTK's CSS functions. *Modifications to this file are discouraged.*

- `imports.scss`: Points the SASS interpreter as to which files to read. If a file is placed in /widgets but the widget reference is not updated, it will not be included.

- `_vars.scss`: Contains variables reused in multiple widget source files.

- `gtk.scss`: The file that gets generated to gtk.css. Manages imports and sets various variables for conditional rules

- `gtk.css`: The CSS stylesheet that GNOME will read. You should run `./autogen.sh example` after any changes you have done before using it.

- `theme.conf`: Contains a theme's name, author and target directory. Dynamic versioning is coming in a future release.

---
More documentation and a tutorial are available on the [wiki](https://github.com/B00merang-Project/Azurra_framework/wiki)
