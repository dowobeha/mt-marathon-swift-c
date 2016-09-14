//
//  main.swift
//  toy
//
//  Created by Lane Schwartz on 2016-09-14.
//  Copyright © 2016 Lane Schwartz. All rights reserved.
//

import Foundation


var output: CInt = 0
my_sample_C_function(&output)

print(output)

if let cublas = CUBLAS() {

	if let v = CudaVector(cublas, count:3) {

		let localData : [Float] = Array(count: 3, repeatedValue: 7.0)

		v.copyDataToDevice(localData)
		if let sum = cublas.sum(v) {
			print("Summing the values of \(localData) on the GPU results in value \(sum)")
		}
	}

}
