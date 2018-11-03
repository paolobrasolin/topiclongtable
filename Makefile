PKG   = topiclongtable
DOC   = $(PKG)-doc
SHELL = bash
PWD   = $(shell pwd)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
all: README.md $(PKG).sty $(DOC).tex $(DOC).pdf
$(DOC).pdf: $(DOC).tex
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	if [ -f $(DOC).glo ]; then makeindex -q -s gglo.ist -o $(DOC).gls $(DOC).glo; fi
	if [ -f $(DOC).idx ]; then makeindex -q -s gind.ist -o $(DOC).ind $(DOC).idx; fi
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
clean:
	rm -f $(DOC).{aux,fls,glo,gls,hd,idx,ilg,ind,ins,log,out,tlt}
distclean: clean
	rm -f $(DOC).pdf $(PKG).zip
install: all
	mkdir -p $(UTREE)/{tex,doc}/latex/$(PKG)
	cp $(PKG).sty $(UTREE)/tex/latex/$(PKG)
	cp $(DOC).{pdf,tex} README.md $(UTREE)/doc/latex/$(PKG)
uninstall:
	rm -r $(UTREE)/{tex,doc}/latex/$(PKG)
zip: all
	ln -sf . $(PKG)
	zip -Drq $(PWD)/$(PKG).zip $(PKG)/{README.md,$(PKG).{sty},$(DOC).{tex,pdf}}
	rm $(PKG)
watch:
	ls $(DOC).tex | entr -n -s 'make distclean $(DOC).pdf'
