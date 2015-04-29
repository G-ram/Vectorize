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

inline std::ostream & operator<<(std::ostream &os, const pixel& p)
{
	os << "( " << ((int) p.r) << " , " << ((int) p.g)
		<< " , " << ((int) p.b) << " )";
	return os;
}

struct frame {
	pixel *pixelData; // vector of pixels of size height * width * 3
	int height;
	int width;
};

#endif
