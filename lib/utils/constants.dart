// @dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  // Common Used Strings
  static const String aquaUserData = 'aquaUserData';
  static const String aquaHomePageData = 'aquaHomePageData';
  static const String aquacurrencyData = 'aquacurrencyData';
  static const String aquaCouponData = 'aquaCouponData';

  static const String isLogIn = 'isLogIn';
  static const String catWOMEN = '1';
  static const String catGIRLS = '2';
  static const String catVIDAL = '7';
  static bool isSignIN = false;
  static String sessionId = 'session_id';
  static const String deviceToken = 'device_token';
  static String sortString = '';
  static String deviceUUID = '';
  static String selectedLang = 'en';
  static int selectedCurrency = 114;
  static String selectedCurrencyString = 'KWD';
  static List selectedProductIds = [];
  static String logInErrorMessage = '';

  static bool isLanguageChanged = false;

  static const GOOGLE_MAPS_API_KEY = 'AIzaSyBEXvu78InVEvtknKjMUSw7R3mH8Zq106M';
  static const BASE_URL = 'https://www.aquafashion.com/api/V1/';

  String liveurl = 'https://www.aquafashion.com/api/';
  String testurl = 'https://www.aquafashion.com/aquatest/api/';
//https://www.aquafashion.com/aquatest/api/V1/
// language Options
  static const String LANGUAGE_KEY = 'lang';
  static const String LANGUAGE_EN = 'en';
  static const String LANGUAGE_AR = 'en';

// Content Pages
  static const String CONTENT_URL = 'content.php';
  static const String CONTENT_URL_KEYWORD = 'keyword';
  static const String CONTENT_URL_ABOUTUS = 'aboutus';
  static const String CONTENT_URL_TERMS = 'terms';
  static const String CONTENT_URL_SHIPPING_RETURN = 'shipping_return';
  static const String CONTENT_URL_SECURE_SHOPPING = 'secure_shopping';
  static const String CONTENT_URL_PRIVACY_POLICY = 'privacy';
  static const String CONTENT_URL_OUR_STORES = 'our_stores';

