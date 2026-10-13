package ckb.mobile;

/**
 * SMS для кода входа. Провайдер ещё не выбран (Eskiz, Playmobile и т.д.): пока ничего не отправляет,
 * и войти в приложение могут только те, чей номер зарегистрирован в Telegram-боте пациента.
 * Когда провайдер будет выбран: sms.provider и его ключи в mobile.properties, отправка здесь.
 */
public class SmsSender {

  public static boolean isEnabled() {
    return !MobConfig.get("sms.provider", "").isEmpty();
  }

  /** phone - номер полностью (998XXXXXXXXX). true - SMS принята провайдером */
  public static boolean send(String phone, String text) {
    if (!isEnabled()) return false;
    System.err.println("MOB_SMS: провайдер " + MobConfig.get("sms.provider", "") + " ещё не подключён");
    return false;
  }
}
