#ifndef __VIDEO_H__
#define __VIDEO_H__
#include <string>
#include <opencv2/opencv.hpp>
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
		cv::Mat getNext();

		// Attempts to read frameCount frames
		std::vector<cv::Mat> readNFrames(int frameCount);
};
#endif

