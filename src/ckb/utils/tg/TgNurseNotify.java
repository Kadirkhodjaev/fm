package ckb.utils.tg;

import ckb.domains.med.patient.Patients;
import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Уведомления постовым медсёстрам ОТДЕЛЕНИЯ ПАЦИЕНТА (роль 11, Users.Dept_Id = отделение пациента):
 *   DIET_CHANGE - лечащий врач поменял стол питания (CLv.saveEat)
 *   TABS_CHANGE - лечащий врач добавил или изменил назначение таблеток (CLv.patientDrugSave, тип 15)
 * Отправка в отдельном потоке, чтобы не задерживать сохранение.
 */
public class TgNurseNotify {

  private static final int NURSE_ROLE = 11;

  private static String e(int cp) {
    return new String(Character.toChars(cp));
  }

  /** Шапка сообщения: ФИО, ИБ, палата */
  private static String patientLine(Patients p) {
    String room = p.getPalata() != null ? p.getPalata() : (p.getRoom() != null ? p.getRoom().getName() : null);
    return Tg.esc((Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename())).trim()) +
      (p.getYearNum() != null ? ", ИБ №" + p.getYearNum() : "") +
      (room != null ? "\nПалата: " + Tg.esc(room) : "");
  }

  /** Стол питания изменён. fromDate - первая изменённая дата (dd.MM.yyyy), meals - сколько приёмов пищи изменено */
  public static void dietChanged(Patients p, String oldTable, String newTable, String fromDate, int meals, String doctor) {
    if (!Tg.isEnabled() || p == null || p.getDept() == null) return;
    String msg = e(0x1F37D) + " <b>Изменён стол питания</b>\n" + patientLine(p) + "\n\n" +
      (oldTable == null || oldTable.isEmpty() ? "Назначен: <b>" + Tg.esc(newTable) + "</b>"
        : Tg.esc(oldTable) + " " + e(0x2192) + " <b>" + Tg.esc(newTable) + "</b>") +
      "\nС " + fromDate + (meals > 1 ? " (" + meals + " приёмов пищи)" : "") +
      (doctor != null && !doctor.isEmpty() ? "\nВрач: " + Tg.esc(doctor) : "");
    send(p.getDept().getId(), Tg.DIET_CHANGE, msg);
  }

  /** Назначение таблеток добавлено или изменено: состав, время приёма и период берутся из базы после сохранения */
  public static void tabletsChanged(final Patients p, final int patientDrugId, final boolean isNew, final String doctor) {
    if (!Tg.isEnabled() || p == null || p.getDept() == null) return;
    final String head = e(0x1F48A) + " <b>" + (isNew ? "Новое назначение: таблетки" : "Изменено назначение: таблетки") + "</b>\n" + patientLine(p) + "\n\n";
    final int dept = p.getDept().getId();
    Thread t = new Thread(new Runnable() {
      @Override
      public void run() {
        Connection conn = DB.getConnection();
        if (conn == null) return;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
          ps = conn.prepareStatement(
            "Select d.dateBegin, d.dateEnd, d.note, d.tabletType, d.morningTime, d.noonTime, d.eveningTime, " +
            "       d.morningTimeBefore, d.morningTimeAfter, d.noonTimeBefore, d.noonTimeAfter, d.eveningTimeBefore, d.eveningTimeAfter, " +
            "       (Select Group_Concat(Concat(IfNull(n.name, r.name), If(r.source = 'own', ' (свой)', '')) Separator ', ') " +
            "          From patient_drug_rows r Left Join Drug_s_Names n On n.id = r.drug_Id Where r.patientDrug_Id = d.id) names " +
            "  From patient_drugs d Where d.id = ?");
          ps.setInt(1, patientDrugId);
          rs = ps.executeQuery();
          if (!rs.next()) return;
          StringBuilder b = new StringBuilder(head);
          b.append("<b>").append(Tg.esc(Util.nvl(rs.getString("names")))).append("</b>\n");
          StringBuilder when = new StringBuilder();
          String[][] slots = {{"morning", "утро"}, {"noon", "обед"}, {"evening", "вечер"}};
          for (String[] s : slots) {
            if (!rs.getBoolean(s[0] + "Time")) continue;
            if (when.length() > 0) when.append(", ");
            when.append(s[1]);
            if (rs.getBoolean(s[0] + "TimeBefore")) when.append(" до еды");
            else if (rs.getBoolean(s[0] + "TimeAfter")) when.append(" после еды");
          }
          if (when.length() > 0) b.append("Приём: ").append(when).append("\n");
          if (rs.getTimestamp("dateBegin") != null)
            b.append("Период: ").append(Util.dateToString(rs.getTimestamp("dateBegin")))
              .append(rs.getTimestamp("dateEnd") != null ? " – " + Util.dateToString(rs.getTimestamp("dateEnd")) : "").append("\n");
          if (!Util.nvl(rs.getString("note")).trim().isEmpty()) b.append("Примечание: ").append(Tg.esc(rs.getString("note").trim())).append("\n");
          if (doctor != null && !doctor.isEmpty()) b.append("Врач: ").append(Tg.esc(doctor));
          DB.done(rs);
          DB.done(ps);
          rs = null;
          ps = null;
          Tg.notifyUsers(conn, nurses(conn, dept), Tg.TABS_CHANGE, b.toString().trim());
        } catch (Exception ex) {
          ex.printStackTrace();
        } finally {
          DB.done(conn, ps, rs);
        }
      }
    }, "tg-nurse-tabs");
    t.setDaemon(true);
    t.start();
  }

  private static void send(final int dept, final String kind, final String msg) {
    Thread t = new Thread(new Runnable() {
      @Override
      public void run() {
        Connection conn = DB.getConnection();
        if (conn == null) return;
        try {
          Tg.notifyUsers(conn, nurses(conn, dept), kind, msg);
        } catch (Exception ex) {
          ex.printStackTrace();
        } finally {
          DB.done(conn);
        }
      }
    }, "tg-nurse-notify");
    t.setDaemon(true);
    t.start();
  }

  /** Активные постовые этого отделения */
  static List<Integer> nurses(Connection conn, int dept) throws Exception {
    return Tg.ids(conn,
      "Select Distinct u.id From Users u Join User_Roles ur On ur.users_id = u.id " +
      " Where u.active = 1 And ur.roles_id = " + NURSE_ROLE + " And u.Dept_Id = ?", dept);
  }
}
