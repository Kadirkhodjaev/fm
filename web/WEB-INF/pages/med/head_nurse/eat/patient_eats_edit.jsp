<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="panel panel-info" style="width: 1000px !important; margin: auto">
  <div class="panel-heading">
    Питание - ${patient.surname} ${patient.name} ${patient.middlename} ИБ №${patient.yearNum}
    <button class="btn btn-default btn-sm" style="float:right; margin-top:-5px; margin-left:5px" onclick="setPage('/head_nurse/eat.s?id=${eat_id}')">Назад</button>
    <button class="btn btn-success btn-sm" style="float:right; margin-top:-5px" onclick="savePatientSave()">Сохранить</button>
  </div>
  <form name="patient-eat" id="patient-eat">
    <table class="table table-bordered">
      <tr>
        <td class="center bold">Дата</td>
        <td class="center bold">Тип диеты</td>
        <td class="center bold">Стол</td>
      </tr>
      <c:forEach items="${eats}" var="eat" varStatus="loop">
        <input type="hidden" name="id" value="${eat.id}">
        <tr id="patient-eat-row-${loop.index}">
          <td class="center" style="width:120px">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${eat.actDate}" />
          </td>
          <td class="center">
              ${eat.menuType.name}
          </td>
          <td>
            <c:if test="${eat.state == 'ENT' || eat.state == 'REF'}">
              <select class="form-control" name="table" onchange="setPatientTable(this, ${loop.index})">
                <option value=""></option>
                <option <c:if test="${eat.state == 'REF'}">selected</c:if> value="-1">Отказ</option>
                <c:forEach items="${tables}" var="table">
                  <option <c:if test="${table.id == eat.table.id}">selected</c:if> value="${table.id}">${table.name}</option>
                </c:forEach>
              </select>
            </c:if>
            <c:if test="${eat.state == 'CON'}">
              ${eat.table.name}
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </table>
  </form>
</div>
<span id="saveBtn" onclick="savePatientEat()"></span>
<script>
  function savePatientSave() {
    $.ajax({
      url: '/lv/eat.s',
      method: 'post',
      data: $('#patient-eat').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function setPatientTable(dom, idx) {
    var counter = ${fn:length(eats)};
    for(var i=idx + 1;i<counter;i++) {
      $('#patient-eat-row-' + i).find('select[name=table]').val(dom.value);
    }
  }
</script>