.PHONY: help book chapters clean cleanall all
.PHONY: ch1 ch2 ch3 ch4 ch5 ch6 ch7 ch8 ch9 ch10

SHELL := /bin/bash
SRCDIR := src
BUILDDIR := build
OUTDIR := output
CHAPTERS_OUTDIR := $(OUTDIR)/chapters

# Compile from BUILDDIR so aux/log/minted/pdf intermediates never land in src/.
# Trailing colon on TEXINPUTS keeps TeX Live's default search path.
BUILD_TEXINPUTS := ../$(SRCDIR):../$(SRCDIR)/packages:
LATEXMK := latexmk -xelatex -cd- -output-directory=. -aux-directory=. -latexoption="-file-line-error -halt-on-error" -shell-escape -silent -interaction=nonstopmode

help:
	@echo "📚 Book Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make book                - Build full book PDF"
	@echo "  make chapters            - Build all chapter PDFs"
	@echo "  make ch[1-10]            - Build a specific chapter (e.g., make ch1)"
	@echo "  make all                 - Build everything"
	@echo "  make clean               - Delete build artifacts"
	@echo "  make cleanall            - Delete all PDFs + artifacts"
	@echo ""

all: book chapters
	@echo "✓ Build complete!"

book: $(OUTDIR)/book.pdf
	@:

chapters: $(CHAPTERS_OUTDIR)/01_FromCToCpp.pdf \
           $(CHAPTERS_OUTDIR)/02_ReferencesAndFunctions.pdf \
           $(CHAPTERS_OUTDIR)/03_StringAndVector.pdf \
           $(CHAPTERS_OUTDIR)/04_Lifetime.pdf \
           $(CHAPTERS_OUTDIR)/05_Classes.pdf \
           $(CHAPTERS_OUTDIR)/06_OperatorOverloading.pdf \
           $(CHAPTERS_OUTDIR)/07_InheritanceAndPolymorphism.pdf \
           $(CHAPTERS_OUTDIR)/08_TemplatesAndSTL.pdf \
           $(CHAPTERS_OUTDIR)/09_IteratorsAndAlgorithms.pdf \
           $(CHAPTERS_OUTDIR)/10_BridgeToAPCS.pdf
	@echo "✓ All chapters compiled to $(CHAPTERS_OUTDIR)/"

# Chapter Shortcuts
ch1: $(CHAPTERS_OUTDIR)/01_FromCToCpp.pdf
ch2: $(CHAPTERS_OUTDIR)/02_ReferencesAndFunctions.pdf
ch3: $(CHAPTERS_OUTDIR)/03_StringAndVector.pdf
ch4: $(CHAPTERS_OUTDIR)/04_Lifetime.pdf
ch5: $(CHAPTERS_OUTDIR)/05_Classes.pdf
ch6: $(CHAPTERS_OUTDIR)/06_OperatorOverloading.pdf
ch7: $(CHAPTERS_OUTDIR)/07_InheritanceAndPolymorphism.pdf
ch8: $(CHAPTERS_OUTDIR)/08_TemplatesAndSTL.pdf
ch9: $(CHAPTERS_OUTDIR)/09_IteratorsAndAlgorithms.pdf
ch10: $(CHAPTERS_OUTDIR)/10_BridgeToAPCS.pdf

# Full book: copy the driver into BUILDDIR (do not compile ../src/book.tex in
# place — latexmk/xelatex would write aux/log/minted next to the source).
$(OUTDIR)/book.pdf: $(SRCDIR)/book.tex
	@mkdir -p $(BUILDDIR) $(OUTDIR)
	@echo "Building: Full book..."
	@cp $(SRCDIR)/book.tex $(BUILDDIR)/book.tex
	@cd $(BUILDDIR) && TEXINPUTS="$(BUILD_TEXINPUTS)" $(LATEXMK) book.tex > /dev/null 2>&1 || \
		(echo "❌ Build failed. Error snippet from book.log:"; grep -n -A 5 '^!' book.log || tail -20 book.log; exit 1)
	@cp $(BUILDDIR)/book.pdf $(OUTDIR)/book.pdf
	@echo "✓ $(OUTDIR)/book.pdf"

