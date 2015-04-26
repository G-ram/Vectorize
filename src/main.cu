#include <stdio.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "video.h"
#include "struct.h"
// #include "srm.cuh"

static const int FRAME_BATCH_SIZE = 100;

int main(int argc, char** argv ) {
	if(argc != 2) {
		printf("usage: <Video path>\n");
		return -1;
	}

	Video video = Video(argv[1]);
	cout << "Reading from video file: " << argv[1];
	while(video.hasNext()) {
		thrust::host_vector<frame> frames = video.readNFrames(FRAME_BATCH_SIZE);
		cout << frames.size() << "\n";
	}
	return 0;
}
