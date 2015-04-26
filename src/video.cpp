#include "video.h"
Video::Video(const string aFilePath){
	filePath = aFilePath;
	cap = cv::VideoCapture(aFilePath);
	currentFrameCount = 0;
	w = cap.get(CV_CAP_PROP_FRAME_WIDTH);
	h = cap.get(CV_CAP_PROP_FRAME_HEIGHT);
}
uchar* Video::next(){
	cv::Mat frame;
	bool success = cap.read(frame); 
	if(!success){return NULL;}
	return frame.data;
}

