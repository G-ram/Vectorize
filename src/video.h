#ifndef __VIDEO_H__
#define __VIDEO_H__
#include <string>
#include <opencv2/opencv.hpp>
#include <memory>

#include "struct.h"

struct compactVideoRead {
	frame *frames;
	pixel *pixels;
	unsigned int framesRead;
};

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
		void readPixels(pixel *storageLocation);

		// Attempts to read frameCount frames
		compactVideoRead readNFrames(int frameCount);
};
#endif
