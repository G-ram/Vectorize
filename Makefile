PROGRAM_NAME := vectorize
NVCC = /usr/local/cuda-7.0/bin/nvcc

program_CXX_SRCS := $(wildcard src/*.cpp)
program_CXX_OBJS := ${program_CXX_SRCS:.cpp=.o}

program_CU_SRCS := $(wildcard src/*.cu)
#program_CU_HEADERS := $(wildcard src/*.cuh) #Optional: Include .cuh files as dependencies
program_CU_OBJS := ${program_CU_SRCS:.cu=.cuo}

program_INCLUDE_DIRS := . ./lib/opencv/include /usr/local/cuda/include/ #C++ Include directories

# Compiler flags
CFLAGS = `pkg-config --cflags opencv`
LIBS = `pkg-config --libs opencv`

CPPFLAGS += $(foreach includedir,$(program_INCLUDE_DIRS),-I$(includedir))
CPPFLAGS += $(CFLAGS) $(LIBS)
CXXFLAGS += -g -O3 -std=c++0x -Wall -pedantic $(CFLAGS) $(LIBS)

GEN_SM35 := -gencode=arch=compute_35,code=\"sm_35,compute_35\" #Target CC 3.5, for example
NVFLAGS := -O3 -rdc=true #rdc=true needed for separable compilation
NVFLAGS += $(GEN_SM35)
NVFLAGS += $(foreach includedir,$(program_CU_INCLUDE_DIRS),-I$(includedir))

CUO_O_OBJECTS := ${program_CU_OBJS:.cuo=.cuo.o}

OBJECTS = $(program_CU_OBJS) $(program_CXX_OBJS)

.PHONY: all clean distclean

all: $(PROGRAM_NAME)

debug: CXXFLAGS = -g -O0 -std=c++0x -Wall -pedantic -DDEBUG $(EXTRA_FLAGS)
debug: NVFLAGS = -O0 $(GEN_SM35) -g -G
debug: NVFLAGS += $(foreach includedir,$(program_CU_INCLUDE_DIRS),-I$(includedir))
debug: $(PROGRAM_NAME)

# Rule for compilation of CUDA source (C++ source can be handled automatically)
%.cuo: %.cu %.cuh
	$(NVCC) $(NVFLAGS) $(CPPFLAGS) -o $@ -dc $<

# This is pretty ugly...details below
# The program depends on both C++ and CUDA Objects, but storing CUDA objects as .o files results in circular dependency
# warnings from Make. However, nvcc requires that object files for linking end in the .o extension, else it will throw
# an error saying that it doesn't know how to handle the file. Using a non .o rule for Make and then renaming the file
# to have the .o extension for nvcc won't suffice because the program will depend on the non .o file but the files in
# the directory after compilation will have a .o suffix. Thus, when one goes to recompile the code all files will be
# recompiled instead of just the ones that have been updated.
#
# The solution below solves these issues by silently converting the non .o suffix needed by make to the .o suffix
# required by nvcc, calling nvcc, and then converting back to the non .o suffix for future, dependency-based
# compilation.
$(PROGRAM_NAME): $(OBJECTS)
	@ for cu_obj in $(program_CU_OBJS); \
	do				\
		mv $$cu_obj $$cu_obj.o; \
	done				#append a .o suffix for nvcc
	$(NVCC) $(NVFLAGS) $(CPPFLAGS) -o $@ $(program_CXX_OBJS) $(CUO_O_OBJECTS)
	@ for cu_obj in $(CUO_O_OBJECTS); 	\
	do					\
		mv $$cu_obj $${cu_obj%.*};	\
	done				#remove the .o for make

clean:
	@- $(RM) $(PROGRAM_NAME) $(OBJECTS) *~

distclean: clean