// Contact US
  static const String CONTACTUS_URL = 'contact.php';
  // Country LIST
  static const String COUNTRYLIST_URL = 'country.php';

  // Currency LIST
  static const String CURRENCYLIST_URL = 'currency.php';

  // USER AUTHRNTICATION URLS
  static const String LOGIN_URL = 'user-login.php';
  static const String REGISTER_URL = 'user-register.php';
  static const String USER_PROFILE = 'user-profile.php';
  static const String CHANGE_PASSWORD = 'user-change-password.php';

  static const String VERIFY_SENT_EMAIL = 'user-forgot-password.php';
  static const String RESET_PASSWORD = 'user-reset-password.php';
  static const String SOCIAL_LOGIN_URL = 'user-social-login.php';
  static const String USER_DELETE = 'user-delete.php';

  // HOME PAGE URL
  static const String HOMEPAGE_URL = 'home.php';

  // PRODUCT LIST URL
  static const String PRODUCTS_LIST = 'product-list.php';
  // Related products URL
  static const String RELATED_PRODUCTS_LIST = 'related-product-list.php';

  // WISH LIST URLS
  static const String WISH_LIST_URL = 'user-wishlist.php';
  static const String WISH_ADD_DELETE = 'user-wishlist-add.php';

  // CART PAGE APIS
  static const String ADD_TO_CART_URL = 'cart-add.php';
  static const String DELETE_FROM_CART_URL = 'cart-delete.php';
  static const String CART_LIST_URL = 'cart-list.php';
  static const String CART_COUPON_CODE = 'apply-coupon.php';

  // PAYMENT PAGE
  static const String PAYMENT_PAGE_CHECK = 'order-checkout.php';
  static const String ORDER_CONFIRM = 'order-confirm.php';
  static const String PAYMENT_RESPONSE = 'payment-response.php';

  static const String ORDERS_LIST = 'user-orderlist.php';
  static const String CANCEL_ORDER = 'order-cancel.php';
  static const String RETURN_ORDER = 'order-return.php';
  static const String ORDER_CASH_CONFIRM = 'order-cash-confirm.php';

  static const String MY_FATHOORAH_TEST_BASE_URL =
      'https://apitest.myfatoorah.com';
  static const String MY_FATHOORAH_MAIN_URL = 'https://api.myfatoorah.com/';

  static const String directPaymentToken =
      '0VgG7FcJoscKyG-BYEW44MHdX6U_JSaP_FEJFto4K7RaF7GDNpzKe58suyszeWUfzJ2FtBXjO_cGh8lE42eiBkfeIOUxSXRMLlWFWcnURu1A7MtyhQ_rK9JQkU7gj9qBRbrCIgh6hx6wB8Dw1toKd41SdFJ-0bD-fm_1x2O4cRJwvyO636sa_Qj5cKXOPJoquMGsR3rBMMZZnXrjz28UcsFXjaoCRa2ZCpVU6iPf4OObMyy9GZASHRmmvUfiTI1dwrZYE3roVxtKf4WyCRnGZcG-IGIgmMZ4tbD0jPR_lnQ-wOW6uwgSAJQPn_FGO9QbRFyeBCDsaMZmHcdI8bT4G-QWEEf04EBpjb_RNsjFY1sOUxOWBJjJlIWLpbpYesUF1PONIwm9L6BGJVq7KMvp5DEoJi25mgSRY0SsHLkElgyElg-emxbFUYT3JhV3W8IhLvelSGlob5o1UyUO7EBAcBqTClvKCnGk_CXUw1kU53lKDMG54KQMSHuQKQ-px9sq3UWW-l96SwqSaMHtwFa8HeyXNwGO6K0V3BLeXkBtt5FeixNkinuKH0LdUYddpQ6HVtS0HXawPv6JkhYrsyxajVKZewCuJAD4grI_LmQZP11tY2zq8JAo-MCw7dS9oL2mVUX977bHUCMHVm281QgOPoXiUdgC7o0yLc3bQE1v0cuIAghRTj_NJZtoA6LEjSJrZBUtbQ';
  static const String regularPaymentToken =
      '7Fs7eBv21F5xAocdPvvJ-sCqEyNHq4cygJrQUFvFiWEexBUPs4AkeLQxH4pzsUrY3Rays7GVA6SojFCz2DMLXSJVqk8NG-plK-cZJetwWjgwLPub_9tQQohWLgJ0q2invJ5C5Imt2ket_-JAlBYLLcnqp_WmOfZkBEWuURsBVirpNQecvpedgeCx4VaFae4qWDI_uKRV1829KCBEH84u6LYUxh8W_BYqkzXJYt99OlHTXHegd91PLT-tawBwuIly46nwbAs5Nt7HFOozxkyPp8BW9URlQW1fE4R_40BXzEuVkzK3WAOdpR92IkV94K_rDZCPltGSvWXtqJbnCpUB6iUIn1V-Ki15FAwh_nsfSmt_NQZ3rQuvyQ9B3yLCQ1ZO_MGSYDYVO26dyXbElspKxQwuNRot9hi3FIbXylV3iN40-nCPH4YQzKjo5p_fuaKhvRh7H8oFjRXtPtLQQUIDxk-jMbOp7gXIsdz02DrCfQIihT4evZuWA6YShl6g8fnAqCy8qRBf_eLDnA9w-nBh4Bq53b1kdhnExz0CMyUjQ43UO3uhMkBomJTXbmfAAHP8dZZao6W8a34OktNQmPTbOHXrtxf6DS-oKOu3l79uX_ihbL8ELT40VjIW3MJeZ_-auCPOjpE3Ax4dzUkSDLCljitmzMagH2X8jN8-AYLl46KcfkBV';
  // ORDERS_LIST
  static const String ORDER_LIST = 'user-orderlist.php';

  // NOTIFICATIONS
  static const String NOTIFICATIONS = 'notification-list.php';
  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText
        .replaceAll(exp, '')
        .replaceAll('[vc_row]', '')
        .replaceAll('[vc_column_text]', '')
        .replaceAll('[vc_column]', '')
        .replaceAll('[/vc_column_text]', '')
        .replaceAll('[/vc_column]', '')
        .replaceAll('[/vc_row]', '')
        .replaceAll('&nbsp;', '');
  }

  static Color hexToColor(String code) {
    print(code);
    if (code == "") {
      return Color(0xFFB6B7B9);
    }
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static PageController pageController;
}
