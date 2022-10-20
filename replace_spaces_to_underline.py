#!/usr/bin/env python3

''' remove spaces and uppercase in file name '''

# ------------------------------------------------------

from glob import glob as scan
from os import rename as rn
from time import time

def main():
    dirt = str(input(">> "))
    if dirt[-1] != "/":
        dirt += "/"

    files = [f for f in scan(dirt + "**/*", recursive=True)]
    print(">> {} files located.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")
    start_Time = time()

    for i in files:
        newName = i.replace(" ", "_").lower()
        rn(i, newName)

    print("\n>> end script.\n>> duraction: {}".format(time() - start_Time))

if __name__ == "__main__":
    main()
