class DataOnGPU {

	func foo() -> Void {
		print("Hello, world")
	}

}


class CUDA_Vector {

	init() {
	
		let sizeof_float = CInt(sizeof(CFloat))
		print("sizeof(float) = \(sizeof_float)")
		let data : [Float] = Array(count: 3, repeatedValue: 7.0)
		let N = CInt(data.count)
		var data_on_device : UnsafeMutablePointer<Void> = nil
		cudaMalloc(&data_on_device, data.count * sizeof(CFloat));
		cudaMemcpy(data_on_device, data, data.count * sizeof(CFloat), cudaMemcpyHostToDevice);	
		
		var result : [Float] = Array(count: 3, repeatedValue: 3.0)
		print(result[0])
		cudaMemcpy(&result, data_on_device, data.count * sizeof(CFloat), cudaMemcpyDeviceToHost);
		
		print(result[0])
		
		var cublasHandle : COpaquePointer = nil
		var cublasStatus = cublasCreate_v2(&cublasHandle)
		print("cublasCreate_v2: \(cublasStatus==CUBLAS_STATUS_SUCCESS)")
		
		var sum : Float = -1
		let immutable_data_on_device = UnsafePointer<Float>(data_on_device)
		print("N = \(N)")
		print("sum = \(sum)")
		cublasStatus = cublasSasum_v2(cublasHandle, N, immutable_data_on_device , 1, &sum)
		print("cublasSasum_v2: \(cublasStatus==CUBLAS_STATUS_SUCCESS)")
		print("sum = \(sum)")
	}


}
