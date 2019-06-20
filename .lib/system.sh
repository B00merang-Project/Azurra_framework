#!/bin/bash

get_full_username() {
  getent passwd | grep "$USER" | cut -d":" -f5 | cut -d"," -f1
}
