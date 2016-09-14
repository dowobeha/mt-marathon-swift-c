class DataOnGPU {

	func foo() -> Void {
		print("Hello, world")
	}

}


class CUDA_Vector {

	init() {
		let data : [Float] = Array(count: 3, repeatedValue: 7.0)
		var data_on_device : UnsafeMutablePointer<Void> = nil
		cudaMalloc(&data_on_device, data.count * sizeof(CFloat));
		cudaMemcpy(data_on_device, data, data.count * sizeof(CFloat), cudaMemcpyHostToDevice);	
		
		var result : [Float] = Array(count: 3, repeatedValue: 3.0)
		print(result[0])
		cudaMemcpy(&result, data_on_device, data.count * sizeof(CFloat), cudaMemcpyDeviceToHost);
		
		print(result[0])
	}


}
