import numpy
import pyopencl
import cv2
import os, sys
import argparse

def main(file_path):
	frames = []
	frame_count = 0
	flag = True
	cap = cv2.VideoCapture(file_path)
	while flag:
		flag, frame = cap.read()
		frames += [frame]
		frame_count += 1

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Raster to SVG converter')
	parser.add_argument('file')
	args = parser.parse_args()
	print args.file
	if os.path.isfile(args.file) :
		main(args.file)
	else:
		print "file specified does not exist"