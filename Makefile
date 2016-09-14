all: clean toy
	LD_LIBRARY_PATH=/usr/local/cuda/lib ./toy

ARCH=x86_64
SWIFT_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
SWIFT_TARGET=${ARCH}-apple-macosx10.11

toy: main.o UserInput.o my_sample_cuda_code.o cuda.o cublas.o
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} cuda.o main.o UserInput.o my_sample_cuda_code.o cublas.o -o toy -L/usr/local/cuda/lib -lcuda -lcudart -lcublas -F/Library/Frameworks -module-name toy 

main.o cuda.o cublas.o: main.swift toy-Bridging-Header.h cuda.swift
	swiftc -I/usr/local/cuda/include  -module-name toy -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -import-objc-header toy-Bridging-Header.h -c main.swift -c cuda.swift -c cublas.swift

UserInput.o: UserInput.c
	clang -I/usr/local/cuda/include -x c -arch ${ARCH} -c UserInput.c -o UserInput.o

my_sample_cuda_code.o: my_sample_cuda_code.cu
	nvcc -c my_sample_cuda_code.cu -o my_sample_cuda_code.o

clean:
	clear; rm -f toy toy.swiftmodule toy.swiftdoc toy.h UserInput.o main.o main.h main.swiftmodule main.swiftdoc my_sample_cuda_code.o *.o

