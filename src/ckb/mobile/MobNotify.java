package ckb.mobile;

import ckb.utils.tg.TgPatientBot;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

/**
 * –ассылка уведомлений пациенту по номеру телефона через несколько каналов.
 *  аналы пробуютс€ по пор€дку, сообщение уходит в первый, который его прин€л: если у номера есть приложение
 * с push - туда, иначе в Telegram-бот пациента. “ак дублей не бывает.
 *  аждое доставленное уведомление записываетс€ в Mob_Notifications (истори€ в приложении).
 */
public class MobNotify {

  public static final String MEDS = "MEDS";
  public static final String FOLLOWUP = "FOLLOWUP";
  public static final String RESULT = "RESULT";
  public static final String ANSWER = "ANSWER";
  public static final String EPICRISIS = "EPICRISIS";

  /**  анал доставки */
  public interface Channel {
    String name();

    /** true - сообщение прин€то каналом */
    boolean send(Connection conn, String phone9, Msg msg) throws Exception;
  }

  /** —ообщение: заголовок и текст дл€ push, html дл€ Telegram */
  public static class Msg {
    public String kind, title, body, html, ref;
    public Integer clientId;

    public Msg(String kind, Integer clientId, String title, String body, String html, String ref) {
      this.kind = kind;
      this.clientId = clientId;
      this.title = title;
      this.body = body;
      this.html = html;
      this.ref = ref;
    }
  }

  /**
   * Push через Firebase Cloud Messaging. ѕока у клиники нет проекта Firebase, канал ничего не отправл€ет и
   * сообщение уходит в Telegram.  огда по€витс€ json сервисного аккаунта (fcm.service.account в mobile.properties),
   * здесь нужно отправить сообщение на каждый fcm_token номера из Mob_Devices (FCM HTTP v1).
   */
  public static class PushChannel implements Channel {
    public String name() {
      return "PUSH";
    }

    public boolean send(Connection conn, String phone9, Msg msg) throws Exception {
      if (MobConfig.get("fcm.service.account", "").isEmpty()) return false;
      List<Map<String, Object>> devices = MobDb.rows(conn, "Select fcm_token From Mob_Devices Where phone9 = ?", phone9);
      if (devices.isEmpty()) return false;
      // шаг Push: отправка через FCM HTTP v1 (нужен проект Firebase клиники)
      return false;
    }
  }

  /** Ѕот пациента: чат найден по номеру (Tg_Phone_Chats, номер пациент отправил боту сам) */
  public static class TelegramChannel implements Channel {
    public String name() {
      return "TG";
    }

    public boolean send(Connection conn, String phone9, Msg msg) throws Exception {
      if (!TgPatientBot.isEnabled() || msg.html == null) return false;
      Long chat = chatOf(conn, phone9);
      return chat != null && TgPatientBot.send(chat, msg.html, null);
    }
  }

  private static final Channel[] CHANNELS = {new PushChannel(), new TelegramChannel()};

  /** „ат бота пациента дл€ номера или null */
  public static Long chatOf(Connection conn, String phone9) {
    try {
      Object v = MobDb.value(conn, "Select chat_id From Tg_Phone_Chats Where phone9 = ?", phone9);
      return v == null ? null : ((Number) v).longValue();
    } catch (Exception e) {
      // таблицы ещЄ нет: бот пациента ни разу не запускалс€
      return null;
    }
  }

  /** Ќомер выключил уведомлени€ этого вида или по этому клиенту (настройки приложени€) */
  public static boolean isOff(Connection conn, String phone9, String kind, Integer clientId) throws Exception {
    if (clientId != null && MobDb.count(conn, "Select Count(*) From Mob_Client_Off Where phone9 = ? And client_id = ?", phone9, clientId) > 0) return true;
    Map<String, Object> s = MobDb.row(conn, "Select meds, results From Mob_Settings Where phone9 = ?", phone9);
    if (s == null) return false;
    if ((MEDS.equals(kind) || FOLLOWUP.equals(kind)) && "N".equals(MobDb.s(s, "meds"))) return true;
    return RESULT.equals(kind) && "N".equals(MobDb.s(s, "results"));
  }

  /** ќтправить номеру. ¬озвращает канал ("PUSH"/"TG") или null, если не доставлено / выключено */
  public static String deliver(Connection conn, String phone9, Msg msg) {
    try {
      MobTables.init(conn);
      if (isOff(conn, phone9, msg.kind, msg.clientId)) return null;
      for (Channel c : CHANNELS) {
        boolean ok;
        try {
          ok = c.send(conn, phone9, msg);
        } catch (Exception e) {
          System.err.println("MOB_NOTIFY_ERR " + c.name() + " " + phone9 + ": " + e.getMessage());
          ok = false;
        }
        if (!ok) continue;
        MobDb.exec(conn, "Insert Into Mob_Notifications (phone9, client_id, kind, title, body, ref, channel, created) Values (?, ?, ?, ?, ?, ?, ?, Now())",
          phone9, msg.clientId, msg.kind, cut(ckb.utils.tg.Tg.bmp(msg.title), 255), ckb.utils.tg.Tg.bmp(msg.body), cut(msg.ref, 64), c.name());
        return c.name();
      }
    } catch (Exception e) {
      System.err.println("MOB_NOTIFY_ERR " + phone9 + ": " + e.getMessage());
    }
    return null;
  }

  private static String cut(String s, int n) {
    return s == null || s.length() <= n ? s : s.substring(0, n);
  }
}
