import os
import re


def output_env():
    print("Content-type: text/html")
    print()
    os.chdir('..')


def output_file(f):
    print(open(f).read())


def highlight(search_term, txt):
    return re.sub(re.compile(r'(%s)' % search_term, re.IGNORECASE), r'<b>\1</b>', txt)


def validate_input(term):
    if re.search(r"[^a-zA-Z0-9._@\-\ ]", term):
        output_file('header.html')
        print('Please limit input to alphanumeric characters')
        output_file('footer.html')
        sys.exit()
