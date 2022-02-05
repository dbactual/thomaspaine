#!/usr/bin/env python3

import cgi
import html
import utils
from email.utils import parseaddr


def capture_email():
    try:
        form = cgi.FieldStorage()
        em = html.escape(form.getvalue("em", ""))
        if not utils.validate_input(em):
            return
        nm, em = parseaddr(em)
        if not len(em) or '@' not in em:
            print('Please enter a valid email address')
            return
        with open("/home/protected/data/em.txt", "a") as myfile:
            myfile.write(em)
            myfile.write('\n')
        print('<h3>Thanks for enrolling in our mailing list!</h3>')
        print(em)
    except Exception:
        import traceback
        print(traceback.format_exc())
        print("Unable to enroll!")


utils.output_env()
utils.output_file('header.html')
capture_email()
utils.output_file('footer.html')
