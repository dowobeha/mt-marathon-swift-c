all: clean toy
	LD_LIBRARY_PATH=/usr/local/cuda/lib ./toy

ARCH=x86_64
SWIFT_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
SWIFT_TARGET=${ARCH}-apple-macosx10.11
XLINKER=

toy: main.o UserInput.o saxpy.o DataOnGPU.o
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} DataOnGPU.o main.o UserInput.o saxpy.o -o toy ${XLINKER} -L/usr/local/cuda/lib ${XLINKER} -lcuda ${XLINKER} -lcudart -F/Library/Frameworks -module-name toy 

main.o DataOnGPU.o: main.swift toy-Bridging-Header.h DataOnGPU.swift
	swiftc -I/usr/local/cuda/include  -module-name toy -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -import-objc-header toy-Bridging-Header.h -c main.swift -c DataOnGPU.swift

#DataOnGPU.o: DataOnGPU.swift
#	swiftc -module-name toy -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -c DataOnGPU.swift

UserInput.o: UserInput.c
	clang -I/usr/local/cuda/include -x c -arch ${ARCH} -c UserInput.c -o UserInput.o

saxpy.o: saxpy.cu
	nvcc -c saxpy.cu -o saxpy.o

clean:
	clear; rm -f toy toy.swiftmodule toy.swiftdoc toy.h UserInput.o main.o main.h main.swiftmodule main.swiftdoc saxpy.o *.o

