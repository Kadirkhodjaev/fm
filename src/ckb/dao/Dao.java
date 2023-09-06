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
 * �������� �������� ���� ���������� ������
 */
public interface Dao<T extends GenId> {

  //��������� ���� ������� �������
  List<T> getAll();

  //��������� ���� ������� �������
  List<T> getAllOrderedById();

  //��������� ������ ������� �� ��������������
  T get(Integer id);

  //������ � ������� ������ ��� ���������� � ��������������
  @Transactional
  void save(T entity);

  //������ � ������� ������ ��� ���������� � �������������� � ������� ������
  @Transactional
  T saveAndReturn(T entity);

  //������ � ������� ��������� ����� ��� ���������� � ��������������
  @Transactional
  void save(Set<T> entities);

  //�������� �� ������� ������
  void delete(Integer id);

  //��������� ���������� �����
  //List<Object> getGridList(GridOptions opt);

  //��������� ���������� ������� �����
  //Integer getGridRowCount(GridOptions opt);

  //��������� ���������� ������� �����
  void delete(T entity);

  //�������� �� ������� ��������� �����
  void delete(List<T> entities);

  //��������� ������ ����� �� �������
  List<T> getList(String sql);

  //��������� ���������� ����� �� �������
  Long getCount(String sql);

  //��������� ������� �� �������
  T getObj(String  sql);

  List<T> getGridList(Grid grid);

  T obj(String sql);
}
