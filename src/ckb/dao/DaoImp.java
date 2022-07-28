package ckb.dao;

import ckb.domains.GenId;
import ckb.models.Grid;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 24.03.14
 * Time: 11:40
 * Реализация основного родителя для всех менеджеров данных
 */
public abstract class DaoImp<T extends GenId> implements Dao<T> {

  //Получение всех записей таблицы
  public List<T> getAll(){
    return (List<T>) entityManager.createQuery("Select entity From " + clazz.getSimpleName() + " entity ", clazz).getResultList();
  }

  //Получение всех записей таблицы
  public List<T> getAllOrderedById(){
    return (List<T>) entityManager.createQuery("From " + clazz.getSimpleName() + " Order By 1", clazz).getResultList();
  }

  private Class<T> clazz;

  @PersistenceContext
  protected EntityManager entityManager;

  public DaoImp(Class<T> clazz){
    this.clazz = clazz;
  }

  //Получение строки таблицы по идентификатору
  @Override
  public T get(Integer id){
    return (T) entityManager.find(clazz, id);
  }

  //Запись в таблицу строки при добавлении и редактировании
  @Override
  public void save(T entity){
    if(entity.getId() != null)
      entityManager.merge(entity);
    else
      entityManager.persist(entity);
  }

  //Запись в таблицу строки при добавлении и редактировании и вернуть строку
  @Override
  public T saveAndReturn(T entity){
    if(entity.getId() != null)
      entityManager.merge(entity);
    else
      entityManager.persist(entity);
    return entity;
  }

  //Запись в таблицу множества строк при добавлении и редактировании
  @Override
  public void save(Set<T> entities){
    for (T entity : entities)
      save(entity);
  }

  //Удаление из таблицы строки
  @Transactional
  public void delete(Integer id){
    entityManager.createQuery("Delete From " + clazz.getSimpleName() + " entity Where entity.id=" + id).executeUpdate();
  }

  //Получение результата грида
  /*@Override
  public List<Object> getGridList(GridOptions opt){
    if(opt.getStartPosition().equals(0))
      return new ArrayList<Object>();
    return (List<Object>) entityManager.createQuery(opt.getSelect() + " " + opt.getWhere() + " " + opt.getOrderBy()).setFirstResult(opt.getStartPosition() - 1).setMaxResults(opt.getEndPosition()).getResultList();
  }

  //Получение количества колонок грида
  @Override
  public Integer getGridRowCount(GridOptions opt){
    String countSelect = "Select Count(*) " + opt.getSelect().substring(opt.getSelect().toUpperCase().indexOf("FROM ")) + opt.getWhere();
    return Integer.valueOf(entityManager.createQuery(countSelect).getSingleResult().toString());
  }*/

  //Получение количества колонок грида
  @Override
  public void delete(T entity){
    entityManager.remove(entity);
  }

  //Удаление из таблицы множества строк
  @Override
  public void delete(List<T> entities){
    for (T entity : entities)
      delete(entity);
  }

  //Получение списка строк по запросу
  @Override
  public List<T> getList(String sql){
    return entityManager.createQuery(sql).getResultList();
  }

  //Получение количества строк по запросу
  @Override
  public Long getCount(String sql){
    return (Long) entityManager.createQuery("Select Count(*) " + sql.substring(sql.toUpperCase().indexOf("FROM "))).getSingleResult();
  }

  //Получение объекта по запросу
  @Override
  public T getObj(String  sql){
    return (T) entityManager.createQuery(sql).getSingleResult();
  }

  //Получение списка строк по запросу
  @Override
  public List<T> getGridList(Grid grid){
    int startPos = grid.getStartPos() == 0 ? 0 : grid.getStartPos() - 1;
    return entityManager.createQuery(grid.getSql()).setFirstResult(startPos).setMaxResults(grid.getPageSize()).getResultList();
  }

}
