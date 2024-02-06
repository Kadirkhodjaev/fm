package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.dao.admin.users.DUser;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbServiceUsers;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class DAmbServiceUserImp extends DaoImp<AmbServiceUsers> implements DAmbServiceUser {

  @Autowired private DUser dUser;

  public DAmbServiceUserImp() {
    super(AmbServiceUsers.class);
  }

  @Override
  public Users getFirstUser(Integer service) {
    List<AmbServiceUsers> list = getList("From AmbServiceUsers Where service = " + service);
    if(list.size() > 0)
      return dUser.get(list.get(0).getUser());
    return new Users();
  }
}
