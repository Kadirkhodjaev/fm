package ckb.utils.tg;

import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Консультанту амбулатории: оплачена услуга консультации (AmbServices.consul = 'Y'), назначенная на него (worker).
 * Вызывается сразу после оплаты в кассе (CCashbox.amb, CAmbCash) и при бесплатном оформлении сотруднику (CAmb).
 * Одно сообщение консультанту на оплату, каждая услуга уведомляется один раз.
 */
public class TgAmbConsul {

  public static void send(AmbPatients pat, List<AmbPatientServices> services) {
    if (!Tg.isEnabled() || pat == null || services == null || services.isEmpty()) return;
    // консультант -> его оплаченные консультации
    final Map<Integer, List<Integer>> ids = new LinkedHashMap<>();
    final Map<Integer, List<String>> names = new LinkedHashMap<>();
    final String head;
    try {
      for (AmbPatientServices s : services) {
        if (s.getId() == null || s.getWorker() == null || s.getService() == null) continue;
        if (!"PAID".equals(s.getState()) || !"Y".equals(s.getService().getConsul())) continue;
        Integer w = s.getWorker().getId();
        if (!ids.containsKey(w)) {
          ids.put(w, new ArrayList<>());
          names.put(w, new ArrayList<>());
        }
        ids.get(w).add(s.getId());
        names.get(w).add(s.getService().getName());
      }
      if (ids.isEmpty()) return;
      head = new String(Character.toChars(0x1FA7A)) + " <b>Амбулаторный пациент на консультацию</b>\n" +
        Tg.esc((Util.nvl(pat.getSurname()) + " " + Util.nvl(pat.getName()) + " " + Util.nvl(pat.getMiddlename())).trim()) +
        (pat.getBirthyear() != null && pat.getBirthyear() != 0 ? ", " + pat.getBirthyear() + " г.р." : "") + "\n";
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
          for (Map.Entry<Integer, List<Integer>> e : ids.entrySet()) {
            int worker = e.getKey();
            StringBuilder list = new StringBuilder();
            for (int i = 0; i < e.getValue().size(); i++) {
              if (Tg.markEvent(conn, Tg.AMB_CONSUL, e.getValue().get(i), worker))
                list.append("• ").append(Tg.esc(names.get(worker).get(i))).append("\n");
            }
            if (list.length() > 0) Tg.notify(conn, worker, Tg.AMB_CONSUL, head + list + "Оплачено: " + Util.getCurDate());
          }
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          DB.done(conn);
        }
      }
    }, "tg-amb-consul");
    t.setDaemon(true);
    t.start();
  }
}
