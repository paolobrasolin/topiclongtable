NAME  = topiclongtable
DOC   = topiclongtable-doc
SHELL = bash
PWD   = $(shell pwd)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx|sed -e 's/^v//')
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
all: $(DOC).pdf
	test -e README.txt && mv README.txt README || exit 0
$(DOC).pdf: $(DOC).tex
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	if [ -f $(DOC).glo ]; then makeindex -q -s gglo.ist -o $(DOC).gls $(DOC).glo; fi
	if [ -f $(DOC).idx ]; then makeindex -q -s gind.ist -o $(DOC).ind $(DOC).idx; fi
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
	pdflatex --recorder --interaction=batchmode $(DOC).tex > /dev/null
clean:
	rm -f $(DOC).{aux,fls,glo,gls,hd,idx,ilg,ind,ins,log,out}
distclean: clean
	rm -f $(DOC).pdf
inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp $(NAME).sty $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)
install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	sudo cp $(NAME).sty $(LOCAL)/tex/latex/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
zip: all
	ln -sf . $(NAME)
	zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)/{README,$(NAME).{pdf,dtx}}
	rm $(NAME)
watch:
	ls $(DOC).tex | entr -n -s 'make distclean $(DOC).pdf || say error'
