#!/usr/bin/env python3

# I use this script on Doom Emacs to open pdf associated

# ----------------------------------------------------------------------------------------------------------------------

from sys import argv
from os.path import isfile
import subprocess

# size of the block that will be read at a time
CHUNCKSIZE = 4096 # bytes

# if this string exists in my org file, then there is a pdf associated with it
SEARCH_STR = '#+export_file_name' 

# folder where PDFs are stored
OUTPUT_DIR = '~/Org/Roam/Outputs/' 

def main():
    orgFilePath = argv[1]

    # Check if file exists
    if isfile(orgFilePath):
        with open(orgFilePath, 'rb') as file:
            
            chunck = file.read(CHUNCKSIZE)

            while chunck:
                # decode and breaks the part of the file being read into lines
                strLine = chunck.decode('utf-8').splitlines()
                
                for line in strLine:
                    if SEARCH_STR in line:
                        # if SEARCH_STR exists in file, get the associated pdf name
                        pdfFilePath = OUTPUT_DIR + line.rsplit('/')[-1] + ".pdf"

                        # open pdf with zathura in background and break the loop
                        subprocess.Popen(["zathura", pdfFilePath])
                        break

                # read next block
                chunck = file.read(CHUNCKSIZE)

if __name__ == '__main__':
    main()
