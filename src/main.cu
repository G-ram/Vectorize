#include <stdio.h>
#include <iostream>
#include <thrust/device_vector.h>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "SRMSeg.h"
#include "video.h"
#include "struct.h"
#include "boundary.cuh"

static const int FRAME_BATCH_SIZE = 10;
static const int Q = 45;
static const int MIN_SIZE = 10;

int main(int argc, char** argv ) {
	if(argc != 2) {
		printf("usage: <Video path>\n");
		return -1;
	}

	// testBoundary();

	Video video = Video(argv[1]);
	cout << "Reading from video file: " << argv[1] << "\n";

	unsigned int i = 0;
	unsigned int width = video.getWidth();
	unsigned int height = video.getHeight();
	SRMSeg srm(width,height);
	std::vector<cv::Mat> labels(FRAME_BATCH_SIZE);
	std::vector<unsigned int> hRegionFrame(width*height);
	std::vector<unsigned int> hRegions;
	while(video.hasNext()) {
		cout << "---- reading another "<< FRAME_BATCH_SIZE << " frames ---- \n";
		std::vector<cv::Mat> frames = video.readNFrames(FRAME_BATCH_SIZE);
		for(i = 0; i < frames.size(); i++){
			srm.segment(frames[i],Q,MIN_SIZE);
			srm.getLabels(labels[i]);
			cout << "frame " << i << " has "<< srm.getNumComps() << " components" << endl;
			hRegionFrame.assign((unsigned int*)labels[i].datastart, (unsigned int*)labels[i].dataend);
			hRegions.insert(hRegions.end(), hRegionFrame.begin(), hRegionFrame.end());
		}
		thrust::device_vector<unsigned int> regions(hRegions);
	}
	return 0;
}
