<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addAmb() {
    setPage('/core/amb/service/save.s');
  }
  function setGroup(dom) {
    setPage('/core/amb/services.s?page=' + dom.value);
  }
  function setState(state) {

  }
  var button = getDOM('toExcel');
  button.addEventListener('click', function (e) {
    var table = document.querySelector('#excel_table');
    TableToExcel.convert(table);
  });
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    <table style="width:100%">
      <tr>
        <td>
          Список амбулаторных услуг
        </td>
        <td class="wpx-400">
          <select class="form-control" onchange="setGroup(this)">
            <option value="0">Все</option>
            <c:forEach items="${groups}" var="g">
              <option <c:if test="${page == g.id}">selected</c:if> value="${g.id}">${g.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="wpx-150">
          <select class="form-control" onchange="setPage('/core/amb/services.s?state=' + this.value);">
            <option <c:if test="${stateCode == '0'}">selected</c:if> value="0">Все</option>
            <option <c:if test="${stateCode == 'A'}">selected</c:if> value="A">Активный</option>
            <option <c:if test="${stateCode == 'P'}">selected</c:if> value="P">Пассивный</option>
          </select>
        </td>
        <td class="right wpx-200">
          <button class="btn btn-success btn-icon" type="button" onclick="addAmb()"><i class="fa fa-plus"></i> Добавить</button>
          <button class="btn btn-info btn-icon" id="toExcel">
            <span class="fa fa-file-excel-o"></span> Excel
          </button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered" id="excel_table" data-cols-width="10,20,40,20,20,20,20,20,20,20">
        <thead>
        <tr>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">ID</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Группировка</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Наименование</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (Иностранцы)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (Иностранцы) (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Лечение?</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Состояние</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Форма</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle" class="center">${s.id}</td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle">${s.service.group.name}</td>
            <td data-a-h="left" data-b-a-s="thin" style="vertical-align: middle">
              <a href="#" onclick="setPage('/core/amb/service/save.s?id=${s.service.id}');return false;">${s.service.name}</a>
            </td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.for_price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.for_price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle; text-align: center">
              <c:if test="${s.service.treatment == 'Y'}">Да</c:if>
              <c:if test="${s.service.treatment != 'Y'}">Нет</c:if>
            </td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle; text-align: center">
              <c:if test="${s.service.state == 'A'}">Активный</c:if>
              <c:if test="${s.service.state == 'P'}">Пассивный</c:if>
            </td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle; text-align: center">
              ${s.service.form_id}
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
