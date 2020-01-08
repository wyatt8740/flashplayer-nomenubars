CC=gcc
CFLAGS=`pkg-config --cflags gtk+-2.0` -Wall -Wno-deprecated-declarations

INSTDIR=/usr/local

.PHONY: all
all: flash_nomenus_override.so flashplayer_nomenu

%.o: %.c
	$(CC) -c -fPIC -o $@ $< $(CFLAGS)

flash_nomenus_override.so: override.o
	$(CC) $^ -shared -o $@ $(CFLAGS)
#	one-liner:
#	$(CC) -shared -o $@ -fPIC $^ $(CFLAGS)
#
#	Uncomment to see preprocessor output
#	$(CC) -E -fPIC $^ $(CFLAGS)

flashplayer_nomenu:
	$(info Generating wrapper script runnable from here without installing.)
	./wrappergen.sh $(PWD) > $@
	chmod +x $@
# For running in the source directory without installing

.PHONY: install
install: install_lib install_script

.PHONY: install_lib
install_lib: flash_nomenus_override.so
	mkdir -p $(DESTDIR)/$(INSTDIR)/lib
	cp $< $(DESTDIR)/$(INSTDIR)/lib
	strip -s $(DESTDIR)/$(INSTDIR)/lib/$<

# Sort of hacky:
.PHONY: install_script
install_script:
	$(info Generating new wrapper for installation.)
	mkdir -p $(DESTDIR)/$(INSTDIR)/bin
	./wrappergen.sh $(INSTDIR)/lib > $(DESTDIR)/$(INSTDIR)/bin/flashplayer_nomenu
	chmod +x $(DESTDIR)/$(INSTDIR)/bin/flashplayer_nomenu

.PHONY: clean
clean:
	rm -f *.so *.o flashplayer_nomenu
