<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
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
        <td class="right wpx-100">
          <button class="btn btn-success btn-icon" type="button" onclick="addAmb()" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
        </td>
      </tr>
    </table>
  </div>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>ID</th>
          <th>Группировка</th>
          <th>Наименование</th>
          <th>Стоимость</th>
          <th>Стоимость (Иностранцы)</th>
          <th>Лечение?</th>
          <th>Состояние</th>
          <th>Форма</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td style="vertical-align: middle" class="center">${s.id}</td>
            <td style="vertical-align: middle">${s.service.group.name}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="setPage('/core/amb/service/save.s?id=${s.service.id}');return false;">${s.service.name}</a>
            </td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.for_price}" type = "number"/></td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${s.service.treatment == 'Y'}">Да</c:if>
              <c:if test="${s.service.treatment != 'Y'}">Нет</c:if>
            </td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${s.service.state == 'A'}">Активный</c:if>
              <c:if test="${s.service.state == 'P'}">Пассивный</c:if>
            </td>
            <td style="vertical-align: middle; text-align: center">
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
