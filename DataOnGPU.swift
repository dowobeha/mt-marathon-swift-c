class DataOnGPU {

	func foo() -> Void {
		print("Hello, world")
	}

}


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
	/*
	func getHandle() -> UnsafeMutablePointer<Void> {
		return handle
	}
	*/
	deinit {
		cublasDestroy_v2(handle)
	}

}


class CUDA_Vector {

	private var data_on_device : UnsafeMutablePointer<Void>

	private let cublas : CUBLAS

	//let size : CInt
	let count : Int
	let byteCount : Int


	init?(_ cublas:CUBLAS, count:Int) {
	
		self.cublas = cublas
	
		self.count = count
		self.byteCount = count * sizeof(CFloat)
		
	
		//let sizeof_float = CInt(sizeof(CFloat))
		//print("sizeof(float) = \(sizeof_float)")
		//let data : [Float] = Array(count: 3, repeatedValue: 7.0)
		//self.size = CInt(data.count)
		data_on_device = nil
		let status = cudaMalloc(&data_on_device, self.byteCount);
		
		if (status != cudaSuccess) {
			return nil
		}
		
		//cudaMemcpy(data_on_device, data, data.count * sizeof(CFloat), cudaMemcpyHostToDevice);	

//		var cublasHandle : COpaquePointer = nil
		//var cublasStatus = cublasCreate_v2(cublas.handle)
		//print("cublasCreate_v2: \(cublasStatus==CUBLAS_STATUS_SUCCESS)")
		

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
	
	
	func sum() -> Float? {
		
		var sum : Float = -1
		let immutable_data_on_device = UnsafePointer<Float>(data_on_device)
		print("CUDA_Vector.count = \(Int32(self.count))")
		print("sum = \(sum)")
		let status = cublasSasum_v2(cublas.handle, Int32(self.count), immutable_data_on_device , 1, &sum)
		
		if (status==CUBLAS_STATUS_SUCCESS) {
				
			print("cublasSasum_v2: \(status==CUBLAS_STATUS_SUCCESS)")
			print("sum = \(sum)")
			return sum
		} else {
			return nil
		}

	}


	deinit {
		cudaFree(data_on_device)
	}

}
