#!/usr/bin/env python3

''' organize image by size '''

# -------------------------------------------------

from PIL import Image
from glob import glob as scan
from shutil import copy2
import os
from time import time
import datetime

def main():

    geralda_dir = os.getenv('GERALDA_DIR')
    newton_dir = os.getenv('NEWTON_DIR')
    marilene_dir = os.getenv('MARILENE_DIR')
    all_dir = os.getenv('ALL_WALLPAPERS_DIR')

    if (geralda_dir == None or newton_dir == None or marilene_dir == None or all_dir == None):
        print(">> Environment variables do not exist")
        return 0

    geralda_width = 2560
    geralda_height = 1080

    newton_width = 1080
    newton_height = 2400

    marilene_width = 1920
    marilene_height = 1080

    if not os.path.exists(geralda_dir):
        os.makedirs(geralda_dir)
    if not os.path.exists(newton_dir):
        os.makedirs(newton_dir)

    files = [f for f in scan(all_dir + "**/*.*", recursive=True)]
    print(">> {} files located.".format(len(files)), end=" ")
    print("\n>> Loading...", end=" ")
    start_Time = time()
    
    log_nome = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log = open("log_" + log_nome + '.txt', 'w+')
    print("\n>> Log file created in {}/{}".format(os.getcwd(), log.name))

    for f in files:
        photo = Image.open(f)
        width, height = photo.size
        ratio = width/height

        if width >= geralda_width and height >= geralda_height:
            if ratio >= 2.3 and ratio <= 2.8:
                copy2(f, geralda_dir)
                log.write("{} copied to {}\n".format(f, geralda_dir))

        if width >= newton_width and height >= newton_height:
            if ratio >= 0.35 and ratio <= 0.7:
                copy2(f, newton_dir)
                log.write("{} copied to {}\n".format(f, geralda_dir))

        if width >= marilene_width and height >= marilene_height:
            if ratio >= 2.3 and ratio <= 2.8:
               copy2(f, marilene_dir)
               log.write("{} copied to {}\n".format(f, marilene_dir))

    print("\n>> end script.\n>> duraction: {}".format(time() - start_Time))

if __name__ == "__main__":
    main()
