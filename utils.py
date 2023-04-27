#!/usr/bin/python3

import os, argparse

SCRIPT_VERSION = 2.0
PARENT_DIR = '../'

### Handle exceptions in one place
def open_file(file_name: str):
    try:
        with open(file_name, "r") as file:
            file_lines = file.read().splitlines()

        return file_lines
    except FileNotFoundError:
        print(f"File '{file_name}' doesn't exist")
        exit

### Helper methods
def get_path(line: str):
    return line.strip("@import '").strip("';")

def get_parent(line: str):
    return get_path(line).split('/widgets/')[0].strip(PARENT_DIR)

def get_widget(line: str):
    return get_path(line).split('/widgets/')[1]

def read_imports(theme: str):
    return open_file(f"{theme}/_imports.scss")
    
def get_themes():
    CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))
    return sorted([name for name in os.listdir(CURRENT_DIR)
        if os.path.isdir(os.path.join(CURRENT_DIR, name)) and not name.startswith('.') and name != 'core'])

def is_child_of(theme: str, target: str):
    for line in read_imports(theme):
        if f"{target}/" in line:
            return True
    
    return False

### Find methods
def find_parents(theme: str):
    parents = []
    
    for line in read_imports(theme):
        if PARENT_DIR in line and get_parent(line) not in parents:
            parents += [get_parent(line)]
            print(get_parent(line))

def find_children(target: str):
    for theme in get_themes():
        if is_child_of(theme, target):
            print(theme)

def find_dependencies(theme: str):
    for line in read_imports(theme):
        if PARENT_DIR in line:
            print(f"{get_parent(line)}/{get_widget(line)}")

def find_dependents(target: str):
    for theme in get_themes():
        for line in read_imports(theme):
            if f"{target}/" in line:
                print(f"{theme}/{get_widget(line)}")

def find_conflicts():
    current_theme_children = []
    
    # building a list results in faster execution than by comparing each theme for each line at a time
    for current_theme in get_themes(): 
        for theme in [t for t in get_themes() if t != current_theme]:
            if is_child_of(theme, current_theme):
                current_theme_children += [theme]
        
        for line in read_imports(current_theme):
            for theme in current_theme_children:
                if theme in line:
                    print(f"{current_theme} depends on child {theme} for widget ({get_widget(line)})")

        current_theme_children = []
        
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--version", action='version', version=f"Azurra Utils, version {SCRIPT_VERSION}")
    ops = parser.add_mutually_exclusive_group()    
    ops.add_argument("-f", "--conflicts", action='store_true', help='detect circular dependencies')
    ops.add_argument("-p", "--parents", type=str, help='show parent themes for THEME', metavar="THEME")
    ops.add_argument("-c", "--children", type=str, help='show child themes for THEME', metavar="THEME")
    ops.add_argument("-d", "--dependencies", type=str, help='show widgets that THEME depends on', metavar="THEME")
    ops.add_argument("-n", "--dependents", type=str, help='show THEME widgets used by other themes', metavar="THEME")
    
    args = parser.parse_args()
    
    if args.parents:
        find_parents(args.parents)
    elif args.children:
        find_children(args.children)
    elif args.dependencies:
        find_dependencies(args.dependencies)
    elif args.dependents:
        find_dependents(args.dependents)
    elif args.conflicts:
        find_conflicts()
    else:
        print("Missing argument, try --help to see available commands")

if __name__ == "__main__": main()
