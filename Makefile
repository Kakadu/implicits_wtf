OB=ocamlbuild -use-ocamlfind -classic-display -plugin-tag "package(str)"
ifdef OBV
OB += -verbose 6
endif
TARGETS=src/MiniKanren.cmo

.PHONY: all celan clean install uninstall tests test regression promote compile_tests run_tests\
	only-toplevel toplevel jslib ppx minikanren_stuff tester

all: minikanren_stuff test

minikanren_stuff:
	$(OB) -Is src $(TARGETS) $(TARGETS:.cmo=.cmx)


celan: clean

clean:
	rm -fr _build *.log  *.native *.byte
	$(MAKE) -C regression clean

REGRES_CASES := 005

#$(warning $(REGRES_CASES))
define TESTRULES
.PHONY: test_$(1) test$(1).native
test$(1).native: test$(1).ml
	$(OB) -Is src $$@
endef
$(foreach i,$(REGRES_CASES),$(eval $(call TESTRULES,$(i)) ) )

test: test005.native


