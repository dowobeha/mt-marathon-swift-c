#include <stdio.h>


__global__
void my_sample_device_code(int n, float a, float *x, float *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}


__global__
void gpu_calculate_error(float *explanatory_data, float *dependent_data, float *calculated_error, float slope, float y_intercept, int number_of_data_points) {

  int i = blockIdx.x*blockDim.x + threadIdx.x;
  
  if (i < number_of_data_points) {
//  	calculated_error[i] = y_intercept + slope*explanatory_data[i] - dependent_data[i];
	calculated_error[i] = - dependent_data[i];
  }

}

extern "C" 
void calculate_error(float *explanatory_data, float *dependent_data, float *calculated_error, float slope, float y_intercept, int number_of_data_points) {
	gpu_calculate_error<<<10,10>>>(explanatory_data, dependent_data, calculated_error, slope, y_intercept, number_of_data_points);
}



__global__
void gpu_times_equals(float *lhs, float *rhs, int number_of_data_points) {

  int i = blockIdx.x*blockDim.x + threadIdx.x;
  
  if (i < number_of_data_points) {
  	lhs[i] *= rhs[i];
  }

}

extern "C" 
void calculate_times_equals(float *lhs, float *rhs, int number_of_data_points) {
	gpu_times_equals<<<10,10>>>(lhs, rhs, number_of_data_points);
}

/*
extern "C"
void calculate_sum(float *data, int number_of_data_points) {
	gpu_sum
}
*/


extern "C" int my_sample_host_code( int x1, int y1 )

{

  int N = 1<<20;
  float *x, *y, *d_x, *d_y;
  x = (float*)malloc(N*sizeof(float));
  y = (float*)malloc(N*sizeof(float));

  cudaMalloc(&d_x, N*sizeof(float)); 
  cudaMalloc(&d_y, N*sizeof(float));

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

  // Perform SAXPY on 1M elements
  my_sample_device_code<<<(N+255)/256, 256>>>(N, 2.0f, d_x, d_y);

  cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

int result;
result = -1;
cudaGetDeviceCount ( &result );
printf("CUDA device count: %d\n", result);

result = -2;
	cudaGetDevice(&result);
	printf("CUDA device number: %d\n", result);

	int dev = 0;
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, dev);

        printf("\nDevice %d: \"%s\"\n", dev, deviceProp.name);

  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = max(maxError, abs(y[i]-4.0f));
  printf("Max error: %f\n", maxError);

	return 0;
}
