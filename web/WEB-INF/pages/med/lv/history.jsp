<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<style>
  .pageNum {height: 28px;padding: 6px 4px;font-size: 12px;border: 1px solid #ccc;}
  .grid {font-size: 12px}
  .grid tr {cursor: hand}
  .grid thead {background:#d1d1d1}
  .grid thead tr th {text-align: center; border:1px solid #ddd !important;}
  .grid tbody tr td, .grid thead tr th {padding: 4px !important;}
</style>
<div class="panel panel-info table-responsive" style="width: 900px !important; margin: auto">
  <div class="panel-heading">История</div>
  <table class="table table-striped table-bordered table-hover grid dataTable hand" width="100%">
    <thead>
      <tr>
        <th>ФИО</th>
        <th>Дата рег.</th>
        <th>№ ИБ</th>
        <th>Отд. / Палата</th>
        <th>Категория</th>
        <th>Метка</th>
        <th>Лечащий врач</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${patients}" var="p">
        <tr4>
          <td align="center"><a href="#" onclick="parent.openMainPage('/view/index.s?id=${p.id}', false); return false">${p.fio}</a></td>
          <td align="center">${p.dateBegin}</td>
          <td align="center">${p.ibNum}</td>
          <td align="center">${p.otdPal}</td>
          <td align="center">${p.cat}</td>
          <td align="center">${p.metka}</td>
          <td align="center">${p.lv}</td>
        </tr4>
      </c:forEach>
    </tbody>
  </table>
</div>