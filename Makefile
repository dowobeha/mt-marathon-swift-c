all: clean toy

ARCH=x86_64
SWIFT_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
SWIFT_TARGET=${ARCH}-apple-macosx10.11

toy: main.o UserInput.o
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} main.o UserInput.o -o toy

main.o: main.swift  toy-Bridging-Header.h
	swiftc -target ${SWIFT_TARGET} -sdk ${SWIFT_SDK} -import-objc-header toy-Bridging-Header.h -c main.swift

UserInput.o: UserInput.c
	clang -x c -arch ${ARCH} -c UserInput.c -o UserInput.o

clean:
	rm -f toy toy.swiftmodule toy.swiftdoc toy.h UserInput.o main.o main.h main.swiftmodule main.swiftdoc

