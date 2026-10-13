package ckb.mobile;

import ckb.utils.tg.TgPatientBot;
import org.codehaus.jettison.json.JSONObject;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.util.Map;

/**
 * Вход в приложение по номеру телефона и коду из 4 цифр.
 *
 * Код уходит в Telegram-бот пациента, если номер там зарегистрирован (Tg_Phone_Chats), иначе по SMS (провайдер не выбран).
 * Защита: не больше 3 кодов в час на номер, код живёт 5 минут, 5 неверных попыток за час блокируют номер на час.
 * После входа: access-токен на 1 час и refresh-токен на 90 дней; в базе только их SHA-256.
 */
public class MobAuth {

  private static final SecureRandom RND = new SecureRandom();

  /** Сессия запроса: номер (9 цифр) и id сессии */
  public static class Who {
    public final String phone9;
    public final int sessionId;
    public final String device;

    Who(String phone9, int sessionId, String device) {
      this.phone9 = phone9;
      this.sessionId = sessionId;
      this.device = device;
    }
  }

  /** Ошибка API с HTTP-кодом и текстом для пациента */
  public static class ApiError extends Exception {
    public final int status;
    public final String code;

    public ApiError(int status, String code, String message) {
      super(message);
      this.status = status;
      this.code = code;
    }
  }

  public static String sha256(String s) throws Exception {
    byte[] h = MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8"));
    StringBuilder b = new StringBuilder();
    for (byte x : h) b.append(String.format("%02x", x));
    return b.toString();
  }

  /** Случайный токен: 32 байта в hex */
  public static String token() {
    byte[] b = new byte[32];
    RND.nextBytes(b);
    StringBuilder s = new StringBuilder();
    for (byte x : b) s.append(String.format("%02x", x));
    return s.toString();
  }

  /** Номер из ввода пациента: 9 последних цифр; принимаем "998 90 123 45 67", "+998...", "90 123 45 67" */
  public static String phone9(String input) throws ApiError {
    String d = input == null ? "" : input.replaceAll("\\D", "");
    if (d.length() == 12 && d.startsWith("998")) return d.substring(3);
    if (d.length() == 9) return d;
    throw new ApiError(400, "bad_phone", "Введите номер в формате 998 XX XXX XX XX.");
  }

  public static String format(String phone9) {
    return "998 " + phone9.substring(0, 2) + " " + phone9.substring(2, 5) + " " + phone9.substring(5, 7) + " " + phone9.substring(7);
  }

  private static boolean locked(Connection conn, String phone9) throws Exception {
    return MobDb.count(conn, "Select Count(*) From Mob_Auth_Fails Where phone9 = ? And created > Date_Sub(Now(), Interval 1 Hour)", phone9)
      >= MobConfig.getInt("mobile.code.fails.per.hour", 5);
  }

  // ---------- POST /auth/code ----------

