class CudaVector {

	var data_on_device : UnsafeMutablePointer<Void>

	let count : Int
	let byteCount : Int

	init?(count:Int) {

		self.byteCount = count * sizeof(CFloat)

		self.data_on_device = nil
		let status = cudaMalloc(&data_on_device, self.byteCount);
		
		if (status == cudaSuccess) {
			self.count = count
		} else {
			return nil
		}

	}

	func copyDataWithinDevice(other:CudaVector) -> Bool {
	
		let success = cudaMemcpy(data_on_device, other.data_on_device, self.byteCount, cudaMemcpyDeviceToDevice);
	
		return (success == cudaSuccess)
	
	}

	func copyDataToDevice(data:[Float]) -> Bool {
	
		let success = cudaMemcpy(data_on_device, data, self.byteCount, cudaMemcpyHostToDevice);
	
		return (success == cudaSuccess)
	
	}
	
	func copyDataFromDevice() -> [Float]? {
			
		var result : [Float] = Array(count: self.count, repeatedValue: Float.NaN)
		let status = cudaMemcpy(&result, data_on_device, self.byteCount, cudaMemcpyDeviceToHost);
		
		if (status==cudaSuccess) {
			return result
		} else {
			return nil
		}
	}


	deinit {
		cudaFree(data_on_device)
	}

}
