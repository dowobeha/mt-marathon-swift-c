//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

int my_sample_host_code( int x, int y);
void my_sample_C_function(int *output);
void calculate_error(float *explanatory_data, float *dependent_data, float *calculated_error, float slope, float y_intercept, int number_of_data_points);
void calculate_times_equals(float *lhs, float *rhs, int number_of_data_points);
//void calculate_sum(float *data, int number_of_data_points);

#include <cuda.h>

#include <cuda_runtime_api.h>

#include <cublas_v2.h>

