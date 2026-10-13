package ckb.utils.tg;

/**
 * Приём сообщений ботов без задержки: два фоновых потока (бот сотрудников и бот пациентов) держат
 * долгий запрос getUpdates к Telegram. Telegram отвечает сразу, как пользователь что-то написал или нажал,
 * поэтому бот отвечает за 1-2 секунды, а не раз в 30 секунд по расписанию.
 * Потоки запускает TgJob (и перезапускает, если поток вдруг завершился).
 */
public class TgPoller {

  private static final int WAIT_SEC = 25;
  private static Thread staff, patient;
  /** Приложение останавливается (TgShutdownListener): потоки больше не опрашивают Telegram и не запускаются заново */
  private static volatile boolean stopped = false;

  public static synchronized void stop() {
    stopped = true;
    if (staff != null) staff.interrupt();
    if (patient != null) patient.interrupt();
  }

  static synchronized void ensureStarted() {
    if (stopped) return;
    if (staff == null || !staff.isAlive()) staff = start("tg-staff-poller", false);
    if (patient == null || !patient.isAlive()) patient = start("tg-patient-poller", true);
  }

  private static Thread start(String name, final boolean isPatient) {
    Thread t = new Thread(new Runnable() {
      @Override
      public void run() {
        while (!stopped && !Thread.currentThread().isInterrupted()) {
          try {
            boolean on = isPatient ? TgPatientBot.isEnabled() : Tg.isEnabled();
            if (!on) {
              Thread.sleep(30000);
              continue;
            }
            if (isPatient) TgPatientBot.poll(WAIT_SEC); else Tg.poll(WAIT_SEC);
          } catch (InterruptedException e) {
            return;
          } catch (Exception e) {
            System.err.println((isPatient ? "TG_PATIENT_POLL_ERR: " : "TG_POLL_ERR: ") + e.getMessage());
            try {
              Thread.sleep(5000); // нет сети или Telegram недоступен - пробуем снова чуть позже
            } catch (InterruptedException ie) {
              return;
            }
          }
        }
      }
    }, name);
    t.setDaemon(true);
    t.start();
    return t;
  }
}
