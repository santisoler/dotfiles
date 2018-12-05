# All markdown files in the working directory
MARKDOWNS = $(wildcard --depth=1 *.md)

# Name of the output directory (it will be created if it does not exist)
OUTPUT = _output

# Output PDF file names
PDFS = $(addprefix $(OUTPUT)/, $(MARKDOWNS:.md=.pdf))


all: $(PDFS)

clean:
	rm -rf $(OUTPUT)

$(OUTPUT)/%.pdf: %.md | $(OUTPUT)/
	pandoc -o $@ $<

$(OUTPUT)/:
	mkdir $(OUTPUT)
