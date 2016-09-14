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

extern int func_B( int x, int y);



void getInput(int *output) {

   // code, code, then

	//func_B( 1, 2 );
	int dev = 0;
        struct cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, dev);

        printf("\nDevice %d: \"%s\"\n", dev, deviceProp.name);

}
