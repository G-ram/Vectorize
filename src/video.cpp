#include "video.h"
Video::Video(const string aFilePath){
	filePath = aFilePath;
	cap = cv::VideoCapture(aFilePath);
	currentFrameCount = 0;
	w = cap.get(CV_CAP_PROP_FRAME_WIDTH);
	h = cap.get(CV_CAP_PROP_FRAME_HEIGHT);
}
bool Video::hasNext(){
	return cap.read(currentFrame);
}
uchar* Video::next(){
	return currentFrame.data;
}

