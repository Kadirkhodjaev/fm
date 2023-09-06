package ckb.utils;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.ui.Model;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class Util {


  private static final String dig1[][] = {{"одна", "две", "три", "четыре", "п€ть", "шесть", "семь", "восемь", "дев€ть"}, {"один", "два"}};
  private static final String dig10[]  = {"дес€ть","одиннадцать", "двенадцать", "тринадцать", "четырнадцать", "п€тнадцать", "шестнадцать", "семнадцать", "восемнадцать", "дев€тнадцать"};
  private static final String dig20[]  = {"двадцать", "тридцать", "сорок", "п€тьдес€т", "шестьдес€т", "семьдес€т", "восемьдес€т", "дев€носто"};
  private static final String dig100[] = {"сто","двести", "триста", "четыреста", "п€тьсот", "шестьсот", "семьсот", "восемьсот", "дев€тьсот"};
  private static final String leword[][] = { {"тийин", "тийин", "тийин", "0"},
    {"сум", "сум", "сум", "1"},
    {"тыс€ча", "тыс€чи", "тыс€ч", "0"},
    {"миллион", "миллиона", "миллионов", "1"},
    {"миллиард", "миллиарда", "миллиардов", "1"},
    {"триллион", "триллиона", "триллионов", "1"}};

  //рекурсивна€ функци€ преобразовани€ целого числа num в рубли
  private static String num2words(long num, int level) {
    StringBuilder words = new StringBuilder(50);
    if (num==0) words.append("ноль ");         //исключительный случай
    int sex = leword[level][3].indexOf("1")+1; //не красиво конечно, но работает
    int h = (int)(num%1000);    //текущий трехзначный сегмент
    int d = h/100;              //цифра сотен
    if (d>0) words.append(dig100[d-1]).append(" ");
    int n = h%100;
    d = n/10;                   //цифра дес€тков
    n = n%10;                   //цифра единиц
    switch(d) {
      case 0: break;
      case 1: words.append(dig10[n]).append(" ");
        break;
      default: words.append(dig20[d-2]).append(" ");
    }
    if (d==1) n=0;              //при двузначном остатке от 10 до 19, цифра едициц не должна учитыватьс€
    switch(n) {
      case 0: break;
      case 1:
      case 2: words.append(dig1[sex][n-1]).append(" ");
        break;
      default: words.append(dig1[0][n-1]).append(" ");
    }
    switch(n) {
      case 1: words.append(leword[level][0]);
        break;
      case 2:
      case 3:
      case 4: words.append(leword[level][1]);
        break;
      default: if((h!=0)||((h==0)&&(level==1)))  //если трехзначный сегмент = 0, то добавл€ть нужно только "рублей"
        words.append(leword[level][2]);
    }
    long nextnum = num/1000;
    if(nextnum>0) {
      return (num2words(nextnum, level+1) + " " + words.toString()).trim();
    } else {
      return words.toString().trim();
    }
  }

  //функци€ преобразовани€ вещественного числа в рубли-копейки
  //при значении money более 50-70 триллионов рублей начинает искажать копейки, осторожней при работе такими суммами
  public static String inwords(double money) {
    if (money<0.0) return "error: отрицательное значение";
    String sm = String.format("%.2f", money);
    String skop = sm.substring(sm.length()-2, sm.length());    //значение копеек в строке
    int iw;
    if(skop.substring(1).equals("1")) {
      iw=0;
    } else if(skop.substring(1).equals("4")) {
      iw = 1;
    } else if(skop.substring(1).equals("2") || skop.substring(1).equals("3")) {
      iw=0;
    } else {
      iw=2;
    }
    long num = (long) Math.floor(money);
    if (num<1000000000000000l) {
      return num2words(num, 1) + " " + skop + " " + leword[0][iw];
    } else
      return "error: слишком больша€ сумма " + skop + " " + leword[0][iw];
  }

  public static boolean isNull(HttpServletRequest req, String name) {
    return req.getParameter(name) == null || req.getParameter(name).equals("");
  }

  public static Integer getNullInt(HttpServletRequest req, String name) {
    return isNull(req, name) ? null : Integer.parseInt(req.getParameter(name));
  }

  public static List<String> getDateList(Date minDate, Integer counter) {
    List<String> list = new ArrayList<String>();
    for (int i=0;i<counter;i++) {
      Calendar cal = Calendar.getInstance();
      cal.setTime(minDate);
      cal.add(Calendar.DATE, i);
      list.add(dateToString(cal.getTime()).substring(0, 5));
    }
    return list;
  }

  public static List<String> getListDates(Date minDate, Integer counter) {
    List<String> list = new ArrayList<String>();
    for (int i=0;i<counter;i++) {
      Calendar cal = Calendar.getInstance();
      cal.setTime(minDate);
      cal.add(Calendar.DATE, i);
      list.add(dateToString(cal.getTime()));
    }
    return list;
  }

  public static List<Date> getDateArray(Date minDate, Integer counter) {
    List<Date> list = new ArrayList<Date>();
    for (int i=0;i<counter;i++) {
      Calendar cal = Calendar.getInstance();
      cal.setTime(minDate);
      cal.add(Calendar.DATE, i);
      list.add(cal.getTime());
    }
    return list;
  }

  public static boolean isNotNull(HttpServletRequest req, String name) {
    return !Util.nvl(req.getParameter(name)).equals("");
  }

  public static String nvl(HttpServletRequest req, String name, String def) {
    return req.getParameter(name) == null ? def : req.getParameter(name);
  }

  public static String getCurDate() {
    Date d = new Date();
    return (d.getDate() <= 9 ? "0" + d.getDate() : d.getDate()) + "." + (d.getMonth() < 9 ? "0" + (d.getMonth() + 1) : (d.getMonth() + 1)) + "." + (d.getYear() + 1900);
  }

  public static String getCurTime() {
    Date d = new Date();
    return (d.getHours() <= 9 ? "0" + d.getHours() : d.getHours()) + ":" + (d.getMinutes() <= 9 ? "0" + d.getMinutes() : d.getMinutes());
  }

  public static String nvl(String val) {
    return val == null || val.equals("") ? "" : val;
  }

  public static String nvl(String val, String defaultVal) {
    return val == null || val.equals("") ? defaultVal : val;
  }
  public static String nvl(HttpServletRequest req, String name) {
    return get(req, name) == null ? "" : get(req, name);
  }

  public static String getUI(String msgCode) {
    UI ui = new UI();
    return ui.getUI(msgCode);
  }

  public static boolean getMsg(HttpServletRequest request, Model model){
    String str = request.getParameter("msgState");
    if(str != null) {
      if(request.getParameter("msgState").equals("0")) // ќщибка
        model.addAttribute("errorMsg", request.getParameter("msgCode"));
      else if (request.getParameter("msgState").equals("1")) // ”спешно
        model.addAttribute("messageCode", request.getParameter("msgCode"));
      else if (request.getParameter("msgState").equals("3")) { // ”спешно
        model.addAttribute("messageCode", request.getParameter("msgCode"));
        return true;
      }
    }
    return false;
  }

  public static void makeMsg(HttpServletRequest request, Model model) {
    String str = request.getParameter("msgState");
    if(str != null) {
      if(request.getParameter("msgState").equals("0")) // ќщибка
        model.addAttribute("errorMsg", request.getParameter("msgCode"));
      else if (request.getParameter("msgState").equals("1")) // ”спешно
        model.addAttribute("messageCode", request.getParameter("msgCode"));
    }
  }

  private static final String ALGORITHM = "AES";
  private static final String TRANSFORMATION = "AES";

  public static String md5(String password){
    MessageDigest md = null;
    try {
      md = MessageDigest.getInstance("MD5");
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    }
    md.update(password.getBytes());
    byte byteData[] = md.digest();
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < byteData.length; i++)
      sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
    //
    return sb.toString().toUpperCase();
  }

  public static byte[] encrypt( byte [] inputByte){
    return resultCrypto(inputByte, Cipher.ENCRYPT_MODE);
  }

  public static byte [] decrypt(byte [] inputByte){
    return resultCrypto(inputByte, Cipher.DECRYPT_MODE);
  }

  private static byte [] resultCrypto(byte [] inputByte, int cipherType){
    try{
      String key ="PRIVATEKEYSYMBOLS";
      Key secretKey = new SecretKeySpec(key.getBytes(), ALGORITHM);
      Cipher cipher = Cipher.getInstance(TRANSFORMATION);
      cipher.init(cipherType, secretKey);
      return cipher.doFinal(inputByte);
    }
    catch (Exception ex){ System.out.print(ex);}
    return null;
  }

  public static String toUTF8(String str){
    try {
      if(str != null)
        return new String(str.getBytes("UTF-8"), "ISO8859-1");
      else
        return "";
    } catch (UnsupportedEncodingException e) {
      return "";
    }
  }

  public static String dateToString(Date parDate) {
    String str = "";
    if(parDate != null)
      str = new SimpleDateFormat("dd.MM.yyyy").format(parDate);
    return str;
  }

  public static String dateTimeToString(Date parDate) {
    String str = "";
    if(parDate != null)
      str = new SimpleDateFormat("dd.MM.yyyy HH:mm").format(parDate);
    return str;
  }

  public static Date stringToDate(String str) {
    try {
      if(str != null && !str.equals(""))
        return new SimpleDateFormat("dd.MM.yyyy").parse(str);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  public static String get(HttpServletRequest req, String parName) {
     return req.getParameter(parName);
  }

  public static String get(HttpServletRequest req, String parName, String def) {
    return req.getParameter(parName) == null ? def : req.getParameter(parName);
  }

  public static Date getDate(HttpServletRequest req, String dateStr) {
    String date = get(req, dateStr);
    return stringToDate(date);
  }

  public static Date toDate(String str) {
    DateFormat df = new SimpleDateFormat("dd.MM.yyyy");
    Date date = null;
    try {
      if(str != null && !str.equals("")) {
        date = df.parse(str);
        date.setHours(23);
        date.setMinutes(59);
        date.setSeconds(59);
      }
    } catch (ParseException e) {
      e.printStackTrace();
    }
    return date;
  }

  public static String dateDB(String date){
    if(date != null && !date.equals("")){
      Date d = stringToDate(date);
      return new SimpleDateFormat("yyyy-MM-dd").format(d);  // MySQL Version
    } else
      return null;
  }

  public static int getInt(HttpServletRequest req, String name) {
    return Integer.parseInt(req.getParameter(name));
  }

  public static String dateDBBegin(String date) {
    if(date != null && !date.equals("")){
      Date d = stringToDate(date);
      return new SimpleDateFormat("yyyy-MM-dd").format(d) + " 00:00:00";  // MySQL Version
    } else
      return null;
  }

  public static String dateDBEnd(String date) {
    if(date != null && !date.equals("")){
      Date d = stringToDate(date);
      return new SimpleDateFormat("yyyy-MM-dd").format(d) + " 23:59:59";  // MySQL Version
    } else
      return null;
  }

  public static boolean isNotDouble(HttpServletRequest req, String name) {
    try {
      Double d = Double.parseDouble(Util.get(req, name));
      return false;
    } catch (Exception e) {
      return true;
    }
  }

  public static Date dateAddDay(Date date, int count) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(date);
    cal.add(Calendar.DATE, count); //minus number would decrement the days
    return cal.getTime();
  }

  public static String randomLetter(String text) {
    char[] lowerLetter = "abcdefghijklmnopqrstuvwxyz".toCharArray();
    char[] upperLetter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
    char[] original = text.toCharArray();
    StringBuilder finalText = new StringBuilder();
    for (char c : original) {
      if(c == ' ' || c == '.' || c == ',') {
        finalText.append(c);
      } else {
        int rnd = (int) (Math.random() * 25) + 1;
        if (Character.isLowerCase(c)) {
          finalText.append(lowerLetter[rnd]);
        } else {
          finalText.append(upperLetter[rnd]);
        }
      }
    }
    //
    return finalText.toString();
  }

  public static Double getDouble(HttpServletRequest req, String name) {
    return Double.parseDouble(get(req, name));
  }

  public static Double getDouble(HttpServletRequest req, String name, Double def) {
    try {
      if(Util.isNull(req, name)) return def;
      return Double.parseDouble(get(req, name));
    } catch (Exception e) {
      return def;
    }
  }

  public static String err(JSONObject json, String msg) throws JSONException {
    json.put("success", false);
    json.put("msg", msg);
    return json.toString();
  }

  public static boolean getCheckbox(HttpServletRequest req, String name) {
    return req.getParameter(name) != null;
  }

  public static String dateDB(Date date) {
    return dateDB(dateToString(date));
  }
}
