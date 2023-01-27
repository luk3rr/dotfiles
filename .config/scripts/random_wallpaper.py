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

def make_list(wallpapers_dir, list_path, list_name, screen_width, screen_height, screen_ratio, ratio_tolerance):
    files = [f for f in scan(wallpapers_dir + "**/*.*", recursive=True)]

    print(">> {} files found.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")

    start_time = time()

    try:
        wallpaper_list = open(list_path + "/" + list_name, 'w+')

    except IOError:
        print(">> Could not read file")
        exit()

    print("\n>> List created in {}".format(list_path))

    for f in files:
        photo = Image.open(f)
        width, height = photo.size
        ratio = width/height

        if width >= screen_width and height >= screen_height:
            if ratio >= screen_ratio - ratio_tolerance:
                wallpaper_list.write(f + '\n')

    wallpaper_list.close()

    with open(list_path + "/" + list_name, 'r') as wallpaper_list:
        print("\n>> {} wallpapers candidates found.".format(len(wallpaper_list.readlines())))

    print("\n>> End function.\n>> Elapsed time: {}".format(time() - start_time))

def select_wallpaper(wallpapers_dir, list_path, list_name, screen_width, screen_height, screen_ratio, ratio_tolerance):
    try:
        wallpaper_list = open(list_path + "/" + list_name).read().splitlines()

    except IOError:
        print(">> List do not exists. Creating...\n")
        make_list(wallpapers_dir, list_path, list_name, screen_width, screen_height, screen_ratio, ratio_tolerance)
        wallpaper_list = open(list_path + "/" + list_name).read().splitlines()

    line = choice(wallpaper_list)
    system("feh --bg-fill " + line)
    print(">> New background: " + line)

def usage():
    print("USAGE: python3 random_wallpaper <ARG> <SIZE> [optional <FLOAT_RATIO_TOLERANCE>]\n")
    print("<SIZE>:")
    print("\t<WIDTH>x<HEIGHT>")
    print("\tExamples: 1920x1080, 2560x1080 \n")

    print("<FLOAT_RATIO_TOLERANCE>:")
    print("\tis how far you tolerate the wallpaper ratio being away from the screen ratio")
    print("\t<FLOAT_RATIO_TOLERANCE> is zero by default")
    print("\tRange: [0,1]")
    print("\tExample: 0.3\n")

    print("<ARGS>:")
    print("\t-m, --make_list")
    print("\tMakes a list with all wallpapers with size <SIZE>\n")
    print("\t-s, --select_wallpaper")
    print("\tSelect a wallpaper with size <SIZE>. Makes a list if it does not exist.")

def main():
    ratio_tolerance = 0
    wallpapers_dir = getenv('WALLPAPERS_DIR')
    if (wallpapers_dir == None):
        print(">> Environment variable do not exist")
        exit()
    try:
        screen_width = int(argv[2].split("x")[0])
        screen_height = int(argv[2].split("x")[1])
        if (screen_height == 0 or screen_width == 0): raise ZeroDivisionError
        screen_ratio = screen_width/screen_height

        if (len(argv) >= 4):
            if (argv[3] != ''):
                ratio_tolerance = float(argv[3])

                if ratio_tolerance > 1 or ratio_tolerance < 0:
                    raise ValueError("Ratio tolerance out of range")


        #list_path = str(Path(wallpapers_dir).parents[0])
        list_path = wallpapers_dir
        list_name = ".wallpaper-list_" + str(screen_width) + "x" + str(screen_height) + "_RT-" + str(ratio_tolerance*100).split('.')[0] + "pct.txt"

        if (argv[1] == "--make_list" or argv[1] == "-m"):
            make_list(wallpapers_dir, list_path, list_name, screen_width, screen_height, screen_ratio, ratio_tolerance)

        elif (argv[1] == "--select_wallpaper" or argv[1] == "-s"):
            select_wallpaper(wallpapers_dir, list_path, list_name, screen_width, screen_height, screen_ratio, ratio_tolerance)

        else:
            usage()

    except ValueError as err:
        print("ERROR:", err, '\n')
        usage()

    except IndexError:
        usage()

    except ZeroDivisionError:
        print("ERROR: width or height cannot be zero")

if __name__ == "__main__":
    main()
