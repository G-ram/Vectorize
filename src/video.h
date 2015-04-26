#ifndef __VIDEO_H__
#define __VIDEO_H__
#include <string>
#include <opencv2/opencv.hpp>
#include <thrust/host_vector.h>
#include <memory>

#include "struct.h"

using namespace std;

class Video {
	string filePath;
	int w;
	int h;
	int currentFrameCount;
	cv::VideoCapture cap;
	cv::Mat currentFrame;
	public:
		Video(const string aFilePath);
		int getHeight() { return h; }
		int getWidth() { return w; }
		int getFrameCount() { return currentFrameCount; }
		bool hasNext();
		pixel *next();

		// Attempts to read frameCount frames
		thrust::host_vector<frame> readNFrames(int frameCount);
};
#endif
