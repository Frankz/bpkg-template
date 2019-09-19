BIN ?= bpkg-template
PREFIX ?= /usr/local

install:
	cp bpkg-template.sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

example.sh:
	./example.sh

.PHONY: example.sh