  public static JSONObject sendCode(Connection conn, String phoneInput) throws Exception {
    MobTables.init(conn);
    String p9 = phone9(phoneInput);
    if (locked(conn, p9)) throw new ApiError(429, "locked", "Слишком много неверных кодов. Попробуйте через час.");
    if (MobData.clientIds(conn, p9, true).isEmpty())
      throw new ApiError(404, "not_found", "Номер не найден. Обратитесь в регистратуру клиники.");
    if (MobDb.count(conn, "Select Count(*) From Mob_Codes Where phone9 = ? And created > Date_Sub(Now(), Interval 1 Hour)", p9)
      >= MobConfig.getInt("mobile.code.per.hour", 3))
      throw new ApiError(429, "too_many", "Коды уже отправлены 3 раза за час. Попробуйте позже.");
    // повторная отправка не чаще раза в минуту
    if (MobDb.count(conn, "Select Count(*) From Mob_Codes Where phone9 = ? And created > Date_Sub(Now(), Interval 60 Second)", p9) > 0)
      throw new ApiError(429, "wait", "Код уже отправлен. Новый можно запросить через минуту.");

    String code = String.format("%04d", RND.nextInt(10000));
    int minutes = MobConfig.getInt("mobile.code.minutes", 5);
    String text = "Код для входа в приложение клиники: <b>" + code + "</b>\nНикому не сообщайте этот код. Он действует " + minutes + " минут.";
    String via;
    JSONObject res = new JSONObject();
    if (MobConfig.isDebugCode()) {
      // только для проверки на своём компьютере: код не отправляется, а возвращается в ответе
      via = "debug";
      res.put("debugCode", code);
    } else {
      Long chat = TgPatientBot.isEnabled() ? MobNotify.chatOf(conn, p9) : null;
      if (chat != null && TgPatientBot.send(chat, text, null)) via = "telegram";
      else if (SmsSender.send("998" + p9, "Kod dlya vhoda: " + code)) via = "sms";
      else {
        String bot = TgPatientBot.isEnabled() ? TgPatientBot.botName() : "";
        throw new ApiError(503, "no_channel", "Код приходит в Telegram-бот клиники" + (bot.isEmpty() ? "" : " @" + bot) +
          ". Откройте бота, нажмите «Отправить мой номер» и запросите код ещё раз.");
      }
    }
    MobDb.exec(conn, "Insert Into Mob_Codes (phone9, code_hash, via, created, expires) Values (?, ?, ?, Now(), Date_Add(Now(), Interval " + minutes + " Minute))",
      p9, sha256(p9 + ":" + code), via);
    res.put("sent", true);
    res.put("via", via);
    res.put("phone", format(p9));
    res.put("expiresIn", minutes * 60);
    res.put("resendIn", 60);
    return res;
  }

  // ---------- POST /auth/verify ----------

  public static JSONObject verify(Connection conn, String phoneInput, String code, String device, String platform) throws Exception {
    MobTables.init(conn);
    String p9 = phone9(phoneInput);
    if (locked(conn, p9)) throw new ApiError(429, "locked", "Слишком много неверных кодов. Попробуйте через час.");
    Map<String, Object> c = MobDb.row(conn,
      "Select id, code_hash From Mob_Codes Where phone9 = ? And used = 'N' And expires > Now() Order By id Desc Limit 1", p9);
    if (c == null) throw new ApiError(401, "expired", "Код устарел. Запросите новый.");
    String given = code == null ? "" : code.replaceAll("\\D", "");
    if (!MessageDigest.isEqual(sha256(p9 + ":" + given).getBytes("UTF-8"), MobDb.s(c, "code_hash").getBytes("UTF-8"))) {
      MobDb.exec(conn, "Insert Into Mob_Auth_Fails (phone9, created) Values (?, Now())", p9);
      int left = MobConfig.getInt("mobile.code.fails.per.hour", 5) -
        MobDb.count(conn, "Select Count(*) From Mob_Auth_Fails Where phone9 = ? And created > Date_Sub(Now(), Interval 1 Hour)", p9);
      throw new ApiError(401, "bad_code", left > 0 ? "Неверный код. Осталось попыток: " + left + "." : "Неверный код. Номер заблокирован на час.");
    }
    MobDb.exec(conn, "Update Mob_Codes Set used = 'Y' Where id = ?", MobDb.i(c, "id"));
    String access = token(), refresh = token();
    int sid = MobDb.insert(conn,
      "Insert Into Mob_Sessions (phone9, access_hash, access_expires, refresh_hash, refresh_expires, device, platform, created, last_seen) " +
      "Values (?, ?, Date_Add(Now(), Interval " + accessMinutes() + " Minute), ?, Date_Add(Now(), Interval " + refreshDays() + " Day), ?, ?, Now(), Now())",
      p9, sha256(access), sha256(refresh), cut(device, 128), cut(platform, 16));
    JSONObject res = tokens(access, refresh);
    res.put("phone", format(p9));
    res.put("clients", MobData.clients(conn, new Who(p9, sid, device)));
    return res;
  }

  private static JSONObject tokens(String access, String refresh) throws Exception {
    JSONObject res = new JSONObject();
    res.put("accessToken", access);
    res.put("accessExpiresIn", accessMinutes() * 60);
    res.put("refreshToken", refresh);
    res.put("refreshExpiresIn", refreshDays() * 24 * 3600);
    return res;
  }