# Build script for chapters
define build_chapter
	@mkdir -p $(BUILDDIR) $(CHAPTERS_OUTDIR)
	@echo "Building chapter: $2..."
	@wrapper="$(BUILDDIR)/chapter-$1.tex" && \
	chap_num=$$(echo "$1" | grep -o '^[0-9]\+') && chap_num=$${chap_num:-1} && \
	sed -e '/\\include{chapters/d' -e '/\\input{chapters/d' -e '/\\end{document}/d' -e '/\\maketitle/d' -e '/\\tableofcontents/d' -e '/\\frontmatter/d' -e '/\\mainmatter/d' $(SRCDIR)/book.tex > "$$wrapper" && \
	echo "\\setcounter{chapter}{$$(( 10#$$chap_num - 1 ))}" >> "$$wrapper" && \
	echo "\\input{../$(SRCDIR)/chapters/$1/chapter}" >> "$$wrapper" && \
	echo "\\end{document}" >> "$$wrapper" && \
	cd $(BUILDDIR) && TEXINPUTS="$(BUILD_TEXINPUTS)" $(LATEXMK) chapter-$1.tex > /dev/null 2>&1 || \
	(echo "❌ Build failed for $2. Error snippet from chapter-$1.log:"; grep -n -A 5 '^!' chapter-$1.log || tail -20 chapter-$1.log; exit 1) && \
	if [ -f "chapter-$1.pdf" ]; then cp chapter-$1.pdf ../$(CHAPTERS_OUTDIR)/$1.pdf; fi
endef

# Individual chapter targets
$(CHAPTERS_OUTDIR)/01_FromCToCpp.pdf:
	$(call build_chapter,01_FromCToCpp,From C to C++)
$(CHAPTERS_OUTDIR)/02_ReferencesAndFunctions.pdf:
	$(call build_chapter,02_ReferencesAndFunctions,References and Functions)
$(CHAPTERS_OUTDIR)/03_StringAndVector.pdf:
	$(call build_chapter,03_StringAndVector,String and Vector)
$(CHAPTERS_OUTDIR)/04_Lifetime.pdf:
	$(call build_chapter,04_Lifetime,Lifetime)
$(CHAPTERS_OUTDIR)/05_Classes.pdf:
	$(call build_chapter,05_Classes,Classes)
$(CHAPTERS_OUTDIR)/06_OperatorOverloading.pdf:
	$(call build_chapter,06_OperatorOverloading,Operator Overloading)
$(CHAPTERS_OUTDIR)/07_InheritanceAndPolymorphism.pdf:
	$(call build_chapter,07_InheritanceAndPolymorphism,Inheritance and Polymorphism)
$(CHAPTERS_OUTDIR)/08_TemplatesAndSTL.pdf:
	$(call build_chapter,08_TemplatesAndSTL,Templates and STL)
$(CHAPTERS_OUTDIR)/09_IteratorsAndAlgorithms.pdf:
	$(call build_chapter,09_IteratorsAndAlgorithms,Iterators and Algorithms)
$(CHAPTERS_OUTDIR)/10_BridgeToAPCS.pdf:
	$(call build_chapter,10_BridgeToAPCS,Bridge to APCS)

clean:
	@rm -rf $(BUILDDIR) \
	    $(SRCDIR)/_minted-* $(SRCDIR)/chapters/*/*.aux $(SRCDIR)/chapters/*/*.log \
	    $(SRCDIR)/*.aux $(SRCDIR)/*.log $(SRCDIR)/*.bcf \
	    $(SRCDIR)/*.bbl $(SRCDIR)/*.blg $(SRCDIR)/*-SAVE-ERROR \
	    $(SRCDIR)/*.run.xml $(SRCDIR)/*.toc $(SRCDIR)/*.out \
	    $(SRCDIR)/*.listing $(SRCDIR)/*.xdv $(SRCDIR)/*.fdb_latexmk \
	    $(SRCDIR)/*.fls $(SRCDIR)/*.pdf $(SRCDIR)/*.pyg \
	    $(SRCDIR)/*.synctex.gz *.log
	@echo "✓ Build artifacts cleaned"

cleanall: clean
	@rm -rf $(OUTDIR)
	@echo "✓ All outputs cleaned"
