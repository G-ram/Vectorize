#ifndef __STRUCT_H__
#define __STRUCT_H__
struct pixel{
	int r;
	int g;
	int b;
	int i;
};
struct region{
	thrust::device_vector<pixel> pixels;
};
struct edge{
	region r1;
	region r2;
	float mag;
};
#endif

