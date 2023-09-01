<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
  function saveUser() {
    $.ajax({
      url: '/core/user/save.s',
      method: 'post',
      data: $('#userForm').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  function setDirection(isInit) {
    var dom = document.getElementById('drugDirection');
    $('input[name=storage]').each((idx, elem) => {
      if(!isInit)
        elem.checked = false;
      elem.disabled = !dom.checked;
    });
  }
  $(function() {
    setDirection(true);
  });
  function authUser() {
    $.ajax({
      url: 'user_login.s',
      method: 'post',
      data: 'session_user_id=${user.id}',
      dataType: 'json',
      success: function (res) {
        document.location = 'main.s';
      }
    });
    document.location = ''
  }
  let ipIdx = ${fn:length(ips)};
  function addIp() {
    let tr = $('<tr id="ip_' + ipIdx + '"></tr>');
    let td = $('<td><input type="text" class="form-control center" name="ip" maxlength="15" value=""/></td>');
    let td1 = $('<td><button class="btn btn-danger btn-xs" type="button" onclick="delIp(' + ipIdx + ')"><b class="fa fa-minus"></b></button></td>');
    tr.append(td).append(td1);
    $('#user_ip_list').append(tr);
    ipIdx++;
  }
  function delIp(idx) {
    $('#ip_' + idx).remove();
  }
</script>
<div class="panel panel-info" style="width: 1200px; margin: auto">
  <div class="panel-heading" ondblclick="authUser()">Реквизиты пользователя</div>
  <form id="userForm">
    <div class="panel-body">
      <input type="hidden" name="id" value="${user.id}"/>
      <div class="table-responsive center">
        <div class="row" style="margin:0">
          <div class="col-lg-8">
            <table class="formTable" style="width: 100%">
              <tr>
                <td class="right">Логин<d></d>:</td>
                <td><input name="login" value="${user.login}" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Пароль<c:if test="${user.id == null}"><req>*</req></c:if>:</td>
                <td><input name="password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right" nowrap>Подтверждения пароля<c:if test="${user.id == null}"><d></d></c:if>:</td>
                <td><input name="confirm_password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">ФИО<d></d>:</td>
                <td><input name="fio" value="${user.fio}" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Отделение:</td>
                <td>
                  <select name="dep" class="form-control">
                    <option></option>
                    <c:forEach items="${deptList}" var="dep">
                      <option value="${dep.id}" <c:if test="${dep.id == user.dept.id}">selected</c:if>>${dep.name}</option>
                    </c:forEach>
                  </select>
                </td>
              </tr>
              <tr>
                <td class="right">Профиль:</td>
                <td><input name="profil" value="${user.profil}" class="form-control" type="text" maxlength="64" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Лечащий врач?</td>
                <td style="text-align: left"><input type="checkbox" name="lv" value="1" <c:if test="${user.lv}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Активный?</td>
                <td style="text-align: left"><input type="checkbox" name="active" value="1" <c:if test="${user.active}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Консультация?</td>
                <td style="text-align: left"><input type="checkbox" name="consul" value="1" <c:if test="${user.consul}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Заведующий отделом?</td>
                <td style="text-align: left"><input type="checkbox" name="zavlv" value="1" <c:if test="${user.zavlv}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Админ амб.?</td>
                <td style="text-align: left"><input type="checkbox" name="ambAdmin" value="1" <c:if test="${user.ambAdmin}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Амб. физиотерапевт?</td>
                <td style="text-align: left"><input type="checkbox" name="ambFizio" value="1" <c:if test="${user.ambFizio}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Директор?</td>
                <td style="text-align: left"><input type="checkbox" name="boss" value="1" <c:if test="${user.boss}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Главный врач?</td>
                <td style="text-align: left"><input type="checkbox" name="glb" value="1" <c:if test="${user.glb}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Главный бухгалтер?</td>
                <td style="text-align: left"><input type="checkbox" name="glavbuh" value="1" <c:if test="${user.glavbuh}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Процедурный пользователь?</td>
                <td style="text-align: left"><input type="checkbox" name="procUser" value="1" <c:if test="${user.procUser}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Старшая медсестра?</td>
                <td style="text-align: left"><input type="checkbox" name="mainNurse" value="1" <c:if test="${user.mainNurse}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Заявитель для аптеки?</td>
                <td style="text-align: left"><input type="checkbox" name="drugDirection" id="drugDirection" onchange="setDirection(false)" value="1" <c:if test="${user.drugDirection}">checked</c:if>/></td>
              </tr>
              <tr>
                <td class="right">Врач физиотерапевт?</td>
                <td style="text-align: left"><input type="checkbox" name="docfizio" value="1" <c:if test="${user.docfizio}">checked</c:if>/></td>
              </tr>
              <tr>
                <td>Стоимость консультаций:</td>
                <td><input name="consul_price" value="${user.consul_price}" type="number" class="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Стоимость консультаций (Иностранцы):</td>
                <td><input name="for_consul_price" value="${user.for_consul_price}" type="number" class="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Реальная стоимость консультаций:</td>
                <td><input name="real_consul_price" value="${user.real_consul_price}" type="number" class="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Реальная стоимость консультаций (Иностранцы):</td>
                <td><input name="for_real_consul_price" value="${user.for_real_consul_price}" type="number" class="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td colspan="2">
                  <table style="width:100%">
                    <tr>
                      <td class="bold">
                        IP адреса
                      </td>
                      <td class="center" style="width:40px">
                        <button class="btn btn-success btn-xs" type="button" onclick="addIp()"><b class="fa fa-plus"></b></button>
                      </td>
                    </tr>
                    <tbody id="user_ip_list">
                      <c:forEach items="${ips}" var="ip" varStatus="loop">
                        <tr id="ip_${loop.index}">
                          <td>
                            <input type="text" class="form-control center" name="ip" maxlength="15" value="${ip.ip}"/>
                          </td>
                          <td><button class="btn btn-danger btn-xs" type="button" onclick="delIp(${loop.index})"><b class="fa fa-minus"></b></button></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </td>
              </tr>
            </table>
          </div>
          <div class="col-lg-4">
            <h2>Склады</h2>
            <table style="width: 100%" class="table table-bordered table-hover">
              <c:forEach items="${directions}" var="direction">
                <tr class="hover hand">
                  <td style="width:30px;padding:5px;"><input type="checkbox" value="${direction.c1}" <c:if test="${direction.c3 > 0}">checked</c:if> name="storage" class="hand"/></td>
                  <td style="padding:5px; text-align:left">${direction.c2}</td>
                </tr>
              </c:forEach>
            </table>
          </div>
        </div>
      </div>
    </div>
  <div class="panel-footer right">
    <button type="button" onclick="setPage('/core/user/list.s')" class="btn btn-sm btn-default"><i class="fa fa-mail-reply"></i> Назад</button>
    <button type="button" onclick="saveUser()" class="btn btn-sm btn-success"><i class="fa fa-check"></i> Сохранить</button>
  </div>
  </form>
</div>
