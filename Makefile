all: clean toy
	clear; LD_LIBRARY_PATH=/usr/local/cuda/lib ./toy

ARCH=x86_64
SWIFT_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk
SWIFT_TARGET=${ARCH}-apple-macosx10.11
CUDA_INCLUDE_DIR=/usr/local/cuda/include

C_TO_SWIFT_BRIDGE_HEADERS=my_sample_C_to_Swift_bridge.h

#C_OBJECT_FILES=my_sample_C_code.o my_sample_cuda_code.o cuda.o cublas.o

toy: main.o 
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -L/usr/local/cuda/lib -lcuda -lcudart -lcublas -F/Library/Frameworks ${C_OBJECT_FILES} main.o -o toy -module-name toy 

main.o cuda.o cublas.o: main.swift my_sample_C_to_Swift_bridge.h cuda.swift
	swiftc -I${CUDA_INCLUDE_DIR}  -module-name toy -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -import-objc-header ${C_TO_SWIFT_BRIDGE_HEADERS} -c main.swift -c cuda.swift -c cublas.swift

my_sample_C_code.o: my_sample_C_code.c
	clang -I${CUDA_INCLUDE_DIR} -x c -arch ${ARCH} -c my_sample_C_code.c -o my_sample_C_code.o

my_sample_cuda_code.o: my_sample_cuda_code.cu
	nvcc -c my_sample_cuda_code.cu -o my_sample_cuda_code.o

clean:
	clear; rm -f toy *.o

