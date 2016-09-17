CFLAGS=-I/usr/local/cuda/include
LDFLAGS=-L/usr/local/cuda/lib

DBGEXE=.build/debug/MTMarathon
RELEXE=.build/release/MTMarathon

SFLAGS=-Xcc $(CFLAGS) -Xlinker $(LDFLAGS)

all: $(DBGEXE)

$(DBGEXE): Sources/*
	swift build $(SFLAGS)

release: $(RELEXE)

$(RELEXE): Sources/*
	swift build -c release $(SFLAGS)

clean:
	rm -rf $(DBGEXE) $(RELEXE)
	swift build --clean
