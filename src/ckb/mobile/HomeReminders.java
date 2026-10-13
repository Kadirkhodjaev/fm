package ckb.mobile;

import ckb.utils.tg.Tg;

import java.sql.Connection;
import java.util.*;

/**
 * Напоминания лечения дома (каждые 30 с из TgJob): одно сообщение на каждое время приёма со списком препаратов,
 * пока курс не закончится, и напоминание о повторном приёме за день. Отмечать приём не нужно.
 *
 * Получатели: номер из карточки клиента и номер из истории болезни (последние 9 цифр).
 * Канал: push в приложение, если оно есть, иначе бот пациента (MobNotify).
 */
public class HomeReminders {

  public static void run(Connection conn) {
    try {
      MobTables.init(conn);
      Calendar now = Calendar.getInstance();
      int min = now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE);
      Date today = MobDb.day(now.getTime());
      int dayNum = MobDb.dayNum(today);
      // выписанные пациенты, у которых курс ещё идёт или повторный приём впереди
      List<Map<String, Object>> stays = MobDb.rows(conn,
        "Select p.id, p.client_Id, p.tel, p.name, p.Date_End, c.tel client_tel, c.name client_name " +
        "  From Patients p Left Join Crm_Clients c On c.id = p.client_Id " +
        " Where p.state != 'LV' And p.Date_End Is Not Null And p.Date_End >= ? " +
        "   And (Exists (Select 1 From Lv_Home_Drugs h Where h.patient_id = p.id) Or Exists (Select 1 From Lv_Home_Plans h Where h.patient_id = p.id))",
        MobDb.addDays(today, -366));
      int followAt = MobConfig.minutes(MobConfig.get("home.time.followup", "10:00"), "10:00");
      for (Map<String, Object> s : stays) {
        int pid = MobDb.i(s, "id");
        try {
          Integer clientId = s.get("client_Id") == null ? null : MobDb.i(s, "client_Id");
          String name = MobDb.s(s, "client_name").isEmpty() ? MobDb.s(s, "name") : MobDb.s(s, "client_name");
          Set<String> phones = new LinkedHashSet<>();
          String a = MobDb.tail9(MobDb.s(s, "client_tel")), b = MobDb.tail9(MobDb.s(s, "tel"));
          if (a != null) phones.add(a);
          if (b != null) phones.add(b);
          if (phones.isEmpty()) continue;
          List<HomePlan.Drug> drugs = HomePlan.drugs(conn, pid);
          for (String phone9 : phones) {
            String[] times = HomePlan.slotTimes(conn, phone9);
            for (int k = 0; k < 3; k++) {
              if (!inWindow(min, MobConfig.minutes(times[k], "08:00"))) continue;
              List<HomePlan.Drug> now0 = new ArrayList<>();
              for (HomePlan.Drug d : drugs) if (d.in(HomePlan.SLOTS[k]) && d.activeOn(today)) now0.add(d);
              if (now0.isEmpty() || !once(conn, "HOME_" + HomePlan.SLOTS[k], pid, phone9, dayNum)) continue;
              MobNotify.deliver(conn, phone9, medsMsg(clientId, name, times[k], HomePlan.slotName(HomePlan.SLOTS[k]), now0, pid));
            }
            Object[] f = HomePlan.followup(conn, pid);
            if (f != null && inWindow(min, followAt) && MobDb.daysBetween(today, (Date) f[0]) == 1 && once(conn, "FOLLOWUP", pid, phone9, 0)) {
              String doctor = (String) f[1];
              String title = name + ": завтра повторный приём";
              String body = (doctor.isEmpty() ? "Повторный приём" : "Повторный приём: " + doctor) + ". Запишитесь в регистратуре клиники.";
              MobNotify.deliver(conn, phone9, new MobNotify.Msg(MobNotify.FOLLOWUP, clientId, title, body,
                new String(Character.toChars(0x1F4C5)) + " <b>" + Tg.esc(title) + "</b>\n" + Tg.esc(body), "stay:" + pid));
            }
          }
        } catch (Exception e) {
          System.err.println("MOB_HOME_REMIND_ERR patient=" + pid + ": " + e.getMessage());
        }
      }
    } catch (Exception e) {
      System.err.println("MOB_HOME_REMIND_ERR: " + e.getMessage());
    }
  }

  private static MobNotify.Msg medsMsg(Integer clientId, String name, String time, String slot, List<HomePlan.Drug> drugs, int pid) {
    String title = name + ": время принять препараты";
    StringBuilder body = new StringBuilder(time + " · ");
    StringBuilder html = new StringBuilder(new String(Character.toChars(0x1F48A)) + " <b>" + Tg.esc(title) + "</b>\n" + slot + ", " + time + "\n");
    for (int k = 0; k < drugs.size(); k++) {
      HomePlan.Drug d = drugs.get(k);
      String food = HomePlan.foodText(d.food);
      body.append(k == 0 ? "" : ", ").append(d.name);
      html.append("• ").append(Tg.esc(d.name)).append(d.dose.isEmpty() && food.isEmpty() ? "" : " <i>(" + Tg.esc((d.dose + (d.dose.isEmpty() || food.isEmpty() ? "" : ", ") + food)) + ")</i>").append("\n");
    }
    html.append("\nЛечение дома после выписки. Отмечать приём не нужно.");
    return new MobNotify.Msg(MobNotify.MEDS, clientId, title, body.toString(), html.toString(), "home:" + pid);
  }

  /** Время наступило и прошло не больше 2 часов (сервер был выключен - устаревшее не шлём) */
  private static boolean inWindow(int nowMin, int at) {
    return nowMin >= at && nowMin < at + 120;
  }

  /** Отмечает отправку; false - уже отправляли */
  private static boolean once(Connection conn, String kind, int refId, String phone9, int day) throws Exception {
    return MobDb.exec(conn, "Insert Ignore Into Mob_Sent (kind, ref_id, phone9, day, sent_date) Values (?, ?, ?, ?, Now())", kind, refId, phone9, day) > 0;
  }
}
