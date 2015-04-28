#ifndef __STRUCT_H__
#define __STRUCT_H__

#define CUDA_CALL_SETUP cudaError_t cudaStatus;\
	bool hasErrored = false;

#define CUDA_CALL(call, error)\
  cudaStatus = call;\
  if (cudaStatus != cudaSuccess) {\
    fprintf(stderr, error);\
    fprintf(stderr, " - reason: %s\n", cudaGetErrorString(cudaStatus));\
    if (!hasErrored) {\
    	hasErrored = true;\
    	goto Error;\
    }\
  }

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
