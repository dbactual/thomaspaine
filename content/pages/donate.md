---
title: Donate
---


  <form action="https://www.paypal.com/en/cgi-bin/webscr" method="post">
    <input type="hidden" name="cmd" value="_donations">
    <input type="hidden" name="business" value="${SITEEMAIL}">
    <input type="hidden" name="return" value="${SITEURL}">
    <input type="hidden" name="undefined_quantity" value="0">
    <input type="hidden" name="item_name" value="Donate to The Thomas Paine National Historical Association">
    <input type="hidden" name="charset" value="utf-8">
    <input type="hidden" name="no_shipping" value="1">
    <input type="hidden" name="image_url" value="${SITEURL}/images/donate_logo.png">
    <input type="hidden" name="cpp_headerback_color" value="F6E6CE">
    <input type="hidden" name="cancel_return" value="${SITEURL}">
    <input type="hidden" name="no_note" value="0">


Consider supporting the Thomas Paine National Historical
Association. As a 100% volunteer organization, every dollar we
receive goes directly to supporting our mission. We are a
tax-deductible, 501 c(3) charitable institution. Please donate
via PayPal today!

    <input class="fw4 f6 br-pill bg-dark-green no-underline light-green ba b--dark-green grow pv2 ph3 dib mr3 mt3"
       type="submit" name="submit" alt="Donate" value="Donate">
  </form>
