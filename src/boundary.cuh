#ifndef __BOUNDARY_CUH__
#define __BOUNDARY_CUH__

#include <thrust/device_vector.h>
#include "opencv2/imgproc/imgproc.hpp"
#include "struct.h"
#include "video.h"

thrust::device_vector<bool>
genSubpixelEdges(thrust::device_vector<unsigned int> segmentedImages,
    int imageHeight, int imageWidth);

cv::Mat
convertEdges(thrust::device_vector<bool> edges, int height, int width);

int
testBoundary();

#endif
