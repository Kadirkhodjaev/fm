package ckb.utils;

import org.springframework.context.i18n.LocaleContextHolder;

import java.util.Locale;
import java.util.ResourceBundle;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
public class UI {

  private Locale locale;
  private ResourceBundle msg = null;
  private Integer id;

  public UI() {
    this.locale = LocaleContextHolder.getLocale();
  }

  //функция вывода текста в зависимости от выбранного языка
  public String getUI(String UIKey) {
    String str = UIKey;
    try {
      loadParams();
      str = msg.getString(UIKey);
      str = new String(str.getBytes("ISO8859-1"), "UTF-8");
    } catch (Exception ex) {
      str = UIKey;
    }
    return str;
  }
  //Вспомогательный метод для получения данных из файла
  public void loadParams() throws Exception {
    msg = ResourceBundle.getBundle("ui", locale);
  }
}
