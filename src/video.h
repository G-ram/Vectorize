#ifndef __VIDEO_H__
#define __VIDEO_H__
#include <string>
#include <opencv2/opencv.hpp>
using namespace std;
class Video{
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
		uchar* next();
};
#endif