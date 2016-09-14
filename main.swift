//
//  main.swift
//  toy
//
//  Created by Lane Schwartz on 2016-09-14.
//  Copyright © 2016 Lane Schwartz. All rights reserved.
//

import Foundation


var output: CInt = 0
getInput(&output)

print(output)

let x = DataOnGPU()
x.foo()

if let cublas = CUBLAS() {

	if let v = CUDA_Vector(cublas, count:3) {

		v.copyDataToDevice(Array(count: 3, repeatedValue: 7.0))
		if let sum = v.sum() {
			print(sum)
		}
	}

}
