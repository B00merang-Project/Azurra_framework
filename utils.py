#!/usr/bin/python3

# Azurra Utils, a management script to create, edit and manage Azurra-based themes
# Author: Christian Medel <cmedelahumada@gmail.com>
# This deprecates the previously used Bash scripts

import argparse, os, sys

# Program constants
from typing import Any
import os.path

VERSION = 0.3
ROOT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))

FILTER_MODE_MATCH = 0
FILTER_MODE_RESTRICT = 1

# Console colors
class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def main():
    if sys.version_info[0] != 3 and sys.version_info[1] < 7:
        print(colors.FAIL + 'This script requires Python 3.7 or newer' + colors.ENDC)
        exit(1)

    parser = argparse.ArgumentParser(description="Azurra Utils, a management script for the Azurra framework")
    ops = parser.add_mutually_exclusive_group()
    optargs = parser.add_mutually_exclusive_group()

    # operational arguments
    ops.add_argument("-p", "--parents", type=str, help='Shows external dependencies for <TARGET> theme')
    ops.add_argument("-c", "--children", type=str, help='Shows themes depending on <TARGET> theme')
    ops.add_argument("-s", "--singletons", type=str, help='Shows unique widgets for <TARGET>')
    ops.add_argument("-n", "--new", type=str, help='Initiates new resource <NEW>')
    ops.add_argument("-x", "--cross-dependency", type=str, help='Detect if theme is cross-dependent on any child')
    ops.add_argument("-i", "--info", type=str, help='Read <TARGET> configuration file')

    # optional arguments
    optargs.add_argument("-w", "--widget", type=str, help='Filter dependencies to <WIDGET>')
    optargs.add_argument("-b", "--base", type=str, default='Azurra',
                         help='Which resource the new resource should be base on (theme only)')
    parser.add_argument("-u", "--bundle", action='store_true', help='Signals to create a new bundle instead of theme')
    parser.add_argument("-g", "--ignore-base", action='store_true', help='Ignore entries for base theme (Azurra)')

    # pretty args
    parser.add_argument("-v", "--version", action='version', version='Azurra Utils, version 0.3 beta',
                        help='Shows script version and exists')
    args = parser.parse_args()
    
    if args.parents:
        parents(args.parents, args.widget, args.ignore_base)

    elif args.children:
        children(args.children, args.widget)

    elif args.singletons:
        singletons(args.singletons)
    
    elif args.cross_dependency:
        conflicts(args.cross_dependency, args.widget, args.ignore_base)

    elif args.new:
        new(args.new, args.base, args.bundle)

    elif args.info:
        info(args.info)

# Utility methods
def read_file(filename: str):
    try:
        with open(filename, "r") as file:
            imports = file.readlines()

        return imports
    except FileNotFoundError:
        print(colors.FAIL + f"Target '{target}' does not have a valid import file" + colors.ENDC)
        exit(2)


def read_imports(target: str):
    return read_file(f"{target}/_imports.scss")


def read_conf(folder):
    conf = read_file(f"{folder}/theme.conf")

    # ignore 1st line
    name = clean(conf[1]).strip("name=").strip('"')
    author = clean(conf[2]).strip("author=").strip('"')
    version = clean(conf[3]).strip("version=")

    # line 4 is empty
    target = clean(conf[5].strip("target_dir="))
    dark_target = clean(conf[6].strip("target_dir_dark="))
    light_target = clean(conf[7].strip("target_dir_light="))
    
    targets = [target, dark_target, light_target]
    
    return [name, author, version, targets]


def clean(input: str) -> str:
    string = input.strip("@import '")
    string = string.strip('../')
    string = string.strip("';")
    string = string.strip("\n")

    return string


def filter(list, filters, mode):
    matching = []

    for filter in filters:
        for item in list:
            if filter in item:
                matching += [item]

    if mode == FILTER_MODE_RESTRICT:
        return [x for x in list if x not in matching]
    else:
        return matching


# --- Processing ---

# Detect parents
def parents(target: str, widget: Any, ignore_base: bool):
    print(colors.OKBLUE + f"Getting parents for '{target}'" + colors.ENDC)
       
    returned = get_parents(target, ignore_base)
    
    display = returned[0]
    parents = returned[1]
    total_imports = returned[2]
    
    if widget:
        filters = [widget]
        display = filter(display, filters, FILTER_MODE_MATCH)
    
    if ignore_base:
        filters = ['Azurra']
        display = filter(display, filters, FILTER_MODE_RESTRICT)

    parent_imports = len(display)

    for line in display:
        print(line)

    if parent_imports > 0:
        print(colors.OKGREEN + f"Found {parent_imports} parent imports over {total_imports} imports" + colors.ENDC)
    else:
        print(colors.FAIL + f"Found {parent_imports} parent imports over {total_imports} imports" + colors.ENDC)


