#!/bin/bash
set -e

pandoc=~/bin/pandoc-2.14.2/bin/pandoc
SRC=~/src/thomaspaine-www/content/works
OUT=content/works
rm -rf content/works
mkdir -p content/works

IFS=$(echo -en "\n\b")
for f in $(ls $SRC/*.md); do
    echo "$f"
    SLUG=$(echo "---" | cat - "$f" | sed '0,/^$/ s/^$/---\n/;  s/^Title: \(.*\)$/title: "\1"/; /^Date:.*$/d' | $pandoc --template templates/metadata.tmpl  | jq -r ".Slug")
    mkdir -p $OUT/$(dirname $SLUG)
    echo "---" | cat - "$f" | sed '0,/^$/ s/^$/---\n/;  s/^Title: \(.*\)$/title: "\1"/; /^Date:.*$/d' > "$OUT/$SLUG.md"
done
