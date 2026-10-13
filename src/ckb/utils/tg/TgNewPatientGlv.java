package ckb.utils.tg;

import ckb.domains.med.patient.Patients;
import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Главному врачу: приёмный врач подтвердил нового пациента стационара (CPatient.confirm, состояние CZG),
 * пациент ждёт назначения лечащего врача. Получают активные пользователи с ролью «Главный врач» (6)
 * и отмеченной галочкой «Главный врач» в реквизитах пользователя (Users.glb).
 * Одно уведомление на пару пациент + главный врач, повторное подтверждение его не дублирует.
 */
public class TgNewPatientGlv {

  public static void send(Patients p, String fromDoctor) {
    if (!Tg.isEnabled() || p == null || p.getId() == null) return;
    final int patientId = p.getId();
    final String msg;
    try {
      String room = p.getPalata() != null ? p.getPalata() : (p.getRoom() != null ? p.getRoom().getName() : null);
      msg = new String(Character.toChars(0x1F195)) + " <b>Новый пациент стационара</b>\n" +
        Tg.esc((Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename())).trim()) +
        (p.getBirthyear() != null && p.getBirthyear() != 0 ? ", " + p.getBirthyear() + " г.р." : "") + "\n" +
        (p.getYearNum() != null ? "ИБ №: " + p.getYearNum() + "\n" : "") +
        (p.getDept() != null ? "Отделение: " + Tg.esc(p.getDept().getName()) + "\n" : "") +
        (room != null ? "Палата: " + Tg.esc(room) + "\n" : "") +
        (fromDoctor != null && !fromDoctor.isEmpty() ? "Приёмный врач: " + Tg.esc(fromDoctor) + "\n" : "") +
        "Поступил: " + Util.dateToString(p.getDateBegin()) + "\n" +
        "Ждёт назначения лечащего врача";
    } catch (Exception e) {
      e.printStackTrace();
      return;
    }
    Thread t = new Thread(new Runnable() {
      @Override
      public void run() {
        Connection conn = DB.getConnection();
        if (conn == null) return;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
          Tg.initTables(conn);
          List<Integer> users = new ArrayList<Integer>();
          ps = conn.prepareStatement("Select Distinct u.id From User_Roles r Join Users u On u.id = r.Users_Id Where r.Roles_Id = 6 And u.glb = 1 And u.Active = 1");
          rs = ps.executeQuery();
          while (rs.next()) users.add(rs.getInt(1));
          for (Integer u : users)
            if (Tg.markEvent(conn, Tg.GLV_NEW, patientId, u)) Tg.notify(conn, u, Tg.GLV_NEW, msg);
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          DB.done(conn, ps, rs);
        }
      }
    }, "tg-glv-notify");
    t.setDaemon(true);
    t.start();
  }
}
