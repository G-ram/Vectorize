#include <stdio.h>
#include "video.h"
#include "struct.h"
#include "srm.cuh"
__global__ void setup(uchar* rawPixels, region* regions, int w, int h){
	int x = blockDim.x*blockIdx.x+threadIdx.x;
	int y = blockDim.y*blockIdx.y+threadIdx.y;
	int i = 3*w*y+3*x;
	int ip = w*y+x;
	if(x >= w || y >= h){return;}
	int b = (int)rawPixels[i];
	int g = (int)rawPixels[i+1];
	int r = (int)rawPixels[i+2];
	pixel tempPixel = {i,r,g,b};
	region tempRegion = {true,NULL,tempPixel,1,r,g,b};
	regions[ip] = tempRegion;
}
int main(int argc, char** argv ){
	if(argc != 2){
		printf("usage: <Image_Path>\n");
		return -1;
	}
	Video video = Video(argv[1]);
	while(video.next() != NULL){

	}
	return 0;
}

