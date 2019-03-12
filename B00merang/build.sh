#!/bin/bash

#--- colors ---#

# flat
sass -C --sourcemap=none flat/_gtk.scss flat/gtk.css
sass -C --sourcemap=none flat/_gtk-light.scss flat/gtk-light.css
sass -C --sourcemap=none flat/_gtk-dark.scss flat/gtk-dark.css

#--- GTK ---#
# flat
sass -C --sourcemap=none flat/_common.scss flat/gtk-widgets.css