  // ---------- POST /auth/refresh ----------

  public static JSONObject refresh(Connection conn, String refreshToken) throws Exception {
    MobTables.init(conn);
    if (refreshToken == null || refreshToken.isEmpty()) throw new ApiError(401, "no_token", "Войдите заново.");
    Map<String, Object> s = MobDb.row(conn,
      "Select id, phone9 From Mob_Sessions Where refresh_hash = ? And revoked = 'N' And refresh_expires > Now()", sha256(refreshToken));
    if (s == null) throw new ApiError(401, "session_expired", "Сессия завершена. Войдите заново.");
    // номер могли убрать из всех карточек: тогда сессия больше не действует
    if (MobData.clientIds(conn, MobDb.s(s, "phone9"), true).isEmpty()) {
      MobDb.exec(conn, "Update Mob_Sessions Set revoked = 'Y' Where id = ?", MobDb.i(s, "id"));
      throw new ApiError(401, "session_expired", "Номер больше не найден в клинике. Обратитесь в регистратуру.");
    }
    String access = token(), refresh = token();
    MobDb.exec(conn,
      "Update Mob_Sessions Set access_hash = ?, access_expires = Date_Add(Now(), Interval " + accessMinutes() + " Minute), refresh_hash = ?, " +
      "       refresh_expires = Date_Add(Now(), Interval " + refreshDays() + " Day), last_seen = Now() Where id = ?",
      sha256(access), sha256(refresh), MobDb.i(s, "id"));
    JSONObject res = tokens(access, refresh);
    res.put("phone", format(MobDb.s(s, "phone9")));
    return res;
  }

  // ---------- Проверка токена ----------

  public static Who check(Connection conn, String authHeader) throws Exception {
    MobTables.init(conn);
    String t = authHeader == null ? "" : authHeader.trim();
    if (t.regionMatches(true, 0, "Bearer ", 0, 7)) t = t.substring(7).trim();
    if (t.isEmpty()) throw new ApiError(401, "no_token", "Войдите в приложение.");
    Map<String, Object> s = MobDb.row(conn,
      "Select id, phone9, device, access_expires > Now() alive From Mob_Sessions Where access_hash = ? And revoked = 'N'", sha256(t));
    if (s == null) throw new ApiError(401, "session_expired", "Сессия завершена. Войдите заново.");
    if (MobDb.i(s, "alive") == 0) throw new ApiError(401, "token_expired", "Токен устарел.");
    MobDb.exec(conn, "Update Mob_Sessions Set last_seen = Now() Where id = ? And (last_seen Is Null Or last_seen < Date_Sub(Now(), Interval 5 Minute))", MobDb.i(s, "id"));
    return new Who(MobDb.s(s, "phone9"), MobDb.i(s, "id"), MobDb.s(s, "device"));
  }

  public static void logout(Connection conn, Who who) throws Exception {
    MobDb.exec(conn, "Update Mob_Sessions Set revoked = 'Y' Where id = ?", who.sessionId);
    MobDb.exec(conn, "Delete From Mob_Devices Where session_id = ?", who.sessionId);
  }

  /** Завершить все сессии номера (пациент поменял номер или потерял телефон) */
  public static int revokeAll(Connection conn, String phone9) throws Exception {
    MobTables.init(conn);
    MobDb.exec(conn, "Delete From Mob_Devices Where phone9 = ?", phone9);
    return MobDb.exec(conn, "Update Mob_Sessions Set revoked = 'Y' Where phone9 = ? And revoked = 'N'", phone9);
  }

  private static String cut(String s, int n) {
    return s == null || s.length() <= n ? s : s.substring(0, n);
  }

  private static int accessMinutes() {
    return Math.max(5, MobConfig.getInt("mobile.access.minutes", 60));
  }

  private static int refreshDays() {
    return Math.max(1, MobConfig.getInt("mobile.refresh.days", 90));
  }
}
