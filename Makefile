# In order to use this makefile, you need some tools:
# - make
# - pandoc 2.14 or higher
# - jq

# TODO
# mkdir output
# replace markdown metadata with --- before/after

SITEURL := http://localhost:8000
pandoc := /home/db/bin/pandoc-2.14.2/bin/pandoc

HTML_FILES = $(shell find content/ -type f -name "*.md" | sed 's/content\//output\//g; s/md/html/g;' )

all: $(HTML_FILES)

output/%.html: content/%.md
	@echo "$<"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   --variable SITEURL=$(SITEURL) \
	  -f markdown  $< \
	  --template templates/default.tmpl \
	  -o $@

.PHONY : all

clean:
	@rm -rf output
	@mkdir output
