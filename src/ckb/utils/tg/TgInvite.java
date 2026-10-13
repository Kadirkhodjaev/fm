package ckb.utils.tg;

import org.codehaus.jettison.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Приглашение пациента в бот с аккаунта клиники (номер клиники в Telegram).
 * Само сообщение отправляет отдельная программа deploy/tg-sender (Telethon) на этом же сервере,
 * fm вызывает её по адресу invite.url из telegram.properties. Только для тех, кто не смог подключиться по QR.
 */
public class TgInvite {

  public static boolean isEnabled() {
    return !Tg.props().getProperty("invite.url", "").trim().isEmpty();
  }

  /** Номер в международном виде 998XXXXXXXXX или null, если номер неполный */
  public static String phone(String tel) {
    String d = tel == null ? "" : tel.replaceAll("\\D", "");
    if (d.length() == 9) d = "998" + d;
    return d.length() == 12 && d.startsWith("998") ? d : null;
  }

  /** Отправляет текст; ответ программы tg-sender: {"ok": true} или {"ok": false, "error": "..."} */
  public static JSONObject send(String phone, String name, String text) throws Exception {
    JSONObject body = new JSONObject();
    body.put("phone", phone);
    body.put("name", name);
    body.put("text", text);
    String base = Tg.props().getProperty("invite.url", "").trim();
    HttpURLConnection c = (HttpURLConnection) new URL(base + "/send").openConnection();
    try {
      c.setConnectTimeout(5000);
      c.setReadTimeout(60000);
      c.setRequestMethod("POST");
      c.setDoOutput(true);
      c.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
      c.setRequestProperty("X-Token", Tg.props().getProperty("invite.token", "").trim());
      try (OutputStream os = c.getOutputStream()) {
        os.write(body.toString().getBytes("UTF-8"));
      }
      int code = c.getResponseCode();
      InputStream is = code >= 400 ? c.getErrorStream() : c.getInputStream();
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      if (is != null) {
        try (InputStream in = is) {
          byte[] buf = new byte[4096];
          int n;
          while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
        }
      }
      return new JSONObject(out.toString("UTF-8"));
    } finally {
      c.disconnect();
    }
  }

  /** Понятный текст ошибки для медсестры */
  public static String errorText(String code, String detail) {
    if ("NOT_ON_TELEGRAM".equals(code)) return "У пациента нет Telegram на этом номере или поиск по номеру закрыт в его настройках. Используйте QR-код.";
    if ("LIMIT_DAY".equals(code)) return "Дневной лимит приглашений (" + detail + ") исчерпан, попробуйте завтра или используйте QR-код.";
    if ("LIMIT_WAIT".equals(code)) return "Слишком часто. Подождите " + detail + " с и повторите.";
    if ("FLOOD_WAIT".equals(code)) return "Telegram временно ограничил отправку, подождите " + detail + " с.";
    if ("PEER_FLOOD".equals(code)) return "Telegram ограничил аккаунт клиники для сообщений незнакомым номерам. Пока используйте QR-код.";
    if ("BAD_PHONE".equals(code)) return "Неверный номер телефона.";
    if ("FORBIDDEN".equals(code)) return "Неверный invite.token в telegram.properties.";
    return "Не удалось отправить: " + code + (detail == null || detail.isEmpty() ? "" : " (" + detail + ")");
  }
}
