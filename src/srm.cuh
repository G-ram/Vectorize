#ifndef __SRM_H__
#define __SRM_H__

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "struct.h"

struct region{
	thrust::device_vector<pixel> pixels;
	int avgR;
	int avgG;
	int avgB;
}
struct edge{
	region r1;
	region r2;
	int mag;
}
regions SRM(thrust::device_vector<frame> frames);
#endif