def get_parents(target: str, ignore_base: bool):
    console = []
    parent_names = []

    lines = read_imports(target)

    for line in lines:
        if "'widgets/" not in line:
            line = line.rstrip()
            clean_line = clean(line)

            console += [clean_line]
            
            name = line.split('/')[-3]
            
            if name not in parent_names:
                parent_names.append(name)
    
    return [console, parent_names, len(lines)]


# find children
def children(target: str, widget: Any):
    print(colors.OKBLUE + f"Children for '{target}'" + colors.ENDC)
    
    resultset = get_children(target)
    
    display = resultset[0]
    children_count = resultset[1]
    names = resultset[2]
    
    if widget:
        filters = [widget]
        display = filter(display, filters, FILTER_MODE_MATCH)
    
    # display
    for item in display:
        print(item)
    
    children_imports = len(display)

    if children_imports > 0:
        print(colors.OKBLUE + f"Found {children_imports} children over {children_count} child themes" + colors.ENDC)
    else:
        print(colors.FAIL + f"Found {children_imports} children over {children_count} child themes" + colors.ENDC)


def get_children(target: str):
    console = []
    child_count = 0
    child_names = []

    resources = get_subdirs(ROOT_DIRECTORY)
    for theme in resources:
        if os.path.isfile(f"{ROOT_DIRECTORY}/{theme}/theme.conf"):
            display = get_children_for(theme, target)
            
            if len(display) > 0:
                child_count += 1
                child_names += [theme]
                
                console.extend(display)

        for bundle in get_subdirs(f"{ROOT_DIRECTORY}/{theme}"):
            if os.path.isfile(f"{ROOT_DIRECTORY}/{theme}/bundle.conf"):
                display = get_children_for(f"{theme}/{bundle}", target)
            
                if len(display) > 0:
                    child_count += 1
                    child_names += [bundle]
                    
                    console.extend(display)

    return [console, child_count, child_names]


def get_children_for(theme, target):
    returned = get_parents(theme, False)

    imports = returned[0]
    
    filters = [target]
    imports = filter(imports, filters, FILTER_MODE_MATCH)
    
    resultset = []
    display = []

    for line in imports:
        theme = theme.split('/')[-1]
        
        widget = line.split('/')[-1]
        display.append(f"[{theme}] {widget}")

    return display


def get_subdirs(source: str):
    return sorted([name for name in os.listdir(source) if
            os.path.isdir(os.path.join(source, name)) and not name.startswith('.')])


# find singleton widgets
def singletons(target: str):
    print(colors.OKBLUE + f"Unique widgets for '{target}'" + colors.ENDC)
    display = get_singletons(target)

    for line in display:
        print(line)

    if len(display) > 0:
        print(colors.OKGREEN + f"Found {len(display)} unique widgets for theme {target}" + colors.ENDC)
    else:
        print(colors.FAIL + f"Found no unique widgets for theme {target}" + colors.ENDC)


def get_singletons(target):
    console = []
    lines = read_imports(target)

    for line in lines:
        if "'widgets/" in line:
            line = line.rstrip()
            line = clean(line)

            console += [line.split('/')[-1]]

    return console


# create new resources
def new(target: str, source: str, bundle: bool):
    print(f"Creating new resource '{target}' based on '{source}'")

    if bundle: 
        print("Initializing new bundle")


# detect cross-dependencies
def conflicts(target: str, widget: Any, ignore_base: bool):
    parents = get_parents(target, ignore_base)[1]
    
    # child search requires last part in file path (ex. needs only 'dark' in 'B00merang/dark')
    target = clean_target(target)
    
    children = get_children(target)[2]
    
    found = False
    
    for parent in parents:
        if parent in children:
            print(colors.FAIL + f"CRITICAL: {parent} is also a child!" + colors.ENDC)
            found = True

    if not found:
        print(colors.OKBLUE + "No cross-dependencies found"+  colors.ENDC)


def clean_target(target: str):
    if target.endswith("/"):    # remove trailing slash
        target = target.split('/')[-2]
    
    if '/' in target:
        target = target.split('/')[-1]

    return target


# Theme configuration file
def info(target: str):
    conf = read_conf(target)
    
    print(f"Theme name: {conf[0]}")
    print(f"Author: {conf[1]}")
    print(f"Version: {conf[2]}\n")
    
    print(f"Target directory: {conf[3][0]}")
    print(f"Dark variant target directory: {conf[3][1]}")
    print(f"Light variant target directory: {conf[3][2]}")

if __name__ == "__main__": main()
