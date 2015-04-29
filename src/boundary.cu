#include "boundary.cuh"

#define VALUE_AT(x, y)\
    segmentedImages[(y - 1) * imageWidth + (x - 1)]

#define EDGES_VALUE_AT(x, y)\
    edges[(y - 1) * imageWidth * 2 + (x - 1)]

static const int BLOCK_SIZE = 16;

void throw_on_cuda_error(const char *file, int line)
{
	cudaError_t lastError = cudaGetLastError();

  	if(lastError != cudaSuccess) {
		std::cout << file << "(" << line << ")" << " - " <<
			cudaGetErrorString(lastError) << "\n";
    	exit(1);
  	}
}

__device__ bool rangeCheck(int x, int y, int height, int width)
{
    if (x <= 0 || x > width) {
        return false;
    }

    if (y <= 0 || y > width) {
        return false;
    }

    return true;
}

__global__ void subpixelKernel(bool *edges, unsigned int *segmentedImages,
    int imageHeight, int imageWidth)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= imageWidth * 2) {
        return;
    }

    if (y >= imageHeight * 2) {
        return;
    }

    x++;
    y++;

    // x is odd and y is even
    if (x % 2 != 0 && y % 2 == 0) {
        if (
            rangeCheck((x + 1) / 2, y / 2, imageHeight, imageWidth) &&
            rangeCheck((x - 1) / 2, y / 2, imageHeight, imageWidth) &&
            VALUE_AT((x + 1) / 2, y / 2) !=
            VALUE_AT((x - 1) / 2, y / 2)
        ) {
            EDGES_VALUE_AT(x, y) = true;
        }
    }

    // x is even and y is odd
    if (x % 2 == 0 && y % 2 != 0) {
        if (
            rangeCheck(x / 2, (y + 1) / 2, imageHeight, imageWidth) &&
            rangeCheck(x / 2, (y - 1) / 2, imageHeight, imageWidth) &&
            VALUE_AT(x / 2, (y + 1) / 2) !=
            VALUE_AT(x / 2, (y - 1) / 2)
        ) {
            EDGES_VALUE_AT(x, y) = true;
        }
    }
}

__global__ void gapKernel(bool *edges, unsigned int *segmentedImages,
    int imageHeight, int imageWidth)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= imageWidth * 2) {
        return;
    }

    if (y >= imageHeight * 2) {
        return;
    }

    x++;
    y++;

    if (
        rangeCheck(x + 1, y, imageHeight * 2, imageWidth * 2) &&
        rangeCheck(x - 1, y, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x + 1, y) &&
        EDGES_VALUE_AT(x - 1, y)
    ) {
        EDGES_VALUE_AT(x, y) = true;
    }

    if (
        rangeCheck(x, y + 1, imageHeight * 2, imageWidth * 2) &&
        rangeCheck(x, y - 1, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x, y + 1) &&
        EDGES_VALUE_AT(x, y - 1)
    ) {
        EDGES_VALUE_AT(x, y) = true;
    }
}

__global__ void junctionKernel(bool *edges, unsigned int *segmentedImages,
    int imageHeight, int imageWidth)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= imageWidth) {
        return;
    }

    if (y >= imageHeight) {
        return;
    }

    x++;
    y++;

    int neighborCount = 0;

    if (rangeCheck(x + 1, y, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x + 1, y) == true) {
        neighborCount++;
    }
    if (rangeCheck(x - 1, y, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x - 1, y) == true) {
        neighborCount++;
    }
    if (rangeCheck(x, y + 1, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x, y + 1) == true) {
        neighborCount++;
    }
    if (rangeCheck(x, y - 1, imageHeight * 2, imageWidth * 2) &&
        EDGES_VALUE_AT(x, y - 1) == true) {
        neighborCount++;
    }

    if (neighborCount > 2) {
        EDGES_VALUE_AT(x, y) = true;
    }
}

thrust::device_vector<bool>
genSubpixelEdges(thrust::device_vector<unsigned int> segmentedImages,
    int imageHeight, int imageWidth)
{
    int imageSize = imageHeight * imageWidth;
    thrust::device_vector<bool> edges(imageSize * 4);

    dim3 threadsPerBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 numBlocks((imageWidth * 2 + BLOCK_SIZE - 1) / BLOCK_SIZE,
      (imageHeight * 2 + BLOCK_SIZE - 1) / BLOCK_SIZE);


    subpixelKernel<<<numBlocks, threadsPerBlock>>>(
        thrust::raw_pointer_cast(edges.data()),
        thrust::raw_pointer_cast(segmentedImages.data()),
        imageHeight,
        imageWidth
    );
    throw_on_cuda_error(__FILE__, __LINE__);

    gapKernel<<<numBlocks, threadsPerBlock>>>(
        thrust::raw_pointer_cast(edges.data()),
        thrust::raw_pointer_cast(segmentedImages.data()),
        imageHeight,
        imageWidth
    );
    throw_on_cuda_error(__FILE__, __LINE__);

    // junctionKernel<<<numBlocks, threadsPerBlock>>>(
    //     thrust::raw_pointer_cast(edges.data()),
    //     thrust::raw_pointer_cast(segmentedImages.data()),
    //     imageHeight,
    //     imageWidth
    // );
    throw_on_cuda_error(__FILE__, __LINE__);

    return edges;
}

int
testBoundary()
{
    int height = 5;
    int width = 5;

    unsigned int test[] = {
        1, 1, 1, 2, 2,
        1, 1, 3, 2, 2,
        1, 3, 3, 4, 2,
        3, 3, 4, 4, 4,
        3, 3, 4, 4, 4
    };
    thrust::device_vector<unsigned int> segmentedImages(test,
        test + height * width);

    thrust::host_vector<bool> edges =
        genSubpixelEdges(segmentedImages, height, width);

    for (int i = 0; i < edges.size(); i++) {
        std::cout << edges[i] << " ";
        if ((i + 1) % (width * 2) == 0) {
            std::cout << "\n";
        }
    }

    return 0;
}
