package ckb.utils.tg;

import ckb.domains.med.patient.Patients;
import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;

/**
 * Лечащему врачу: ему назначен пациент стационара.
 * Вызывается в двух местах: главный врач назначает ЛВ (CReg.lvConf) и переводной эпикриз со сменой ЛВ (SPatientImp.saveEpic).
 * Текст собирается сразу, а отправка идёт в отдельном потоке, чтобы не задерживать сохранение.
 */
public class TgNewPatientLv {

  public static void send(Patients p, Integer lvId, boolean transfer) {
    if (!Tg.isEnabled() || p == null || p.getId() == null || lvId == null) return;
    final int patientId = p.getId();
    final int lv = lvId;
    final String msg;
    try {
      String room = p.getPalata() != null ? p.getPalata() : (p.getRoom() != null ? p.getRoom().getName() : null);
      msg = new String(Character.toChars(0x1F3E5)) + " <b>" + (transfer ? "Новый пациент (перевод)" : "Новый пациент") + "</b>\n" +
        Tg.esc((Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename())).trim()) +
        (p.getBirthyear() != null && p.getBirthyear() != 0 ? ", " + p.getBirthyear() + " г.р." : "") + "\n" +
        (p.getDept() != null ? "Отделение: " + Tg.esc(p.getDept().getName()) + "\n" : "") +
        (room != null ? "Палата: " + Tg.esc(room) + "\n" : "") +
        "Поступил: " + Util.dateToString(p.getDateBegin());
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
          // одно уведомление на пару пациент + врач, повторное сохранение его не дублирует
          if (Tg.markEvent(conn, Tg.LV_NEW, patientId, lv)) Tg.notify(conn, lv, Tg.LV_NEW, msg);
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          DB.done(conn);
        }
      }
    }, "tg-lv-notify");
    t.setDaemon(true);
    t.start();
  }
}
