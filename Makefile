CC=gcc
CFLAGS=`pkg-config --cflags gtk+-2.0` -Wall -Wno-deprecated-declarations

INSTDIR=$(HOME)/lib

.PHONY: all

all: flash_nomenus_override.so

%.o: %.c
	$(CC) -c -fPIC -o $@ $< $(CFLAGS)

flash_nomenus_override.so: override.o
	$(CC) $^ -shared -o $@ $(CFLAGS)
#	one-liner:
#	$(CC) -shared -o $@ -fPIC $^ $(CFLAGS)
#
#	Uncomment to see preprocessor output
#	$(CC) -E -fPIC $^ $(CFLAGS)

.PHONY: clean

clean:
	rm -f flash_nomenus_override.so *.o

.PHONY: install

install: flash_nomenus_override.so
	mkdir -p $(INSTDIR)
	cp $< $(INSTDIR)
