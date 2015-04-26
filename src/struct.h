#ifndef __STRUCT_H__
#define __STRUCT_H__

struct pixel {
	unsigned char r;
	unsigned char g;
	unsigned char b;
};

struct frame {
	pixel *pixelData; // vector of pixels of size height * width * 3
	int height;
	int width;
};

#endif
