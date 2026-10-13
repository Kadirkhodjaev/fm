package ckb.utils.tg;

import java.sql.Connection;

/**
 * ќдно правило уведомлений. „тобы добавить новое: написать класс с этим интерфейсом
 * и добавить его в список TgJob.TRIGGERS.
 *
 *  аждое событие отмечаетс€ в Tg_Events через Tg.markEvent (уведомление уходит только если отметка нова€),
 * поэтому правило можно спокойно вызывать хоть каждые 30 секунд.
 */
public interface TgTrigger {

  /**
   * @param silent true при самом первом запуске: только отметить уже существующие событи€,
   *               чтобы сотрудникам не пришли уведомлени€ по старым пациентам
   */
  void run(Connection conn, boolean silent) throws Exception;
}
