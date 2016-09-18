
class CUBLAS {

	var handle: OpaquePointer?

	init?() {
	
		//self.handle = UnsafeMutableRawPointer(nil)
		//var pointer_as_optional : UnsafeMutablePointer<OpaquePointer>? = nil
		//let pointer : UnsafeMutablePointer<OpaquePointer?> = UnsafeMutablePointer<OpaquePointer?>(&pointer_as_optional)
		//var cublasHandle : cublasHandle_t
		//var opt : cublasHandle_t? = cublasHandle
		//var p = UnsafeMutablePointer<cublasHandle_t?>(&zzz)
		
		let status = cublasCreate_v2(&handle)
		
		if (status==CUBLAS_STATUS_SUCCESS) {
			handle = cublasHandle
		} else {
			return nil
		}
		
		handle = initializeCublas();
	}

	deinit {
		cublasDestroy_v2(handle)
	}


	func asum(vector:CudaVector) -> Float? {
		
		var sum : Float = Float.nan
//		let immutable_data_on_device = vector.data_on_device.bindMemory<Float>

		let status = cublasSasum_v2(handle, Int32(vector.count), vector.floatPointer , 1, &sum)
		
		if (status==CUBLAS_STATUS_SUCCESS) {
			return sum
		} else {
			return nil
		}

	}

}

