package ckb.utils.tg;

import ckb.domains.med.lv.LvConsuls;
import ckb.domains.med.patient.Patients;
import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;

/**
 * Консультанту: лечащий врач назначил ему консультацию пациента стационара (модуль Консультации, CLv.consul).
 * Одно уведомление на запрос, повторное сохранение того же запроса его не дублирует.
 */
public class TgLvConsul {

  public static void send(LvConsuls con, Patients p, String fromDoctor) {
    if (!Tg.isEnabled() || con == null || con.getId() == null || con.getLvId() == null || p == null) return;
    final int conId = con.getId();
    final int consultant = con.getLvId();
    final String msg;
    try {
      String room = p.getPalata() != null ? p.getPalata() : (p.getRoom() != null ? p.getRoom().getName() : null);
      msg = new String(Character.toChars(0x1F468)) + new String(Character.toChars(0x200D)) + new String(Character.toChars(0x2695)) +
        " <b>Запрос на консультацию</b>\n" +
        Tg.esc((Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename())).trim()) +
        (p.getBirthyear() != null && p.getBirthyear() != 0 ? ", " + p.getBirthyear() + " г.р." : "") + "\n" +
        (p.getYearNum() != null ? "ИБ №: " + p.getYearNum() + "\n" : "") +
        (p.getDept() != null ? "Отделение: " + Tg.esc(p.getDept().getName()) + "\n" : "") +
        (room != null ? "Палата: " + Tg.esc(room) + "\n" : "") +
        (fromDoctor != null && !fromDoctor.isEmpty() ? "Лечащий врач: " + Tg.esc(fromDoctor) + "\n" : "") +
        (con.getDate() != null && !con.getDate().isEmpty() ? "Дата: " + Tg.esc(con.getDate()) + "\n" : "") +
        (con.getComment() != null && !con.getComment().trim().isEmpty() ? "Комментарий: " + Tg.esc(con.getComment().trim()) : "");
    } catch (Exception e) {
      e.printStackTrace();
      return;
    }
    Thread t = new Thread(new Runnable() {
      @Override
      public void run() {
        Connection conn = DB.getConnection();
        if (conn == null) return;
        try {
          Tg.initTables(conn);
          if (Tg.markEvent(conn, Tg.LV_CONSUL, conId, consultant)) Tg.notify(conn, consultant, Tg.LV_CONSUL, msg.trim());
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          DB.done(conn);
        }
      }
    }, "tg-lv-consul");
    t.setDaemon(true);
    t.start();
  }
}
