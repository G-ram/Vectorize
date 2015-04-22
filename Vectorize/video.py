import cv2

class Video:
    def __init__(self, file_path):
        self.video = cv2.VideoCapture(file_path)
        self.frame_count = 0

    def __iter__(self):
        return self

    def next(self):
        success, frame = self.video.read()
        if success:
            self.frame_count += 1
            return frame
        else:
            raise StopIteration
