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
 ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀            ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀

AUTHOR: luk3rr
GITHUB: @luk3rr

A script that rename files with md5 hash. You must pass the directory where the files to be renamed are located.
This script is recursive, that is, it will perfom the operation on all subdiretories

DISCLAIMER: This script checks if there collision by the name file.
            If you have already run it on a folder and run it again, it will find that all files are collisions,
            that is, put the tag 'COLLISION=n' at the end of the name. If that happens, run it one more time to
            get everything back to normal.

Depends on: hashlib, PyExifTool
'''

# --------------------------------------------------------------------------------------------------

from hashlib import md5
from os.path import exists
from os import rename
from glob import glob
from os import rename, path
from time import time
import exiftool
from exiftool.exceptions import ExifToolExecuteError, ExifToolOutputEmptyError

def get_date_taken(path):
    with exiftool.ExifToolHelper() as at:
        item = at.get_tags(path, tags=["Directory", "FileModifyDate"])
        source = item[0]["SourceFile"]
        dat = item[0]["File:FileModifyDate"]
        dat = dat.replace(":", "")
        return dat.split(' ')[0], source

def main():
    countCollisionItems = 0
    dirt = str(input(">> PATH: "))

    if dirt[-1] != "/":
        dirt += "/"

    files = [f for f in glob(dirt + "**/*", recursive=True)]
    print(">> {} files found.".format(len(files)), end="\n")
    print("\n>> Loading...", end="\n")
    start_time = time()

    for i in files:

        try:
            meta = get_date_taken(i)
            get_date_taken(i)

        except (ExifToolOutputEmptyError, ExifToolExecuteError):
            continue

        try:
            with open(i, 'rb') as fil:
                hashed = md5(fil.read()).hexdigest()

        except IsADirectoryError:
            continue

        ext = i.rsplit('.')[-1]
        newName = path.dirname(meta[1]) + "/" + meta[0] + "-" + hashed[:15] + "." + ext

        # check collision
        if exists(newName):
            duplicateFile = path.dirname(meta[1]) + "/" + meta[0] + "-" + hashed[:15] + "-COLLISION=" + str(countCollisionItems) + "." + ext
            rename(i, duplicateFile)
            countCollisionItems += 1

            print("\n>> Collision detected")
            print("\tITEM:     ", newName)
            print("\tCOLLIDER: ", i, end="\n\n")

        else:
            rename(i, newName)
            print("- ITEM:     ", i)
            print("  NEW NAME: ", newName, end="\n\n")

    print("\n>> End script.\n>> Possible duplicate files: {}\n>> Elapsed time: {} s".format(countCollisionItems, round(time() - start_time, 2)))

if __name__ == "__main__":
    main()
