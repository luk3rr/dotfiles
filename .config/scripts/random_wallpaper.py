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
e.g. -> ./random_wallpaper.py change_wallpaper -s 1920x1080 -t 0.05
make sure you have an environment variable 'wallpapersDir' with the path of the wallpapers

Depends on: feh, python Pillow
'''

# -----------------------------------------------------------------------------------------------------------------------

from sys import exit
from os import getenv, system
from random import choice
from PIL import Image
from glob import glob as scan
from time import time
import argparse

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
            if ratio >= (screenRatio - screenRatio*ratioTolerance) and ratio <= (screenRatio + screenRatio*ratioTolerance):
                wallpaperList.write(currentItem + '\n')

    wallpaperList.close()

    with open(listPath + "/" + listName, 'r') as wallpaperList:
        print("\n>> {} wallpapers candidates found.".format(len(wallpaperList.readlines())))

    print("\n>> End function.\n>> Elapsed time: {}".format(time() - startTime))

def change_wallpaper(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance):
    try:
        wallpaperList = open(listPath + "/" + listName).read().splitlines()

    except IOError:
        print(">> List do not exists. Creating...\n")
        make_list(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)
        wallpaperList = open(listPath + "/" + listName).read().splitlines()

    newWallpaper = choice(wallpaperList)
    system("feh --bg-fill " + newWallpaper)
    print(">> New wallpaper: " + newWallpaper)

def main():
    ratioTolerance = 0
    wallpapersDir = getenv('WALLPAPERS_DIR')
    if (wallpapersDir == None):
        print(">> Environment variable do not exist")
        exit()

    FUNCTION_MAP = {'make_list' : make_list,
                    'change_wallpaper' : change_wallpaper }

    parser = argparse.ArgumentParser(description='this script makes a list and sets wallpapers by size.')

    parser.add_argument('functionName',
                        choices=FUNCTION_MAP.keys(),
                        help='select one of these functionNames to change program flow')

    parser.add_argument('-s',
                        required=True, 
                        type=str,
                        help='sizes that will be used to search for wallpapers. Exemple: -s 2560x1080',
                        dest='screenSize')

    parser.add_argument('-t',
                        type=float,
                        help='is how far you tolerate the wallpaper ratio being away from the screen ratio. Exemple: -t 0.05',
                        dest='ratioTolerance')

    args = parser.parse_args()

    func = FUNCTION_MAP[args.functionName]

    try:
        screenWidth = int(args.screenSize.split("x")[0])
        screenHeight = int(args.screenSize.split("x")[1])

        if (screenHeight == 0 or screenWidth == 0): raise ZeroDivisionError("Width or height cannot be zero")
        screenRatio = screenWidth/screenHeight

        if (args.ratioTolerance is not None):
            if args.ratioTolerance > 1 or args.ratioTolerance < 0:
                raise ValueError("Ratio tolerance out of range.\nRange: [0,1]")
        else:
            args.ratioTolerance = 0

        listPath = wallpapersDir
        listName = ".wallpaper-list_" + str(screenWidth) + "x" + str(screenHeight) + "_RT-" + str(args.ratioTolerance*100).split('.')[0] + "pct.txt"

        if args.functionName == 'make_list':
            func(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)
        elif args.functionName == 'change_wallpaper':
            func(wallpapersDir, listPath, listName, screenWidth, screenHeight, screenRatio, ratioTolerance)

    except ValueError as errorMsg:
        print("ERROR:", errorMsg, '\n')

    except (IndexError, AttributeError) as errorMsg:
        print("ERROR:", errorMsg, '\n')

    except ZeroDivisionError as errorMsg:
        print("ERROR:", errorMsg, '\n')

if __name__ == "__main__":
    main()
