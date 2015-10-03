LSC=node_modules/livescript/bin/lsc
OUTPUT=webapp/public/generated
LIB_OUTPUT=webapp/public/lib
SRC=src
LIB=lib
REQUIREJS_LIBS=$(LIB)/requirejs-libs
JS_LIBS=$(LIB)/js-libs

.PHONY: watch

all: webapp

webcommon:
	mkdir -pv $(OUTPUT) $(LIB_OUTPUT)
	cp -v $(REQUIREJS_LIBS)/*.js $(OUTPUT)
	cp -v $(JS_LIBS)/*.js $(LIB_OUTPUT)

webapp: webcommon
	$(LSC) -co $(OUTPUT) $(SRC)

watch: webcommon
	$(LSC) -wco $(OUTPUT) $(SRC)

clean:
	rm -rf $(OUTPUT) $(LIB_OUTPUT) output

rmtemp:
	find src -name '.*' -exec rm {} \;

stripwhitespace:
	find -name '*.ls' -exec sed -i 's/ *$$//' {} \;
