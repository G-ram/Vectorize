#ifndef __STRUCT_H__
#define __STRUCT_H__
typedef struct Pixel{
	int r;
	int g;
	int b;
	int i;
}pixel;
typedef struct Region{
	bool head;
	struct Region* child;
	pixel rootPixel;
	int numOfPixels;
	float avgR;
	float avgG;
	float avgB;
}region;
typedef struct EdgePair{
	region r1;
	region r2;
	int mag;
} edge;
#endif

