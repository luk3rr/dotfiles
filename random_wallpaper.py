#!/usr/bin/env python3

''' this script makes a list or sets wallpapers by size 
    e.g. -> ./random_wallpaper.py --select_wallpaper 1920x1080
'''

# --------------------------------------------------------------------------------------------

from pathlib import Path
from sys import argv, exit
from os import getenv, system
from random import choice
from PIL import Image
from glob import glob as scan
from time import time

RATIO_TOLERANCE = 0.3

def make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio):
    files = [f for f in scan(wallpapers_dir + "**/*.*", recursive=True)]
    print(">> {} files located.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")
    start_Time = time()

    try:
        wallpaper_list = open(list_path + "/screen-list_" + str(screen_width) + "x" + str(screen_height) + ".txt", 'w+')

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
    print("\n>> End function.\n>> Duraction: {}".format(time() - start_Time))

def select_wallpaper(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio):
    try:
        wallpaper_list = open(list_path + "/screen-list_" + str(screen_width) + "x" + str(screen_height) + ".txt").read().splitlines()

    except IOError:
        print(">> List do not exists. Creating...\n")
        make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)
        wallpaper_list = open(list_path + "/screen-list_" + str(screen_width) + "x" + str(screen_height) + ".txt").read().splitlines()

    line = choice(wallpaper_list)
    system("feh --bg-scale " + line)
    print(">> New background: " + line)

def main():
    wallpapers_dir = getenv('WALLPAPERS_DIR')
    if (wallpapers_dir == None):
        print(">> Environment variable do not exist")
        exit()

    list_path = str(Path(wallpapers_dir).parents[0])

    screen_width = int(argv[2].split("x")[0])
    screen_height = int(argv[2].split("x")[1])
    screen_ratio = screen_width/screen_height

    if (argv[1] == "--make_list"):
        make_list(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)

    elif (argv[1] == "--select_wallpaper"):
        select_wallpaper(wallpapers_dir, list_path, screen_width, screen_height, screen_ratio)

if __name__ == "__main__":
    main()
