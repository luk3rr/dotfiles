#!/usr/bin/env python3

'''
 ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌      ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌          ▐░▌     ▐░▌       ▐░▌     ▐░▌     ▐░▌
▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌          ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌          ▐░▌     ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌          ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌          ▐░▌     ▐░▌       ▐░▌     ▐░▌               ▐░▌
▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌          ▐░▌     ▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄  ▄▄▄▄▄▄▄▄▄█░▌
▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
 ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀            ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀

AUTHOR: luk3rr
GITHUB: @luk3rr

A script that rename files with md5 hash. You must pass the directory where the files to be renamed are located.
This script is recursive, that is, it will perfom the operation on all subdiretories

DISCLAIMER: This script checks if there collision by the name file.
            If you have already run it on a folder and run it again, it will find that all files are collisions,
            that is, put the tag 'COLLISION=n' at the end of the filename. If that happens, run it one more time to
            get everything back to normal.

Depends on: hashlib, PyExifTool
'''

# --------------------------------------------------------------------------------------------------

from hashlib import md5
from os.path import exists, splitext
from os import rename
from glob import glob
from os import rename, path
from time import time
import exiftool
from exiftool.exceptions import ExifToolExecuteError, ExifToolOutputEmptyError

def get_file_data(path):
    with exiftool.ExifToolHelper() as at:
        item = at.get_tags(path, tags=["Directory", "FileModifyDate"])
        source = item[0]["SourceFile"]
        date = item[0]["File:FileModifyDate"]
        date = date.replace(":", "")
        return date.split(' ')[0], source

def main():
    countCollisionItems = 0
    pathWork = str(input(">> PATH: "))

    if pathWork[-1] != "/":
        pathWork += "/"

    files = [f for f in glob(pathWork + "**/*", recursive=True)]
    print(">> {} files found.".format(len(files)), end="\n")
    print("\n>> Loading...", end="\n")
    startTime = time()

    for currentItem in files:
        try:
            meta = get_file_data(currentItem)
            get_file_data(currentItem)

        except (ExifToolOutputEmptyError, ExifToolExecuteError):
            continue

        try:
            with open(currentItem, 'rb') as fil:
                hashed = md5(fil.read()).hexdigest()

        except IsADirectoryError:
            continue

        fileExtension = splitext(currentItem)[1]
        if not fileExtension:
            print(">> File without extension")
            print("\tITEM:     ", currentItem)
            print("\tSKIP ITEM...", end="\n\n")
            continue

        newName = path.dirname(meta[1]) + "/" + meta[0] + "-" + hashed[:15] + fileExtension

        # check collision
        if exists(newName):
            duplicateFile = path.dirname(meta[1]) + "/" + meta[0] + "-" + hashed[:15] + "-COLLISION=" + str(countCollisionItems) + fileExtension
            rename(currentItem, duplicateFile)
            countCollisionItems += 1

            print("\n>> Collision detected")
            print("\tITEM:     ", newName)
            print("\tCOLLIDER: ", currentItem, end="\n\n")

        else:
            rename(currentItem, newName)
            print("- ITEM:     ", currentItem)
            print("  NEW NAME: ", newName, end="\n\n")

    print("\n>> End script.\n>> Possible duplicate files: {}\n>> Elapsed time: {} s".format(countCollisionItems, round(time() - startTime, 2)))

if __name__ == "__main__":
    main()
