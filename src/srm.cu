#include "srm.cuh"

#define Q 32

struct gen_regions: public thrust::unary_function<int,region>{
	frame *currentFrame;
	gen_regions(frame *_currentFrame){
		currentFrame = _currentFrame;
	}
	__device__ region operator()(const int& idx){
		region tempRegion;
		tempRegion.id = idx;
		tempRegion.numOfPixels = 1;
		tempRegion.avgR = (int)(*currentFrame).pixelData[idx].r;
		tempRegion.avgG = (int)(*currentFrame).pixelData[idx].g;
		tempRegion.avgG = (int)(*currentFrame).pixelData[idx].b;
		return tempRegion;
	}
};

struct gen_edges: public thrust::unary_function<int,edge>{
	frame *currentFrame;
	region *regions;
	unsigned int w;
	unsigned int h;
	unsigned int inc;
	gen_edges(frame *_currentFrame, region *_regions, unsigned int _w, unsigned int _h, unsigned int _inc){
		currentFrame = _currentFrame;
		regions = _regions;
		w = _w;
		h = _h;
		inc = _inc;
	}
	__device__ unsigned int max3(int x, int y, int z){
		unsigned int max = x >= y ? x : y;
		return max >= z ? max : z;
	}
	__device__ edge operator()(const int& idx){
		edge tempEdge;
		if(idx + inc < w*h){
			region r1 = regions[idx];
			region r2 = regions[idx+inc];
			tempEdge.r1 = idx;
			tempEdge.r2 = idx+inc;
			tempEdge.mag = max3(abs(r1.avgR-r2.avgR),abs(r1.avgG-r2.avgG),abs(r1.avgB-r2.avgB));
		}else{
			tempEdge.r1 = 0;
			tempEdge.r2 = 0;
			tempEdge.mag = -1.0;
		}

		return tempEdge;
	}
};

struct sort_edges{
	__device__ bool operator()(const edge& x, const edge& y){
		return x.mag < y.mag;
  	}
};

struct gen_labels: public thrust::unary_function<region,unsigned int>{
	gen_labels(){}
	__device__ unsigned int operator()(const region& currentRegion){
		return currentRegion.id;
	}
};

float max3(float x, float y, float z){
	float max = x >= y ? x : y;
	return max >= z ? max : z;
}

bool mergeTest(edge currentEdge,thrust::host_vector<region> regions, std::vector<unsigned int> sizes, float delta){
	region r1 = regions[currentEdge.r1];
	region r2 = regions[currentEdge.r2];
	unsigned int numRegionsWithPixels1 = sizes[r1.numOfPixels];
	unsigned int numRegionsWithPixels2 = sizes[r2.numOfPixels];
	float colorDiff = max3(fabs(r1.avgR-r2.avgR),fabs(r1.avgG-r2.avgG),fabs(r1.avgB-r2.avgB));
	float bR1 = (1/(2*Q*r1.numOfPixels))*log(numRegionsWithPixels1/delta);
	float bR2 = (1/(2*Q*r1.numOfPixels))*log(numRegionsWithPixels2/delta);
	return colorDiff <= sqrt(bR1+bR2);
}

thrust::device_vector<unsigned int> SRM(frame* frames, int numOfFrames, int w, int h){
	int size = w*h;
	float delta = 1/(6*size*size);
	thrust::device_vector<region> regions(size);
	thrust::device_vector<unsigned int> idxs(size);
	thrust::device_vector<edge> edges(2*size);
	thrust::device_vector<unsigned int> labels(numOfFrames*size);
	thrust::host_vector<region> hRegions(size);
	thrust::host_vector<edge> hEdges(2*size);
	std::vector<unsigned int> sizes(size+1);
	sizes[size] = size;
	thrust::sequence(idxs.begin(),idxs.end());
	int i,j,k;
	i = j = k = 0;
	for(j = 0; j < numOfFrames; j++){
		thrust::transform(idxs.begin(),idxs.end(),regions.begin(),gen_regions(frames+j));
		thrust::transform(idxs.begin(),idxs.end(),edges.begin(),gen_edges(frames+j,thrust::raw_pointer_cast(regions.data()),w,h,1));
		thrust::transform(idxs.begin(),idxs.end(),edges.begin()+size,gen_edges(frames+j,thrust::raw_pointer_cast(regions.data()),w,h,w));
		thrust::sort(edges.begin(),edges.end(),sort_edges());
		hRegions = regions;
		hEdges = edges;
		region r1, r2;
		unsigned int totalPixels;
		for(thrust::host_vector<edge>::iterator it = hEdges.begin(); it != hEdges.end(); it++){
			i++;
			if(mergeTest(hEdges[i],hRegions,sizes,delta)){ //merge O(n)
				r1 = hRegions[hEdges[i].r1];
				r2 = hRegions[hEdges[i].r2];
				totalPixels = r1.numOfPixels+r2.numOfPixels;
				sizes[totalPixels] += 1;
				sizes[r1.numOfPixels] -= 1;
				sizes[r2.numOfPixels] -= 1;
				r2.avgR = (r1.numOfPixels/totalPixels)*r1.avgR+(r2.numOfPixels/totalPixels)*r2.avgR;
				r2.avgG = (r1.numOfPixels/totalPixels)*r1.avgG+(r2.numOfPixels/totalPixels)*r2.avgB;
				r2.avgB = (r1.numOfPixels/totalPixels)*r1.avgB+(r2.numOfPixels/totalPixels)*r2.avgG;
				r2.numOfPixels = totalPixels;
				for(thrust::host_vector<region>::iterator ik = hRegions.begin(); ik != hRegions.end(); ik++){
					k++;
					if(hRegions[k].id == r1.id || hRegions[k].id == r2.id){
						hRegions[k] = r2;
					}
				}
			}
		}
		regions = hRegions;
		thrust::transform(regions.begin(),regions.end(),labels.begin()+j*size,gen_labels());
		thrust::transform(idxs.begin(),idxs.end(),regions.begin(),gen_regions(frames+j));
	}
	return labels;
}


