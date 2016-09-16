class CudaVector {

	//var data_on_device : UnsafeMutablePointer<Float>
	//let data_on_device_void_pointer : UnsafeMutableRawPointer?

	var data_on_device : UnsafeMutableRawPointer?

	let count : Int
	let byteCount : Int

	init?(count:Int) {

		self.byteCount = count * MemoryLayout<Float>.size

		//self.data_on_device = UnsafeMutablePointer<Float>.allocate(capacity:0)
		//self.data_on_device_void_pointer = UnsafeMutableRawPointer(data_on_device)
		
		self.data_on_device = nil
		
		//var pointer : UnsafeMutablePointer<Optional<UnsafeMutablePointer<Float>>> = UnsafeMutablePointer<Optional<UnsafeMutablePointer<Float>>>(&data_on_device)
		
		//var p = OpaquePointer(&data_on_device_void_pointer)

		//var pointer_as_optional : UnsafeMutableRawPointer? = data_on_device_void_pointer
		//let pointer : UnsafeMutablePointer<UnsafeMutableRawPointer?> = UnsafeMutablePointer<UnsafeMutableRawPointer?>(&pointer_as_optional)
		//var p3 : UnsafeMutablePointer<UnsafeMutableRawPointer?> = UnsafeMutablePointer<UnsafeMutableRawPointer?>(&Optional(data_on_device_void_pointer))
//		var pointer = UnsafeMutablePointer<UnsafeMutableRawPointer?>(&data_on_device_void_pointer)
		
		let status = cudaMalloc(&self.data_on_device, self.byteCount);
		
		if (status == cudaSuccess) {
			self.count = count
			
		} else {
			return nil
		}

	}

	var floatPointer : UnsafePointer<Float> {

		get {
	
			let mutableFloatPointer = data_on_device!.bindMemory(to: Float.self, capacity: count)
		
			return UnsafePointer(mutableFloatPointer)
			
		}
	
	}

	func sum() -> Float {
		if let data = copyDataFromDevice() {
			return data.reduce(0.0, +)
		} else {
			return Float.nan
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
			
		var result : [Float] = Array(repeating: Float.nan, count: self.count)
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
