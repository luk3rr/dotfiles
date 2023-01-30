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
make sure you have an environment variable 'wallpapersDir' with the path of the wallpapers

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

def make_list(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance):
    files = [f for f in scan(wallpapersDir + "**/*.*", recursive=True)]

    print(">> {} files found.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")

    startTime = time()

    try:
        wallpaperList = open(listPath + "/" + listName, 'w+')

    except IOError:
        print(">> Could not read file")
        exit()

    print("\n>> List created in {}".format(listPath))

    for currentItem in files:
        photo = Image.open(currentItem)
        width, height = photo.size
        ratio = width/height

        if width >= screenWidth and height >= screenHeight:
            if ratio >= screenRatio - ratioTolerance:
                wallpaperList.write(currentItem + '\n')

    wallpaperList.close()

    with open(listPath + "/" + listName, 'r') as wallpaperList:
        print("\n>> {} wallpapers candidates found.".format(len(wallpaperList.readlines())))

    print("\n>> End function.\n>> Elapsed time: {}".format(time() - startTime))

def select_wallpaper(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance):
    try:
        wallpaperList = open(listPath + "/" + listName).read().splitlines()

    except IOError:
        print(">> List do not exists. Creating...\n")
        make_list(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)
        wallpaperList = open(listPath + "/" + listName).read().splitlines()

    newWallpaper = choice(wallpaperList)
    system("feh --bg-fill " + newWallpaper)
    print(">> New wallpaper: " + newWallpaper)

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
    ratioTolerance = 0
    wallpapersDir = getenv('WALLPAPERS_DIR')
    if (wallpapersDir == None):
        print(">> Environment variable do not exist")
        exit()
    try:
        screenWidth = int(argv[2].split("x")[0])
        screenHeight = int(argv[2].split("x")[1])
        if (screenHeight == 0 or screenWidth == 0): raise ZeroDivisionError("Width or height cannot be zero")
        screenRatio = screenWidth/screenHeight

        if (len(argv) >= 4):
            if (argv[3] != ''):
                ratioTolerance = float(argv[3])

                if ratioTolerance > 1 or ratioTolerance < 0:
                    raise ValueError("Ratio tolerance out of range")


        #listPath = str(Path(wallpapersDir).parents[0])
        listPath = wallpapersDir
        listName = ".wallpaper-list_" + str(screenWidth) + "x" + str(screenHeight) + "_RT-" + str(ratioTolerance*100).split('.')[0] + "pct.txt"

        if (argv[1] == "--make_list" or argv[1] == "-m"):
            make_list(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)

        elif (argv[1] == "--select_wallpaper" or argv[1] == "-s"):
            select_wallpaper(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)

        else:
            usage()

    except ValueError as errorMsg:
        print("ERROR:", errorMsg, '\n')
        usage()

    except IndexError:
        usage()

    except ZeroDivisionError as errorMsg:
        print("ERROR:", errorMsg, '\n')

if __name__ == "__main__":
    main()
