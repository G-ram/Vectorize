#ifndef __SRM_H__
#define __SRM_H__

#include <string>
#include <cuda.h>
#include "struct.h"

void srm2(region* regions, edge* pairs,int numOfPixels);
__host__ __device__ int max3(int x,int y, int z);
__global__ void srm1(region* region, edge* pairs, int w, int numOfPixels);
bool mergeTest(region A, region B,region* regions,int size);
#endif

