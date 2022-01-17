# In order to use this makefile, you need some of these common unix tools:
# - bash 4 or higher
# - make
# - pandoc 2.14 or higher
# - ag (silver searcher)

SITEURL := http://localhost:8000
#SITEURL := https://thomaspaine.org
pandoc := pandoc
PANDOC_ARGS = --ascii --fail-if-warnings

.PHONY : all

MD_FILES = $(shell find content -type f -name "*.md")
HTML_FILES = $(shell find content -type f -name "*.md" | sed 's/content\//output\//g; s/md/html/g;' )
PLAIN_TEXT_FILES = $(shell find content -type f -name "*.md" | sed 's/content\//output\//g; s/md/txt/g;' )
OTHER_HTML_FILES = output/pages/writings_and_timeline.html output/pages/writings_index.html output/pages/writings.html output/pages/timeline_index.html output/pages/timeline.html output/pages/header.html output/pages/footer.html
CSS_FILES = output/css/gd.css output/css/css.css
IMAGES_FILES = $(shell find content/images -type f | sed 's/content\//output\//g;' )
OTHER_IMAGE_FILES = output/images/tplogo-1.svg output/images/tplogo-text.svg output/images/new.svg output/favicon.ico

all: images css html plaintext generated_html

images: $(IMAGES_FILES) $(OTHER_IMAGE_FILES)
css: $(CSS_FILES)
index: output/index.html
generated_html: $(OTHER_HTML_FILES)
html: $(HTML_FILES)
plaintext: ${PLAIN_TEXT_FILES}

output/images/%: content/images/%
	@echo "image -> $@"
	@mkdir -p "$(@D)"
	@cp "$<" "$@"

output/css/%: content/css/%
	@echo "css -> $@"
	@mkdir -p "$(@D)"
	@cp "$<" "$@"

output/favicon.ico: content/images/favicon.ico
	@echo "favicon -> $@"
	@mkdir -p "$(@D)"
	@cp "$<" "$@"

gen/writings.md: $(MD_FILES) script/gen-timeline.sh
	@./script/gen-timeline.sh

gen/writings_index.md: $(MD_FILES) script/gen-timeline.sh
	@./script/gen-timeline.sh

gen/timeline.md: $(MD_FILES) script/gen-timeline.sh
	@./script/gen-timeline.sh

gen/timeline_index.md: $(MD_FILES) script/gen-timeline.sh
	@./script/gen-timeline.sh

output/pages/writings_and_timeline.html: content/pages/writings_and_timeline.md gen/timeline_index.md gen/writings_index.md templates/*
	@echo "writings & timeline -> $@"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   $(PANDOC_ARGS) \
	   --variable SITEURL=$(SITEURL) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown  $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/writings_index.html: gen/writings_index.md templates/*
	@echo "writings index -> $@"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   $(PANDOC_ARGS) \
	   --variable SITEURL=$(SITEURL) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown  $< \
	  --template templates/partial.tmpl \
	  -o $@

output/pages/writings.html: gen/writings.md templates/*
	@echo "writings -> $@"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   $(PANDOC_ARGS) \
	   --variable SITEURL=$(SITEURL) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown  $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/timeline_index.html: gen/timeline_index.md templates/*
	@echo "timeline index -> $@"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   $(PANDOC_ARGS) \
	   --variable SITEURL=$(SITEURL) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown  $< \
	  --template templates/partial.tmpl \
	  -o $@

output/pages/timeline.html: gen/timeline.md templates/*
	@echo "timeline -> $@"
	@mkdir -p "$(@D)"
	@$(pandoc) \
	   $(PANDOC_ARGS) \
	   --variable SITEURL=$(SITEURL) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown  $< \
	  --template templates/page.tmpl \
	  -o $@

output/index.html: content/index.md templates/*
	@echo "index -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_HOME=true \
	  -f markdown $< \
	  --template templates/index.tmpl \
	  -o $@

output/pages/collected-works-project.html: content/pages/collected-works-project.md templates/*
	@echo "collected works project -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_COLLECTED_WORKS=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/resources.html: content/pages/resources.md templates/*
	@echo "resources -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_RESOURCES=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/donate.html: content/pages/donate.md templates/*
	@echo "donate -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_DONATE=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/membership.html: content/pages/membership.md templates/*
	@echo "membership -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_MEMBERSHIP=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/about-us.html: content/pages/about-us.md templates/*
	@echo "resources -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable ENABLE_BREADCRUMB_ABOUT=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/header.html: templates/header.html
	@echo "header -> $@"
	@mkdir -p "$(@D)"
	@cp $< $@

output/pages/footer.html: templates/*
	@echo "footer -> $@"
	@mkdir -p "$(@D)"
	@cp $< $@


# -------

output/works/%.html: content/works/%.md templates/*
	@echo "works -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  --variable CONTENT_TXT_URL=$(subst output,,$(addsuffix ".txt", $(basename $@))) \
	  --variable ENABLE_BREADCRUMB_WRITINGS_AND_TIMELINE=true \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@

output/pages/%.html: content/pages/%.md templates/*
	@echo "pages -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  -f markdown $< \
	  --template templates/page.tmpl \
	  -o $@


output/%.txt: content/%.md templates/*
	@echo "txt -> $@"
	@mkdir -p "$(@D)"
	@${pandoc} ${PANDOC_ARGS} \
	  --variable SITEURL=${SITEURL} \
	  -f markdown $< \
	  --template templates/plain-text.tmpl \
	  -o $@

clean-gen:
	@rm -f gen/writings.md
	@rm -f gen/writings_index.md
	@rm -f gen/timeline.md
	@rm -f gen/timeline_index.md

clean: clean-gen
	@rm -rf output/*
