#!/bin/bash

#--- colors ---#

# embedded
sass -C --sourcemap=none embedded/_gtk.scss embedded/gtk.css

# luna
sass -C --sourcemap=none luna/_gtk.scss luna/gtk.css

# metal
sass -C --sourcemap=none metal/_gtk.scss metal/gtk.css

# olive
sass -C --sourcemap=none olive/_gtk.scss olive/gtk.css

# royale
sass -C --sourcemap=none royale/_gtk.scss royale/gtk.css

# royale dark
sass -C --sourcemap=none royale-dark/_gtk.scss royale-dark/gtk.css

# zune
sass -C --sourcemap=none zune/_gtk.scss zune/gtk.css

#--- GTK ---#
# embedded
sass -C --sourcemap=none embedded/_common.scss embedded/gtk-widgets.css

# luna
sass -C --sourcemap=none luna/_common.scss luna/gtk-widgets.css

# metal
sass -C --sourcemap=none metal/_common.scss metal/gtk-widgets.css

# olive
sass -C --sourcemap=none olive/_common.scss olive/gtk-widgets.css

# royale
sass -C --sourcemap=none royale/_common.scss royale/gtk-widgets.css

# royale dark
sass -C --sourcemap=none royale-dark/_common.scss royale-dark/gtk-widgets.css

# zune
sass -C --sourcemap=none zune/_common.scss zune/gtk-widgets.css
