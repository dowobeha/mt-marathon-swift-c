//
//  main.swift
//  MTMarathon
//
//  Based on Lane's mt-marathon-swift-c
//  https://github.com/dowobeha/mt-marathon-swift-c
//
//  Created by Richard Wei on 2016-09-17.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import SwiftCUDA.CUDA

class CudaVector {

    enum Error : Swift.Error {
        case copyError
    }

	var dataOnDevice: UnsafeMutableRawPointer?

	let count: Int
	let byteCount: Int

	init?(count: Int) {
		self.byteCount = count * MemoryLayout<Float>.size

		let status = cudaMalloc(&dataOnDevice, byteCount);
		
		guard status == cudaSuccess else { return nil }

        self.count = count
	}

	var floatPointer: UnsafePointer<Float> {
        let mutableFloatPointer = dataOnDevice!.bindMemory(to: Float.self, capacity: count)
        return UnsafePointer(mutableFloatPointer)
	}

	func sum() -> Float {
		guard let data = copyDataFromDevice() else {
			return Float.nan
        }
        return data.reduce(0.0, +)
	}

	func copyDataWithinDevice(_ other: CudaVector) throws {
		let success = cudaMemcpy(dataOnDevice, other.dataOnDevice, byteCount, cudaMemcpyDeviceToDevice);
        guard success == cudaSuccess else {
            throw Error.copyError
        }
	}

    func copyDataToDevice(_ data: [Float]) throws {
		let success = cudaMemcpy(dataOnDevice, data, byteCount, cudaMemcpyHostToDevice);
        guard success == cudaSuccess else {
            throw Error.copyError
        }
	}
	
	func copyDataFromDevice() -> [Float]? {
		var result: [Float] = Array(repeating: Float.nan, count: count)
		let status = cudaMemcpy(&result, dataOnDevice, byteCount, cudaMemcpyDeviceToHost);

		guard status == cudaSuccess else { return nil }
        return result
	}

	deinit {
		cudaFree(dataOnDevice)
	}

}
