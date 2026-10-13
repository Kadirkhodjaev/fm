package ckb.utils.tg;

import ckb.utils.DB;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.sql.Connection;

/** Каждые 30 секунд: принимает сообщения бота и проверяет правила уведомлений. */
@DisallowConcurrentExecution
public class TgJob implements Job {

  // правила уведомлений; новое правило - одна строка здесь
  private static final TgTrigger[] TRIGGERS = {
    new TgSickLeaveRepeat()
  };

  @Override
  public void execute(JobExecutionContext ctx) {
    // лечение дома после выписки: напоминания в приложение (push) или в бот пациента
    Connection home = DB.getConnection();
    if (home != null) {
      try {
        ckb.mobile.HomeReminders.run(home);
      } finally {
        DB.done(home);
      }
    }
    if (!Tg.isEnabled() && !TgPatientBot.isEnabled()) return;
    Connection conn = DB.getConnection();
    if (conn == null) return;
    try {
      boolean firstRun = Tg.initTables(conn);
      // сообщения ботов принимают фоновые потоки без задержки, здесь только следим, что они живы
      TgPoller.ensureStarted();
      // бот пациентов: напоминания по времени
      if (TgPatientBot.isEnabled()) {
        try {
          TgPatientBot.reminders(conn);
        } catch (Exception e) {
          System.err.println("TG_PATIENT_REMIND_ERR: " + e.getMessage());
        }
      }
      if (!Tg.isEnabled()) return;
      for (TgTrigger t : TRIGGERS) {
        try {
          t.run(conn, firstRun);
        } catch (Exception e) {
          System.err.println("TG_TRIGGER_ERR " + t.getClass().getSimpleName() + ": " + e.getMessage());
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
    }
  }
}
