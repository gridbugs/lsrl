LSC=/usr/bin/env lsc
OUTPUT=webapp/public/generated
SRC=src
LIB=lib

.PHONY: watch

all: webapp

webapp: $(SRC)/*.ls
	mkdir -p $(OUTPUT)
	cp -v $(LIB)/prelude-ls/prelude-ls-requirejs.js $(OUTPUT)/prelude-ls.js
	$(LSC) -co $(OUTPUT) $(SRC)

watch:
	mkdir -p $(OUTPUT)
	cp -v $(LIB)/prelude-ls/prelude-ls-requirejs.js $(OUTPUT)/prelude-ls.js
	$(LSC) -wco $(OUTPUT) $(SRC)

clean:
	rm -rf $(OUTPUT)
