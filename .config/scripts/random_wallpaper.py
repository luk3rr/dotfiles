#!/usr/bin/env python3

'''
██████╗ ██╗    ██╗ █████╗ ██╗     ██╗
██╔══██╗██║    ██║██╔══██╗██║     ██║
██████╔╝██║ █╗ ██║███████║██║     ██║
██╔══██╗██║███╗██║██╔══██║██║     ██║
██║  ██║╚███╔███╔╝██║  ██║███████╗███████╗
╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝

AUTHOR: luk3rr
GITHUB: @luk3rr

this script makes a list and sets wallpapers by size.
e.g. -> ./random_wallpaper.py --select_wallpaper 1920x1080
make sure you have an environment variable 'wallpapers_dir' with the path of the wallpapers

Depends on: feh, python Pillow
'''

# -----------------------------------------------------------------------------------------------------------------------

#from pathlib import Path
from sys import argv, exit
from os import getenv, system
from random import choice
from PIL import Image
from glob import glob as scan
from time import time

RATIO_TOLERANCE = 0.3

def make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio):
    files = [f for f in scan(wallpapers_dir + "**/*.*", recursive=True)]

    print(">> {} files found.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")

    start_time = time()

    try:
        wallpaper_list = open(list_path + "/.wallpaper-list_" + str(screen_width) + "x" + str(screen_height) + ".txt", 'w+')

    except IOError:
        print(">> Could not read file")
        exit()

    print("\n>> List created in {}".format(list_path))

    for f in files:
        photo = Image.open(f)
        width, height = photo.size
        ratio = width/height

        if width >= screen_width and height >= screen_height:
            if ratio >= screen_ratio - RATIO_TOLERANCE:
                wallpaper_list.write(f + '\n')

    wallpaper_list.close()
    print("\n>> End function.\n>> Elapsed time: {}".format(time() - start_time))

def select_wallpaper(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio):
    try:
        wallpaper_list = open(list_path + "/.wallpaper-list_" + str(screen_width) + "x" + str(screen_height) + ".txt").read().splitlines()

    except IOError:
        print(">> List do not exists. Creating...\n")
        make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)
        wallpaper_list = open(list_path + "/.wallpaper-list_" + str(screen_width) + "x" + str(screen_height) + ".txt").read().splitlines()

    line = choice(wallpaper_list)
    system("feh --bg-fill " + line)
    print(">> New background: " + line)

def main():
    wallpapers_dir = getenv('WALLPAPERS_DIR')
    if (wallpapers_dir == None):
        print(">> Environment variable do not exist")
        exit()

    #list_path = str(Path(wallpapers_dir).parents[0])
    list_path = wallpapers_dir

    screen_width = int(argv[2].split("x")[0])
    screen_height = int(argv[2].split("x")[1])
    screen_ratio = screen_width/screen_height

    if (argv[1] == "--make_list"):
        make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)

    elif (argv[1] == "--select_wallpaper"):
        select_wallpaper(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)

if __name__ == "__main__":
    main()
