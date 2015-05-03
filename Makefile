Src=how
Name=15how
BibDir=.
Bib=  $(BibDir)/refs.bib

all : dirs tex bib  tex tex embedfonts done publocal

commit:  ; - git status; git commit -a; git push origin master; cd $(BibDir); svn commit -m stuff
typo:  ; - git status; git commit -am "typo"; git push origin master; cd $(BibDir); svn update 
update:; - git pull origin master
status:; - git status
gitting:
	git config --global credential.helper cache
	git config credential.helper 'cache --timeout=3600'

publish : dirs all
	cp $(HOME)/tmp/$(Src).pdf pdf/$(Name).pdf
	chmod a+r pdf/$(Name).pdf
	scp -p pdf/$(Name).pdf stuff@ttoy.net:menzies.us/pdf

one : dirs tex done publocal

view:
	evince $(HOME)/tmp/$(Src).pdf &

publocal:
	cp $(HOME)/tmp/$(Src).pdf pdf/

timm :
	cp $(HOME)/tmp/$(Src).pdf $(HOME)/public_html/tmp

done :
	@printf "\n\n\n==============================================\n"
	@printf       "see output in $(HOME)/tmp/$(Src).pdf\n"
	@printf       "==============================================\n\n\n"
	@printf "\n\nWarnings (may be none):\n\n"
	@- grep arning $(HOME)/tmp/${Src}.log

dirs : 
	- [ ! -d $(HOME)/tmp ] && mkdir $(HOME)/tmp
	- [ ! -d pdf ] && mkdir pdf

tex : 
	- pdflatex --shell-escape -output-directory=$(HOME)/tmp $(Src)

embedfonts:
	@ gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite \
          -sOutputFile=$(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf
	@ mv              $(HOME)/tmp/$(Src)-embedded.pdf $(HOME)/tmp/$(Src).pdf

bib : 
	- cp $(Bib) $(HOME)/tmp; cd $(HOME)/tmp; bibtex $(Src)
