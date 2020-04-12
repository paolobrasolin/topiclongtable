PKG     = topiclongtable
DOC     = $(PKG)-doc
SHELL   = bash
UTREE   = $(shell kpsewhich --var-value TEXMFHOME)
DATE    = $(shell date +"%Y/%m/%d")
VERSION = UNRELEASED

##[ Default ]###################################################################

all: dist/$(PKG)

##[ hygiene ]###################################################################

clean:
	rm -rf build
clobber: clean
	rm -rf dist

##[ Building ]##################################################################

build/README.md:
	mkdir -p build
	cp README.md build/README.md
build/$(PKG).sty:
	mkdir -p build
	sed 's@<<DATE>>@$(DATE)@g;s/<<VERSION>>/$(VERSION)/g' $(PKG).sty > build/$(PKG).sty
build/$(DOC).tex:
	mkdir -p build
	sed 's@<<DATE>>@$(DATE)@g;s/<<VERSION>>/$(VERSION)/g' $(DOC).tex > build/$(DOC).tex
build/$(DOC).pdf: build/$(DOC).tex
	mkdir -p build
	cd build/; pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	cd build/; if [ -f $(DOC).glo ]; then makeindex -q -s gglo.ist -o $(DOC).gls $(DOC).glo; fi
	cd build/; if [ -f $(DOC).idx ]; then makeindex -q -s gind.ist -o $(DOC).ind $(DOC).idx; fi
	cd build/; pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	cd build/; pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null

##[ Distributing ]##############################################################

dist/$(PKG)/%: build/%
	mkdir -p dist/$(PKG)
	cp build/$* dist/$(PKG)/$*

dist/$(PKG): dist/$(PKG)/README.md dist/$(PKG)/$(PKG).sty dist/$(PKG)/$(DOC).tex dist/$(PKG)/$(DOC).pdf

dist/$(PKG)-$(VERSION).zip: dist/$(PKG)
	cd dist/; zip -Drq $(PKG)-$(VERSION).zip $(PKG)/*

##[ Local (un)installation ]####################################################

install: dist/$(PKG)
	mkdir -p $(UTREE)/{tex,doc}/latex/$(PKG)
	cp dist/$(PKG)/$(PKG).sty $(UTREE)/tex/latex/$(PKG)
	cp dist/$(PKG)/$(DOC).{pdf,tex} README.md $(UTREE)/doc/latex/$(PKG)

uninstall:
	rm -r $(UTREE)/{tex,doc}/latex/$(PKG)

##[ Development ]###############################################################

# NOTE: this is useful when writing the manual
watch:
	ls $(DOC).tex | entr -n -s 'make clean build/$(DOC).pdf'
