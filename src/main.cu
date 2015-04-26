#include <stdio.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "video.h"
#include "struct.h"
#include "srm.cuh"
int main(int argc, char** argv ){
	if(argc != 2){
		printf("usage: <Image_Path>\n");
		return -1;
	}
	Video video = Video(argv[1]);
	while(video.hasNext()){
		
	}
	return 0;
}

