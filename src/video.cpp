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

void Video::readPixels(pixel *storageLocation) {
	for (int y = 0; y < h; y++) {
		for (int x = 0; x < w; x++) {
			storageLocation[3 * y + x].b =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 0];
			storageLocation[3 * y + x].g =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 1];
			storageLocation[3 * y + x].r =
				currentFrame.data[currentFrame.channels()
					*(currentFrame.cols * y + x) + 2];
		}
	}
}

// The frames returned by this method will all point to the beginning of
// the pixel array
compactVideoRead Video::readNFrames(int frameCount) {
	int currentFrame = 0;
	unsigned int imageArea = w * h;

	frame *frames = new frame[frameCount];
	pixel *pixels = new pixel[frameCount * imageArea];

	while (currentFrame < frameCount && this->hasNext()) {
		this->readPixels(&pixels[currentFrame * imageArea]);

		frames[currentFrame].pixelData = pixels;
		frames[currentFrame].width = w;
		frames[currentFrame].height = h;

		currentFrame++;
	}

	compactVideoRead result;
	result.frames = frames;
	result.pixels = pixels;
	result.framesRead = currentFrame;

	return result;
}
