#!/usr/bin/env python3

import cgi
from html import escape
from pathlib import Path
import re
import string

import utils


def remove_tags(text):
    TAG_RE = re.compile(r'<[^>]+>')
    return TAG_RE.sub('', text).strip()


def format_path(path):
    def _cleanup_terms(terms):
        return [string.capwords(t.replace('-', ' ').replace('.html', '')) for t in terms]
    elements = ' : '.join(_cleanup_terms(path.split('/')))
    return elements


def get_search_term():
    form = cgi.FieldStorage()
    term = escape(form.getvalue('term', ''))
    if not utils.validate_input(term):
        return ''
    return term.replace(' ', '.')


def grep(term):
    results = []
    if not len(term):
        return results
    files = []
    files = list(Path("works").rglob("*.html"))
    for r in files:
        with open(r) as origin_file:
            for line in origin_file:
                if re.search(term, line):
                    results.append((r,line))
    return results


def search(term):
    try:
        utils.output_file('header.html')
        print('<h3>Search results for "%s":</h3>' % term)
        results = grep(term)
        last_document = None
        for path, line in results:
            txt = remove_tags(line)
            if path != last_document:
                if last_document:
                    print('</ul>')
                last_document = path
                formatted_path = format_path(str(path))
                print(f'<h4><a href="/{path}">{formatted_path}</a></h4>')
                print('<ul>')
            print(f'<li>...{utils.highlight(term, txt)}...</li>')
        utils.output_file('footer.html')
    except Exception:
        import traceback
        print(traceback.format_exc())
        print("Unable to search!")


utils.output_env()
search(get_search_term())
