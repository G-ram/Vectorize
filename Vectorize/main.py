import numpy
import pyopencl
import os
import argparse
from video import Video

def main(file_path):
    video = Video(file_path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Raster to SVG converter')
    parser.add_argument('file')
    args = parser.parse_args()
    print args.file
    if os.path.isfile(args.file) :
        main(args.file)
    else:
        print "file specified does not exist"