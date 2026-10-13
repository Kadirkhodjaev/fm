package ckb.utils.tg;

import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.List;

/**
 * Постовым медсёстрам отделения: у пациента с больничным листом наступила дата повторного
 * больничного (5-й день от поступления, как в колонке "Повтор" на странице Больничные).
 * Уведомление уходит один раз, с 8:00 этого дня.
 */
public class TgSickLeaveRepeat implements TgTrigger {

  private static final int NURSE_ROLE = 11; // Постовой
  private static final int FROM_HOUR = 8;

  @Override
  public void run(Connection conn, boolean silent) throws Exception {
    if (!silent && Calendar.getInstance().get(Calendar.HOUR_OF_DAY) < FROM_HOUR) return;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      // окно в 2 дня: если сервер был выключен в сам день повтора, уведомление придёт на следующий
      ps = conn.prepareStatement(
        "Select t.id, t.Dept_Id, t.surname, t.name, t.middlename, t.birthyear, t.Date_Begin, t.palata, r.name room_name, u.fio lv_fio " +
        "  From Patients t " +
        "  Left Join Rooms r On r.id = t.Room_Id " +
        "  Left Join Users u On u.id = t.lv_id " +
        " Where t.sick_leave = 'Y' And t.state = 'LV' And t.Dept_Id Is Not Null " +
        "   And Date(t.Date_Begin) + Interval 4 Day Between CURRENT_DATE() - Interval 1 Day And CURRENT_DATE() " +
        "   And Not Exists (Select 1 From Tg_Events e Where e.kind = 'SICK_REPEAT' And e.ref_id = t.id And e.user_id = 0)");
      rs = ps.executeQuery();
      while (rs.next()) {
        if (!Tg.markEvent(conn, "SICK_REPEAT", rs.getInt("id"), 0) || silent) continue;
        Calendar repeat = Calendar.getInstance();
        repeat.setTime(rs.getTimestamp("Date_Begin"));
        repeat.add(Calendar.DAY_OF_MONTH, 4);
        String room = rs.getString("palata") != null ? rs.getString("palata") : rs.getString("room_name");
        String msg = new String(Character.toChars(0x1F4C4)) + " <b>Повторный больничный лист</b>\n" +
          Tg.esc((Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim()) +
          (rs.getInt("birthyear") != 0 ? ", " + rs.getInt("birthyear") + " г.р." : "") + "\n" +
          (room != null ? "Палата: " + Tg.esc(room) + "\n" : "") +
          (rs.getString("lv_fio") != null ? "Врач: " + Tg.esc(rs.getString("lv_fio")) + "\n" : "") +
          "Поступил: " + Util.dateToString(rs.getTimestamp("Date_Begin")) + ", повтор: " + Util.dateToString(repeat.getTime());
        List<Integer> nurses = Tg.ids(conn,
          "Select Distinct u.id From Users u Join User_Roles ur On ur.users_id = u.id " +
          " Where u.active = 1 And ur.roles_id = " + NURSE_ROLE + " And u.Dept_Id = ?", rs.getInt("Dept_Id"));
        Tg.notifyUsers(conn, nurses, Tg.SICK_REPEAT, msg);
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }
}
