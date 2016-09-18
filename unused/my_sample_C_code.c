//
//  UserInput.c
//  toy
//
//  Created by Lane Schwartz on 2016-09-14.
//  Copyright © 2016 Lane Schwartz. All rights reserved.
//

#include <stdio.h>
/*
extern void baz(void);

void getInput(int *output) {
  scanf("%i", output);
  baz();
}
*/
#include <cuda.h>

#include <cuda_runtime_api.h>

extern int my_sample_host_code( int x, int y);



void my_sample_C_function(int *output) {

   // code, code, then

	//func_B( 1, 2 );
	int dev = 0;
        struct cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, dev);

        printf("\nDevice %d: \"%s\"\n", dev, deviceProp.name);

}
