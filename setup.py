from distutils.core import setup

setup(
    name='Vectorize',
    version='0.1dev',
    packages=['vectorize'],
    license='Creative Commons Attribution-Noncommercial-Share Alike license',
    description='Creates vector representations of raster images'
    long_description=open('README').read(),
    install_requires=[],
    test_suite = 'nose.collector',
)
