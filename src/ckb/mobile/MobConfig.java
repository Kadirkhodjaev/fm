package ckb.mobile;

import java.io.InputStream;
import java.util.Properties;

/**
 * Настройки приложения из mobile.properties (и времена бота пациента из telegram.properties).
 * Файлы перечитываются раз в минуту, перезапуск не нужен.
 */
public class MobConfig {

  private static volatile Properties mobile, telegram;
  private static volatile long loaded = 0;

  private static void load() {
    if (System.currentTimeMillis() - loaded < 60000 && mobile != null) return;
    mobile = read("mobile.properties");
    telegram = read("telegram.properties");
    loaded = System.currentTimeMillis();
  }

  private static Properties read(String name) {
    Properties p = new Properties();
    try (InputStream in = MobConfig.class.getClassLoader().getResourceAsStream(name)) {
      if (in != null) p.load(in);
    } catch (Exception e) {
      System.err.println("MOB_CONFIG_ERR " + name + ": " + e.getMessage());
    }
    return p;
  }

  public static String get(String key, String def) {
    load();
    String v = mobile.getProperty(key);
    return v == null || v.trim().isEmpty() ? def : v.trim();
  }

  public static int getInt(String key, int def) {
    try {
      return Integer.parseInt(get(key, String.valueOf(def)));
    } catch (Exception e) {
      return def;
    }
  }

  public static boolean isDebugCode() {
    return "Y".equalsIgnoreCase(get("mobile.debug.code", "N"));
  }

  /** Время стационара (как в боте пациента): patient.time.morning и т.д. */
  public static String patientTime(String key, String def) {
    load();
    String v = telegram.getProperty("patient.time." + key);
    return v == null || v.trim().isEmpty() ? def : v.trim();
  }

  /** "08:00" -> минуты от полуночи; при ошибке - def */
  public static int minutes(String hhmm, String def) {
    try {
      String[] p = hhmm.trim().split(":");
      return Integer.parseInt(p[0].trim()) * 60 + (p.length > 1 ? Integer.parseInt(p[1].trim()) : 0);
    } catch (Exception e) {
      return def == null ? 0 : minutes(def, null);
    }
  }

  /** Время в виде "HH:mm" или null, если строка не время */
  public static String normTime(String v) {
    if (v == null) return null;
    String t = v.trim();
    if (!t.matches("\\d{1,2}:\\d{2}")) return null;
    int h = Integer.parseInt(t.split(":")[0]), m = Integer.parseInt(t.split(":")[1]);
    if (h > 23 || m > 59) return null;
    return String.format("%02d:%02d", h, m);
  }
}
