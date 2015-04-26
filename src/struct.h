#ifndef __STRUCT_H__
#define __STRUCT_H__

struct pixel {
	int r;
	int g;
	int b;
};

struct frame {
	thrust::device_vector<pixel>& data;
	int height;
	int width;
}

struct regions {
	thrust::device_vector<unsigned int>& regionNumbers;
	int height;
	int width;
};

struct edge {
	region r1;
	region r2;
	float mag;
};

#endif
