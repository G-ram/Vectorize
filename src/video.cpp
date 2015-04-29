#include "video.h"
#include "struct.h"
#include <thrust/host_vector.h>

Video::Video(const string aFilePath) {
	filePath = aFilePath;
	cap = cv::VideoCapture(aFilePath);
	currentFrameCount = 0;
	w = cap.get(CV_CAP_PROP_FRAME_WIDTH);
	h = cap.get(CV_CAP_PROP_FRAME_HEIGHT);
}

bool Video::hasNext() {
	return cap.read(currentFrame);
}

// Returns an array of opencv mat images representing frameCount number of frames
std::vector<cv::Mat> Video::readNFrames(int frameCount) {
	int currentFrameIdx = 0;
	std::vector<cv::Mat> result;

	while (currentFrameIdx < frameCount && this->hasNext()) {
		result.push_back(currentFrame);
		currentFrameIdx++;
	}

	return result;
}

