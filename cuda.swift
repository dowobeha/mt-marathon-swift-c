class CudaVector {

	var data_on_device : UnsafeMutablePointer<Void>

	let count : Int
	let byteCount : Int

	init?(count:Int) {

		self.byteCount = count * sizeof(CFloat)

		data_on_device = nil
		let status = cudaMalloc(&data_on_device, self.byteCount);
		
		if (status == cudaSuccess) {
			self.count = count
		} else {
			return nil
		}

	}

	func copyDataToDevice(data:[Float]) -> Bool {
	
		let success = cudaMemcpy(data_on_device, data, data.count * sizeof(CFloat), cudaMemcpyHostToDevice);
	
		return (success == cudaSuccess)
	
	}
	
	func copyDataFromDevice() -> [Float]? {
			
		var result : [Float] = Array(count: self.count, repeatedValue: Float.NaN)
		let status = cudaMemcpy(&result, data_on_device, Int(self.count) * sizeof(CFloat), cudaMemcpyDeviceToHost);
		
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
