#!/usr/bin/env python3

import cgi
import html
import json
import sqlite3
import utils


def redirect_paypal(user):
    print('<h3>Thank you for becoming a member!</h3>')
    print('<p>You will now be taken to paypal to complete your membership with a donation.</p>')
    print(f"""
          <form name="membership_form" id="membership_form" action="https://www.paypal.com/en/cgi-bin/webscr" method="post">
              <input type="hidden" name="cmd" value="_donations">
              <input type="hidden" name="business" value="info@thomaspaine.org">
              <input type="hidden" name="return" value="http://thomaspaine.org">
              <input type="hidden" name="undefined_quantity" value="0">
              <input type="hidden" name="item_name" value="Membership to The Thomas Paine National Historical Association">
              <input type="hidden" name="charset" value="utf-8">
              <input type="hidden" name="no_shipping" value="1">
              <input type="hidden" name="image_url" value="http://thomaspaine.org/theme/images/logo-new-big.png">
              <input type="hidden" name="cpp_headerback_color" value="F6E6CE">
              <input type="hidden" name="cancel_return" value="https://thomaspaine.org">
              <input type="hidden" name="no_note" value="0">
              <input type="hidden" name="name" value="{user['name']}">
              <input type="hidden" name="email" value="{user['email']}">
              <input type="hidden" name="amount" value="{user['amount']}">
              <input type="hidden" name="return" value="http://thomaspaine.org/membership_complete.html">
              <button class="secondary" alt="Complete Membership" type="submit" name="submit">Complete Membership</button>
            </form>

            <script type="text/javascript">
                window.onload=function(){{
                    var auto = setTimeout(function(){{ submitForm(); }}, 10);

                    function submitForm(){{
                      document.forms["membership_form"].submit.click();
                    }}
                }}
            </script>
            """
          )


def get_amount(level):
    amount = 0
    if level.startswith("Individual"):
        amount = 25.0
    if level.startswith("Family"):
        amount = 40.0
    if level.startswith("Business"):
        amount = 100.0
    if level.startswith("Corporate"):
        amount = 500.0
    if level.startswith("Gold"):
        amount = 1500.0
    return amount


def save_json(user):
    with open("/home/protected/data/mem.json", "a") as myfile:
        myfile.write(json.dumps(user))
        myfile.write('\n')


def save_sqlite(user):
    f = "/home/protected/data/mem.sqlite"
    conn = sqlite3.connect(f)
    c = conn.cursor()
    sql = ''' INSERT INTO mem(name,email,address,level,amount,street,city,state,postcode,country)
              VALUES(?,?,?,?,?,?,?,?,?,?) '''
    cur = conn.cursor()
    cur.execute(sql, [
        user["name"],
        user["email"],
        user["address"],
        user["level"],
        user["amount"],
        user["street"],
        user["city"],
        user["state"],
        user["postcode"],
        user["country"]])
    conn.commit()


def record():
    try:
        form = cgi.FieldStorage()
        if "name" not in form or \
           "email" not in form or \
           "level" not in form:
            print("""Provide name, email and membership level.
            Please <a href=\"/pages/membership.html\">try again</a>.""")
        else:
            user = {}
            user["name"] = html.escape(form["name"].value)
            user["email"] = html.escape(form["email"].value)
            user["address"] = html.escape(form.getvalue("address", ""))
            user["street"] = html.escape(form.getvalue("street", ""))
            user["city"] = html.escape(form.getvalue("city", ""))
            user["state"] = html.escape(form.getvalue("state", ""))
            user["postcode"] = html.escape(form.getvalue("postcode", ""))
            user["country"] = html.escape(form.getvalue("country", ""))
            user["level"] = html.escape(form["level"].value)
            user["amount"] = get_amount(user["level"])
            if not utils.validate_input(user["email"]):
                return
            save_json(user)
            save_sqlite(user)
            redirect_paypal(user)
    except Exception:
        import traceback
        print("""
        <div class="card large error">
            <h1>Unable to enroll!</h1>
            <h3>Please contact the site administrator with
                the following information:</h3>
            <p>
        """)
        print(traceback.format_exc())
        print("</p></div>")


utils.output_env()
utils.output_file('header.html')
record()
utils.output_file('footer.html')
