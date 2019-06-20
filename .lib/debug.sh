#!/bin/bash

breakpoint() {
  read -p "Breakpoint at $(basename $0), line $BASH_LINENO. Continue? " var
}
