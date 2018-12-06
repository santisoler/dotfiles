# All markdown files in the working directory
MARKDOWNS = $(wildcard --depth=1 *.md)

# Name of the output directory (it will be created if it does not exist)
OUTPUT = _output

# Output PDF file names
PDFS = $(addprefix $(OUTPUT)/, $(MARKDOWNS:.md=.pdf))

# Other possible outputs
HTML = $(addprefix $(OUTPUT)/, $(MARKDOWNS:.md=.html))
TEX = $(addprefix $(OUTPUT)/, $(MARKDOWNS:.md=.tex))
DOCX = $(addprefix $(OUTPUT)/, $(MARKDOWNS:.md=.docx))

# Configure pdfviewer
PDFVIEWER = xdg-open


all: pdf

pdf: $(PDFS)

tex: $(TEX)

html: $(HTML)

docx: $(DOCX)

clean:
	rm -rf $(OUTPUT)

show: all
	@ ( $(foreach PDF,$(PDFS),$(PDFVIEWER) $(PDF) 2> /dev/null;) )

$(OUTPUT)/%.pdf: %.md | $(OUTPUT)/
	pandoc -o $@ $<

$(OUTPUT)/%.html: %.md | $(OUTPUT)/
	pandoc -o $@ $<

$(OUTPUT)/%.tex: %.md | $(OUTPUT)/
	pandoc -o $@ $<

$(OUTPUT)/%.docx: %.md | $(OUTPUT)/
	pandoc -o $@ $<

$(OUTPUT)/:
	mkdir $(OUTPUT)
