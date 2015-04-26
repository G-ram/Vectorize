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

pixel *Video::next() {
	pixel *pixels = new pixel[w * h];

	for (int y = 0; y < h; y++) {
		for (int x = 0; x < w; x++) {
			pixels[3 * y + x].b =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 0];
			pixels[3 * y + x].g =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 1];
			pixels[3 * y + x].r =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 2];
		}
	}

	return pixels;
}

thrust::host_vector<frame> Video::readNFrames(int frameCount) {
	int i = 0;
	thrust::host_vector<frame> frames(frameCount);
	while (i < frameCount && this->hasNext()) {
		pixel *pixels = this->next();
		frames[i].pixelData = pixels;
		frames[i].width = w;
		frames[i].height = h;

		i++;
	}

	return frames;
}
