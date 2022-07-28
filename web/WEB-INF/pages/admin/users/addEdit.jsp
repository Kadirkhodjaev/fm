<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
  function doSave() {
    try {
      var res = frm.document.getElementById('login').value;
      $('#mainWindow').html($('#frmDiv').contents().find('html').html());
    } catch(e){}
  }
  function setDirection(isInit) {
    var dom = document.getElementById('drugDirection1');
    $('input[name=storage]').each((idx, elem) => {
      if(!isInit)
        elem.checked = false;
      elem.disabled = !dom.checked;
    });
  }
  $('d').html('*').css('font-weight', 'bold').css('color', 'red');
  $(function() {
    setDirection(true);
  });
</script>
<iframe onload="doSave()" src="about:blank" id="frmDiv" name="frm" style="display: none"></iframe>
<div class="panel panel-info" style="width: 800px; margin: auto">
  <div class="panel-heading">Реквизиты пользователя</div>
  <f:form commandName="user" action='/admin/users/addEdit.s' method="post" name='bf' target="frm">
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <%@include file="/incs/msgs/errors.jsp"%>
      <f:hidden path="id"/>
      <div class="table-responsive center">
        <div class="row" style="margin:0">
          <div class="col-lg-6">
            <table class="formTable" style="width: 100%">
              <tr>
                <td class="right">Логин<d></d>:</td>
                <td><f:input path="login" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Пароль<c:if test="${user.id == null}"><d></d></c:if>:</td>
                <td><f:input path="password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right" nowrap>Подтверждения пароля<c:if test="${user.id == null}"><d></d></c:if>:</td>
                <td><input name="confirm_password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">ФИО<d></d>:</td>
                <td><f:input path="fio" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Отделение:</td>
                <td>
                  <f:select path="dept.id" class="form-control">
                    <option></option>
                    <f:options items="${deptList}" itemValue="id" itemLabel="name"/>
                  </f:select>
                </td>
              </tr>
              <tr>
                <td class="right">Профиль:</td>
                <td><f:input path="profil" class="form-control" type="text" maxlength="64" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Лечащий врач?</td>
                <td style="text-align: left"><f:checkbox path="lv"/></td>
              </tr>
              <tr>
                <td class="right">Активный?</td>
                <td style="text-align: left"><f:checkbox path="active"/></td>
              </tr>
              <tr>
                <td class="right">Консультация?</td>
                <td style="text-align: left"><f:checkbox path="consul"/></td>
              </tr>
              <tr>
                <td class="right">Заведующий отделом?</td>
                <td style="text-align: left"><f:checkbox path="zavlv"/></td>
              </tr>
              <tr>
                <td class="right">Админ амб.?</td>
                <td style="text-align: left"><f:checkbox path="ambAdmin"/></td>
              </tr>
              <tr>
                <td class="right">Амб. физиотерапевт?</td>
                <td style="text-align: left"><f:checkbox path="ambFizio"/></td>
              </tr>
              <tr>
                <td class="right">Директор?</td>
                <td style="text-align: left"><f:checkbox path="boss"/></td>
              </tr>
              <tr>
                <td class="right">Главный врач?</td>
                <td style="text-align: left"><f:checkbox path="glb"/></td>
              </tr>
              <tr>
                <td class="right">Главный бухгалтер?</td>
                <td style="text-align: left"><f:checkbox path="glavbuh"/></td>
              </tr>
              <tr>
                <td class="right">Старшая медсестра?</td>
                <td style="text-align: left"><f:checkbox path="mainNurse"/></td>
              </tr>
              <tr>
                <td class="right">Заявитель для аптеки?</td>
                <td style="text-align: left"><f:checkbox path="drugDirection" onchange="setDirection(false)"/></td>
              </tr>
              <tr>
                <td class="right">Врач физиотерапевт?</td>
                <td style="text-align: left"><f:checkbox path="docfizio"/></td>
              </tr>
              <tr>
                <td>Стоимость консультаций:</td>
                <td><f:input path="consul_price" type="number" cssClass="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Стоимость консультаций (Иностранцы):</td>
                <td><f:input path="for_consul_price" type="number" cssClass="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Реальная стоимость консультаций:</td>
                <td><f:input path="real_consul_price" type="number" cssClass="form-control right" autocomplete="off"/></td>
              </tr>
              <tr>
                <td>Реальная стоимость консультаций (Иностранцы):</td>
                <td><f:input path="for_real_consul_price" type="number" cssClass="form-control right" autocomplete="off"/></td>
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
          <div class="col-lg-6">
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
    <button type="button" onclick="setPage('/admin/users/list.s')" class="btn btn-sm btn-default"><i class="fa fa-mail-reply"></i> Назад</button>
    <button type="submit" class="btn btn-sm btn-success"><i class="fa fa-check"></i> Сохранить</button>
  </div>
  </f:form>
</div>
<script>
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
