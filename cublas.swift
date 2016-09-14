class CUBLAS {

	let handle : COpaquePointer

	init?() {
		var cublasHandle : COpaquePointer = nil
		let status = cublasCreate_v2(&cublasHandle)
		
		if (status==CUBLAS_STATUS_SUCCESS) {
			handle = cublasHandle
		} else {
			return nil
		}
	}

	deinit {
		cublasDestroy_v2(handle)
	}


	func sum(vector:CudaVector) -> Float? {
		
		var sum : Float = Float.NaN
		let immutable_data_on_device = UnsafePointer<Float>(vector.data_on_device)

		let status = cublasSasum_v2(self.handle, Int32(vector.count), immutable_data_on_device , 1, &sum)
		
		if (status==CUBLAS_STATUS_SUCCESS) {
			return sum
		} else {
			return nil
		}

	}

}
