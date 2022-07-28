package ckb.utils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 22:52
 * To change this template use File | Settings | File Templates.
 */
public class Req {

  public static String nvl(String val) {
    return val == null || val.equals("") ? "" : val;
  }

  public static String nvl(String val, String defaultVal) {
    return val == null || val.equals("") ? defaultVal : val;
  }

  public static String get(HttpServletRequest request, String parName) {
    return nvl(request.getParameter(parName));
  }

  public static boolean isNull(HttpServletRequest request, String parName) {
    return nvl(request.getParameter(parName)).equals("");
  }

  public static String get(HttpServletRequest request, String parName, String defaultValue) {
    return nvl(request.getParameter(parName), defaultValue);
  }

  public static Integer getInt(HttpServletRequest request, String parName) {
    return Integer.parseInt(nvl(request.getParameter(parName), "0"));
  }

  public static Date getDate(HttpServletRequest request, String parName) {
    return Util.stringToDate(request.getParameter(parName));
  }
}
