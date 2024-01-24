package ckb.dao.med.client;

import ckb.dao.DaoImp;
import ckb.domains.admin.Clients;
import ckb.utils.Util;

import java.util.List;

public class DClientImp extends DaoImp<Clients> implements DClient {
  public DClientImp() {
    super(Clients.class);
  }

  @Override
  public List<Clients> dublicates(Clients client) {
    List<Clients> clients =list(
    "From Clients t " +
      " Where t.id != " + client.getId() + " " +
      "   And Exists (Select 1 " +
      "                 From Clients c " +
      "                Where c.id = " + client.getId() +
      "                  And upper(trim(c.surname)) = upper(trim(t.surname)) " +
      "                  And upper(trim(c.name)) = upper(trim(t.name)) " +
      "                  And ((c.sex.id != null And c.sex.id = t.sex.id) Or c.sex.id = null)" +
      "                  And ((c.birthdate != null And c.birthdate = t.birthdate) Or c.birthdate = null))"
    );

    return clients;
  }

  @Override
  public long checkDublicate(Clients client) {
    return getCount(
      "From Clients " +
      "    Where upper(trim(surname)) = '" + client.getSurname().toUpperCase().trim() + "' " +
      "      And upper(trim(name)) like '%" + client.getName().toUpperCase().trim() + "%' " +
      "      And sex_id = " + (client.getSex() == null ? null : client.getSex().getId()) +
      "      And date(birthdate) = '" + Util.dateDB(client.getBirthdate()) + "'" +
      (client.getMiddlename() == null ? "" : " And upper(trim(middlename)) like '%" + client.getMiddlename().toUpperCase() + "%' ") +
      (client.getId() == null ? "" : " And id != " + client.getId()));
  }
}
