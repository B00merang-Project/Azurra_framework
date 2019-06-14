#!/bin/bash

sass -C --sourcemap=none _gtk-dark.scss gtk-dark.css

sass -C -q --sourcemap=none _common.scss gtk.css
