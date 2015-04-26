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
	public:
		Video(const string aFilePath);
		int fh(){return h;}
		int fw(){return w;}
		int getFrameCount(){return currentFrameCount;}
		uchar* next();
};
#endif
