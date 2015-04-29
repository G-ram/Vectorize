#ifndef __BOUNDARY_CUH__
#define __BOUNDARY_CUH__

#include <thrust/device_vector.h>
#include "struct.h"
#include "video.h"

thrust::device_vector<bool>
genSubpixelEdges(thrust::device_vector<unsigned int> segmentedImages,
    int imageHeight, int imageWidth);

int
testBoundary();

#endif
