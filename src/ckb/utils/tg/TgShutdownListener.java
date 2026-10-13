package ckb.utils.tg;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * ѕри остановке приложени€ (перезапуск Tomcat, обновление версии) останавливает потоки ботов TgPoller.
 * »наче стара€ копи€ приложени€ продолжала бы опрашивать Telegram, а Tomcat писал бы предупреждени€ об утечке.
 * ѕодключЄн в WEB-INF/web.xml.
 */
public class TgShutdownListener implements ServletContextListener {

  @Override
  public void contextInitialized(ServletContextEvent event) {
  }

  @Override
  public void contextDestroyed(ServletContextEvent event) {
    TgPoller.stop();
  }
}
