package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.dao.admin.users.DUser;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbServiceUsers;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class DAmbServiceUsersImp extends DaoImp<AmbServiceUsers> implements DAmbServiceUsers {

  @Autowired private DUser dUser;

  public DAmbServiceUsersImp() {
    super(AmbServiceUsers.class);
  }

  @Override
  public Users getFirstUser(Integer id) {
    List<AmbServiceUsers> list = getList("From AmbServiceUsers Where service = " + id);
    if(list.size() > 0)
      return dUser.get(list.get(0).getUser());
    return new Users();
  }
}