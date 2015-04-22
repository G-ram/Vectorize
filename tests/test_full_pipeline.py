from Vectorize.main import main

DATA_PATH = './tests/data/sample.mp4'

class TestFullPipeline:
    def test_main(self):
        assert(main(DATA_PATH) == None)
