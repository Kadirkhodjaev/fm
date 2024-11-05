<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<style>
  .grid {font-size: 12px}
  .grid tr {cursor: hand}
  .grid thead {background:#d1d1d1}
  .grid thead tr th {text-align: center; border:1px solid #ddd !important;}
  .grid tbody tr td, .grid thead tr th {padding: 4px !important;}
</style>
<c:if test="${fn:length(stats) > 0}">
  <div class="panel panel-info table-responsive" style="width: 900px !important; margin: auto">
    <div class="panel-heading">Стационар</div>
    <table class="table table-striped table-bordered table-hover grid dataTable hand" width="100%">
      <thead>
      <tr>
        <th>ФИО</th>
        <th>Дата рег.</th>
        <th>Дата вып.</th>
        <th>№ ИБ</th>
        <th>Отд. / Палата</th>
        <th>Состояние</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${stats}" var="p">
        <tr>
          <td align="center"><a href="#" onclick="parent.openMainPage('/${p.state == 'ARCH' ? 'view' : 'lv'}/index.s?id=${p.id}', false); return false">${p.fio}</a></td>
          <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${p.dateBegin}" /></td>
          <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${p.dateEnd}" /></td>
          <td align="center">${p.yearNum}</td>
          <td align="center">${p.dept.name} / ${p.room.name}</td>
          <td align="center">
            <c:if test="${p.state == 'ARCH'}">
              Архив
            </c:if>
            <c:if test="${p.state != 'ARCH'}">
              Текущий
            </c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>
<c:if test="${fn:length(ambs) > 0}">
  <div class="panel panel-info table-responsive" style="width: 900px !important; margin: auto">
    <div class="panel-heading">Амбулатория</div>
    <table class="table table-striped table-bordered table-hover grid dataTable hand" width="100%">
      <thead>
      <tr>
        <th>ФИО</th>
        <th>Год рождения</th>
        <th>Дата рег.</th>
        <th>Состояние</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${ambs}" var="p">
        <tr>
          <td align="center"><a href="#" onclick="parent.openMainPage('/amb/reg.s?id=${p.id}&stat=${pat.id}', false); return false">${p.fio}</a></td>
          <td align="center">${p.birthyear}</td>
          <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${p.crOn}" /></td>
          <td align="center">
            <c:if test="${p.state == 'ARCH'}">
              Архив
            </c:if>
            <c:if test="${p.state != 'ARCH'}">
              Текущий
            </c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>
