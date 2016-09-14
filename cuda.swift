class CudaVector {

	var data_on_device : UnsafeMutablePointer<Void>

	private let cublas : CUBLAS

	let count : Int
	let byteCount : Int


	init?(_ cublas:CUBLAS, count:Int) {

		self.byteCount = count * sizeof(CFloat)

		data_on_device = nil
		let status = cudaMalloc(&data_on_device, self.byteCount);
		
		if (status == cudaSuccess) {
			self.cublas = cublas
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
			
		var result : [Float] = Array(count: 3, repeatedValue: 3.0)
		print(result[0])
		let status = cudaMemcpy(&result, data_on_device, Int(self.count) * sizeof(CFloat), cudaMemcpyDeviceToHost);
		
		if (status==cudaSuccess) {
			print(result[0])	
			return result
		} else {
			return nil
		}
	}


	deinit {
		cudaFree(data_on_device)
	}

}
