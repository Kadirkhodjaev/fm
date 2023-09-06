package ckb.dao;

import ckb.domains.GenId;
import ckb.models.Grid;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 24.03.14
 * Time: 11:36
 * Основной родитель всех менеджеров данных
 */
public interface Dao<T extends GenId> {

  //Получение всех записей таблицы
  List<T> getAll();

  //Получение всех записей таблицы
  List<T> getAllOrderedById();

  //Получение строки таблицы по идентификатору
  T get(Integer id);

  //Запись в таблицу строки при добавлении и редактировании
  @Transactional
  void save(T entity);

  //Запись в таблицу строки при добавлении и редактировании и вернуть строку
  @Transactional
  T saveAndReturn(T entity);

  //Запись в таблицу множества строк при добавлении и редактировании
  @Transactional
  void save(Set<T> entities);

  //Удаление из таблицы строки
  void delete(Integer id);

  //Получение результата грида
  //List<Object> getGridList(GridOptions opt);

  //Получение количества колонок грида
  //Integer getGridRowCount(GridOptions opt);

  //Получение количества колонок грида
  void delete(T entity);

  //Удаление из таблицы множества строк
  void delete(List<T> entities);

  //Получение списка строк по запросу
  List<T> getList(String sql);

  //Получение количества строк по запросу
  Long getCount(String sql);

  //Получение объекта по запросу
  T getObj(String  sql);

  List<T> getGridList(Grid grid);

  T obj(String sql);
}
