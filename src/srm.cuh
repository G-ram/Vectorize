#ifndef __SRM_H__
#define __SRM_H__
#include <stdio.h>
#include <math.h>
#include <cuda.h>
#include <thrust/device_vector.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include <thrust/sequence.h>
#include <thrust/sort.h>
#include <thrust/transform.h>
#include <thrust/generate.h>
#include "struct.h"
struct region{
	unsigned int id;
	unsigned int numOfPixels;
	float avgR;
	float avgG;
	float avgB;
};
struct edge{
	unsigned int r1;
	unsigned int r2;
	int mag;
};
thrust::device_vector<unsigned int> SRM(frame* frame, int numOfFrames, int w, int h);
#endif

