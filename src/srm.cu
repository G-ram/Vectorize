#include "srm.cuh"

#define Q 32

struct edge_functor(){
	region currentRegion;
	edge_functor(){}
	__host__ __device__
	edge operator()(const frame& frame, int idx){
		return ;
	}
}
struct sort_edges{
	__host__ __device__
	bool operator()(const edge& e1, const edge& e2) {
		return e1.mag < e2.mag;
	}
}
regions SRM(thrust::device_vector<frame> frames){
	int i;
	thrust::host_vector<thrust::raw_pointer<edge>> hEdges(frames.size());
	for(i = 0; i < frames.size(); i++){
		hEdges = thrust::raw_pointer_cast(new thrust::device_vector<edge>(2*frames[0].w*frames[0]).data();
	}
	thrust::device_vector<thrust::raw_pointer<edge>> dEdges = hEdges;
	thrust::transform(frames.begin(),frames.end(),dEdges.begin,dEdges.end(),edge_functor);
	
	for(i = 0; i < frames.size(); i++){
		thrust.sort(dEdges.begin(),dEdges.end(),
	}
}
/*__global__ void srm1(region* regions, edge* pairs, int w, int numOfPixels){
	int x = blockDim.x*blockIdx.x+threadIdx.x;
	int y = blockDim.y*blockIdx.y+threadIdx.y;
	int i = w*y+x;
	if(i >= numOfPixels){return;}
	pixel currentPixel = regions[i].rootPixel;
	pixel eastPixel;
	pixel southPixel;
	if(i+1 < numOfPixels){
		eastPixel = regions[i+1].rootPixel;
		int magEast = max3(abs(currentPixel.r-eastPixel.r),
					abs(currentPixel.g-eastPixel.g),
					abs(currentPixel.b-eastPixel.b));
		edge tempEdge = {regions[i],regions[i+1],magEast};
		pairs[2*i] =  tempEdge;
	}
	if(i+w < numOfPixels){
		southPixel = regions[i+w].rootPixel;
		int magSouth = max3(abs(currentPixel.r-southPixel.r),
					abs(currentPixel.g-southPixel.g),
					abs(currentPixel.b-southPixel.b));
		edge tempSouth = {regions[i],regions[i+w],magSouth};
		pairs[2*i+1] = tempSouth;
	}
	__syncthreads();
	int j = 0;
	i *= 2;
	//Some form of bubble sort
	for(j = 0;j < numOfPixels;j++){
		if(j%2 == 0){
			if(pairs[i].mag > pairs[i+1].mag){
				edge tempEdge = pairs[i];
				pairs[i] = pairs[i+1];
				pairs[i+1] = tempEdge;
			}
		}else if(i+1 < 2*numOfPixels-1){
			if(pairs[i+1].mag > pairs[i+2].mag){
				edge tempEdge = pairs[i+1];
				pairs[i] = tempEdge;
			}
		}
		__syncthreads();
	}
}

bool mergeTest(region regionA, region regionB,region* regions,int size){
	float lowerCaseDelta = 1/(6*(float)(size*size));
	int numRegsWithA = 0;
	int numRegsWithB = 0;
	int i;
	for(i = 0; i < size; i++){
		if(regions[i].numOfPixels == regionA.numOfPixels){numRegsWithA++;}
		if(regions[i].numOfPixels == regionB.numOfPixels){numRegsWithB++;}
	}
	float maxAvgColorA = max3(regionA.avgR,regionA.avgG,regionA.avgB);
	float maxAvgColorB = max3(regionB.avgR,regionB.avgG,regionB.avgB);
	float bA = (1/(Q*regionA.numOfPixels*2))*log(numRegsWithA/lowerCaseDelta);
	float bB = (1/(Q*regionB.numOfPixels*2))*log(numRegsWithB/lowerCaseDelta);
	return fabs(maxAvgColorA-maxAvgColorB) <= bA*bA+bB*bB;
}

void srm2(region* regions, edge* pairs,int numOfPixels){
	int j;
	for(j = 0; j < numOfPixels*2;j++){
		region r1 = pairs[j].r1;
		region r2 = pairs[j].r2;
		if(mergeTest(r1,r2,regions,numOfPixels) == true){
			if(r1.numOfPixels >= r2.numOfPixels){
				pairs[j].r1.child = &(pairs[j].r2);
				pairs[j].r2.head = false;	
			}else{
				pairs[j].r2.child = &(pairs[j].r1);
				pairs[j].r1.head = false;
			}
			int totalPixels = r1.numOfPixels + r2.numOfPixels;
			pairs[j].r1.avgR = (r1.numOfPixels/totalPixels)*r1.avgR+(r2.numOfPixels/totalPixels)*r2.avgR;
			pairs[j].r1.avgG = (r1.numOfPixels/totalPixels)*r1.avgG+(r2.numOfPixels/totalPixels)*r2.avgG;
			pairs[j].r1.avgB = (r1.numOfPixels/totalPixels)*r1.avgB+(r2.numOfPixels/totalPixels)*r2.avgB;
			pairs[j].r2.avgR = (r1.numOfPixels/totalPixels)*r1.avgR+(r2.numOfPixels/totalPixels)*r2.avgR;
			pairs[j].r2.avgG = (r1.numOfPixels/totalPixels)*r1.avgG+(r2.numOfPixels/totalPixels)*r2.avgG;
			pairs[j].r1.avgB = (r1.numOfPixels/totalPixels)*r1.avgB+(r2.numOfPixels/totalPixels)*r2.avgB;
			pairs[j].r1.numOfPixels += pairs[j].r2.numOfPixels;
			pairs[j].r2.numOfPixels +=  pairs[j].r1.numOfPixels;
		}	
	}
}*/
