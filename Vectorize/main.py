import numpy
import pyopencl
import os
import argparse

from video import Video
from processor import Processor

def main(file_path):
    video = Video(file_path)

    processor = Processor()
    processor.process(video)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Raster to SVG converter')
    parser.add_argument('file')
    args = parser.parse_args()

    if os.path.isfile(args.file):
        print "Processing: %s" % args.file
        main(args.file)
    else:
        print "file specified does not exist"
