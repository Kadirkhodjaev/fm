package ckb.mobile;

import java.sql.Connection;

/**
 * Новые таблицы приложения пациента. Создаются сами при первом обращении (как таблицы бота),
 * старые таблицы fm не меняются.
 */
public class MobTables {

  private static volatile boolean ready = false;

  public static void init(Connection conn) throws Exception {
    if (ready) return;
    synchronized (MobTables.class) {
      if (ready) return;
      // коды входа (хранится только хэш кода)
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Codes (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  code_hash Char(64) Not Null," +
        "  via Varchar(8) Not Null," +
        "  created DateTime Not Null," +
        "  expires DateTime Not Null," +
        "  used Char(1) Not Null Default 'N'," +
        "  Key mob_codes_phone (phone9, created)" +
        ") Default Charset = utf8");
      // неверные коды: 5 за час блокируют номер на час
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Auth_Fails (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  created DateTime Not Null," +
        "  Key mob_auth_fails_phone (phone9, created)" +
        ") Default Charset = utf8");
      // сессии: access-токен (1 час) и refresh-токен (90 дней), хранятся хэши
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Sessions (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  access_hash Char(64) Not Null," +
        "  access_expires DateTime Not Null," +
        "  refresh_hash Char(64) Not Null," +
        "  refresh_expires DateTime Not Null," +
        "  device Varchar(128) Null," +
        "  platform Varchar(16) Null," +
        "  created DateTime Not Null," +
        "  last_seen DateTime Null," +
        "  revoked Char(1) Not Null Default 'N'," +
        "  Unique Key mob_sessions_access (access_hash)," +
        "  Unique Key mob_sessions_refresh (refresh_hash)," +
        "  Key mob_sessions_phone (phone9)" +
        ") Default Charset = utf8");
      // телефоны для push (Firebase)
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Devices (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  session_id Int Not Null," +
        "  phone9 Char(9) Not Null," +
        "  fcm_token Varchar(255) Not Null," +
        "  platform Varchar(16) Null," +
        "  lang Varchar(4) Null," +
        "  updated DateTime Not Null," +
        "  Unique Key mob_devices_token (fcm_token)," +
        "  Key mob_devices_phone (phone9)" +
        ") Default Charset = utf8");
      // настройки номера: язык, время напоминаний лечения дома, какие уведомления включены
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Settings (" +
        "  phone9 Char(9) Not Null Primary Key," +
        "  lang Varchar(4) Null," +
        "  t_morning Varchar(5) Null," +
        "  t_noon Varchar(5) Null," +
        "  t_evening Varchar(5) Null," +
        "  meds Char(1) Not Null Default 'Y'," +
        "  results Char(1) Not Null Default 'Y'," +
        "  updated DateTime Not Null" +
        ") Default Charset = utf8");
      // уведомления по клиенту выключены
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Client_Off (" +
        "  phone9 Char(9) Not Null," +
        "  client_id Int Not Null," +
        "  Primary Key (phone9, client_id)" +
        ") Default Charset = utf8");
      // вопросы лечащему врачу из приложения (ответ врача - следующий шаг, через бот сотрудников)
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Questions (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  patient_id Int Not Null," +
        "  client_id Int Null," +
        "  phone9 Char(9) Not Null," +
        "  session_id Int Null," +
        "  text Text," +
        "  to_user Int Null," +
        "  delivered Char(1) Not Null," +
        "  created DateTime Not Null," +
        "  answer Text Null," +
        "  answered_by Int Null," +
        "  answered_date DateTime Null," +
        "  Key mob_questions_p (patient_id)" +
        ") Default Charset = utf8");
      // история уведомлений (и push, и Telegram)
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Notifications (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  client_id Int Null," +
        "  kind Varchar(16) Not Null," +
        "  title Varchar(255) Not Null," +
        "  body Text," +
        "  ref Varchar(64) Null," +
        "  channel Varchar(8) Not Null," +
        "  created DateTime Not Null," +
        "  Key mob_notifications_phone (phone9, created)" +
        ") Default Charset = utf8");
      // отправленные напоминания: kind + ref_id + номер + день (yyyymmdd), чтобы не было дублей
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Sent (" +
        "  kind Varchar(16) Not Null," +
        "  ref_id Int Not Null," +
        "  phone9 Char(9) Not Null," +
        "  day Int Not Null," +
        "  sent_date DateTime Not Null," +
        "  Primary Key (kind, ref_id, phone9, day)" +
        ") Default Charset = utf8");
      // одноразовые ссылки на PDF результатов и выписку (10 минут)
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_Files (" +
        "  token Char(40) Not Null Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  session_id Int Not Null," +
        "  kind Varchar(8) Not Null," +
        "  ref_id Int Not Null," +
        "  expires DateTime Not Null," +
        "  created DateTime Not Null" +
        ") Default Charset = utf8");
      // журнал просмотров PDF: кто, когда, с какого устройства
      MobDb.exec(conn,
        "Create Table If Not Exists Mob_File_Log (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  phone9 Char(9) Not Null," +
        "  session_id Int Not Null," +
        "  kind Varchar(8) Not Null," +
        "  ref_id Int Not Null," +
        "  device Varchar(128) Null," +
        "  ip Varchar(64) Null," +
        "  created DateTime Not Null," +
        "  Key mob_file_log_ref (kind, ref_id)" +
        ") Default Charset = utf8");
      HomePlan.initTables(conn);
      ready = true;
    }
  }
}
