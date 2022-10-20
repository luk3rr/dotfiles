#!/usr/bin/env python3

''' rename files with md5 hash '''

''' you must pass the directory where the files to be renamed are located. This script is recursive,
    that is, it will perfom the operation on all subdiretories '''

# --------------------------------------------------------------------------------------------------

from hashlib import md5
from glob import glob
from os import rename, path
from time import time
import exiftool

def get_date_taken(path):
    with exiftool.ExifToolHelper() as at:
        item = at.get_tags(path, tags=["Directory", "FileModifyDate"])
        source = item[0]["SourceFile"]
        dat = item[0]["File:FileModifyDate"]
        dat = dat.replace(":", "")
        return dat.split(' ')[0], source

def main():
    dirt = str(input(">> "))
    if dirt[-1] != "/":
        dirt += "/"

    files = [f for f in glob(dirt + "**/*", recursive=True)]
    print(">> {} files located.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")
    start_Time = time()

    for i in files:
        meta = get_date_taken(i)
        print(meta)
        get_date_taken(i)
        try:
            with open(i, 'rb') as fil:
                hashed = md5(fil.read()).hexdigest()
        except IsADirectoryError:
            continue

        ext = i.rsplit('.')[-1]
        rename(i, path.dirname(meta[1]) + "/" + meta[0] + "-" + hashed[:15] + "." + ext)

    print("\n>> end script.\n>> duraction: {}".format(time() - start_Time))

if __name__ == "__main__":
    main()
