package ckb.utils;

/**
 * Uzbek phone number in one format: "998 XX XXX XXXX".
 * The Telegram bot compares the last 9 digits, so the stored number must be complete.
 * A 9-digit number gets the 998 prefix; foreign numbers, several numbers or text are kept as typed.
 * The same rule is used in the browser: fmsPhoneFormat in web/res/js/common.js.
 */
public class Phone {

  public static String format(String v) {
    if (v == null) return null;
    String s = v.trim();
    if (s.isEmpty() || s.matches(".*[,;A-Za-z\\u0400-\\u04FF].*")) return s;
    String d = s.replaceAll("\\D", "");
    if (d.length() == 9) d = "998" + d;
    if (d.length() != 12 || !d.startsWith("998")) return s;
    return d.substring(0, 3) + " " + d.substring(3, 5) + " " + d.substring(5, 8) + " " + d.substring(8);
  }
}
