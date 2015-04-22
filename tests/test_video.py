from Vectorize.video import Video

DATA_PATH = './tests/data/sample.mp4'

class TestVideo:
    def setup(self):
        self.vid = Video(DATA_PATH)

    def test_frame_get(self):
        self.vid.next()
        assert(True)
