all: clean toy
	LD_LIBRARY_PATH=/usr/local/cuda/lib ./toy

ARCH=x86_64
SWIFT_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
SWIFT_TARGET=${ARCH}-apple-macosx10.11
XLINKER=

toy: main.o UserInput.o saxpy.o
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} main.o UserInput.o saxpy.o -o toy ${XLINKER} -L/usr/local/cuda/lib ${XLINKER} -lcuda ${XLINKER} -lcudart -F/Library/Frameworks

main.o: main.swift  toy-Bridging-Header.h
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -import-objc-header toy-Bridging-Header.h -c main.swift

UserInput.o: UserInput.c
	clang -x c -arch ${ARCH} -c UserInput.c -o UserInput.o

saxpy.o: saxpy.cu
	nvcc -c saxpy.cu -o saxpy.o

clean:
	rm -f toy toy.swiftmodule toy.swiftdoc toy.h UserInput.o main.o main.h main.swiftmodule main.swiftdoc saxpy.o

