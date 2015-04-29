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

#endif

