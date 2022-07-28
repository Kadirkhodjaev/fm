<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Заявки по пациентам на дату <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${menu.menuDate}" /></b> по типу <b>${menuType.name}</b>
    <button  class="btn btn-sm btn-default" onclick="setPage('/eats/claims.s')" style="float:right;margin-top:-5px"><i class="fa fa-arrow-left"></i> Назад</button>
    <button  class="btn btn-sm btn-success" onclick="saveEatClaim()" style="float:right;margin-top:-5px;margin-right: 5px"><i class="fa fa-check"></i> Сохранить</button>
    <c:if test="${claim.id != null}">
      <button  class="btn btn-sm btn-default" onclick="setPage('/eats/claim/patients.s?id=${claim.id}')" style="float:right;margin-top:-5px;margin-right: 5px"><i class="fa fa-adjust"></i> Пациенты</button>
      <button  class="btn btn-sm btn-default" onclick="setPage('/eats/menu/rasxod.s?id=${claim.id}')" style="float:right;margin-top:-5px;margin-right: 5px"><i class="fa fa-adjust"></i> Расходы</button>
    </c:if>
    <button  class="btn btn-sm btn-success" onclick="refreshPage()" style="float:right;margin-top:-5px;margin-right: 5px"><i class="fa fa-refresh"></i> Обновить</button>
    <c:if test="${claim.state == 'ENT'}">
      <button  class="btn btn-sm btn-success" onclick="confirmEatClaim()" style="float:right;margin-top:-5px;margin-right: 5px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <div class="row" style="margin:0">
      <c:forEach items="${list}" var="table">
        <div class="col-md-6">
          <div class="panel panel-default">
            <div class="panel-heading hand" data-toggle="collapse" href="#table_${table.id}">
              <h4 class="panel-title">
                ${table.name}
                <c:if test="${fn:length(table.eats) == 0 && fn:length(table.patients) > 0}"> - <span style="color:red; font-weight: bold">Меню не настроен</span>
                  <div style="float:right; color:white; background-color:#c9302c; padding:2px 6px; border-radius: 20px">${fn:length(table.patients)}</div>
                </c:if>
                  <c:if test="${(fn:length(table.eats) > 0 && fn:length(table.patients) > 0) || (fn:length(table.patients) == 0)}">
                    <div style="float:right; color:white; background-color:green; padding:2px 6px; border-radius: 20px">${fn:length(table.patients)}</div>
                  </c:if>
              </h4>
            </div>
            <div id="table_${table.id}" class="panel-collapse collapse <c:if test="${fn:length(table.patients) > 0}">in</c:if>">
              <div class="panel-body">
                <fieldset>
                  <legend>Пациенты</legend>
                  <table class="table table-bordered miniGrid">
                    <tr>
                      <th>ИБ №</th>
                      <th>ФИО</th>
                      <th>Отд./Палата</th>
                    </tr>
                    <tbody>
                      <c:forEach items="${table.patients}" var="patient">
                        <tr>
                          <td class="center">${patient.ibNum}</td>
                          <td>${patient.fio}</td>
                          <td class="center">${patient.otdPal}</td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </fieldset>
                <c:if test="${fn:length(table.eats) > 0}">
                  <fieldset>
                    <legend>Меню</legend>
                    <table class="table table-bordered miniGrid">
                      <c:forEach items="${table.eats}" var="eat">
                        <tr>
                          <td class="center">${eat.typeName}</td>
                          <td>${eat.name}</td>
                        </tr>
                      </c:forEach>
                    </table>
                  </fieldset>
                </c:if>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>
<script>
  var isOk = true;
  var form = $('<form id="table_form_saver"></form>');
  <c:forEach items="${list}" var="table">
    <c:if test="${fn:length(table.eats) == 0 && fn:length(table.patients) > 0}">
      isOk = false;
    </c:if>
    form.append($('<input name="table" value="${table.id}"/>'));
    <c:forEach items="${table.patients}" var="patient">
      form.append($('<input name="p${table.id}" value="${patient.id}"/>'));
      form.append($('<input name="info${table.id}" value="${patient.fio}"/>'));
    </c:forEach>
    <c:forEach items="${table.eats}" var="eat">
      form.append($('<input name="e${table.id}" value="${eat.id}"/>'));
    </c:forEach>
  </c:forEach>
  function saveEatClaim() {
    if(!isOk) {
      alert('Не настроен меню для некоторых типов. Проверьте и настройте меню');
      return;
    }
    form.append($('<input name="id" value="${claim.id}"/>'))
        .append($('<input name="menu" value="${menu.id}"/>'))
        .append($('<input name="menu_type" value="${menuType.id}"/>'));
    $.ajax({
      url: '/eats/claim/save.s',
      method: 'post',
      data: form.serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/eats/claims.s')
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function refreshPage() {
    setPage('/eats/claim/refresh.s?id=${claim.id}');
  }
  function confirmEatClaim() {
    if(confirm('Вы действительно хотите подтвердить Заявку. После подтверждения нельзя изменить данные?')) {
      $.ajax({
        url: '/eats/claim/confirm.s',
        data: 'id=${claim.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/eats/claims.s');
          } else
            alert(res.msg);
        }
      });
    }
  }
</script>