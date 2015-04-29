#include <stdio.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "video.h"
#include "struct.h"
// #include "srm.cuh"

static const int FRAME_BATCH_SIZE = 100;

compactVideoRead
copyPictureDataToDev(frame *frames, pixel *pixels, unsigned int framesRead,
	unsigned int imageSize)
{
	int i;
	compactVideoRead devRead;
	CUDA_CALL_SETUP;
	pixel *devPixels;
	frame *devFrames;

	// Prints out the first pixel of each frame
	// cout << *pixels << "\n";

	CUDA_CALL(cudaMalloc((void**) &devPixels,
		sizeof(pixel) * framesRead * imageSize),
		"cudaMalloc failed - devPixels");

	CUDA_CALL(cudaMemcpy(devPixels, pixels,
		sizeof(pixel) * framesRead * imageSize, cudaMemcpyHostToDevice),
		"cudaMemcpy failed - devPixels");

	// Setup pointers to dev pixel data in frames
	// before copying to frames to dev
	for (i = 0; i < framesRead; i++) {
		frames[i].pixelData = devPixels + i * imageSize;
	}

	CUDA_CALL(cudaMalloc((void**) &devFrames,
		sizeof(frame) * framesRead),
		"cudaMalloc failed - devFrames");

	CUDA_CALL(cudaMemcpy(devFrames, frames,
		sizeof(frame) * framesRead, cudaMemcpyHostToDevice),
		"cudaMemcpy failed - devFrames");

	devRead.pixels = devPixels;
	devRead.frames = devFrames;

	return devRead;

Error:
	cudaFree(devPixels);
	cudaFree(devFrames);

	exit(1);
}

int main(int argc, char** argv ) {
	if(argc != 2) {
		printf("usage: <Video path>\n");
		return -1;
	}

	Video video = Video(argv[1]);

	cout << "Reading from video file: " << argv[1] << "\n";
	while(video.hasNext()) {
		unsigned int imageSize = video.getHeight() * video.getWidth();
		compactVideoRead read = video.readNFrames(FRAME_BATCH_SIZE);
		assert(read.framesRead > 0);
		cout << read.framesRead << " frames read \n";

		compactVideoRead devRead =
			copyPictureDataToDev(read.frames, read.pixels, read.framesRead,
				imageSize);

		assert(devRead.frames != NULL);
	}
	return 0;
}
