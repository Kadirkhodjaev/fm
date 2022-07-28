<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="background-color:#e8e8e8; padding:5px; margin-bottom:5px">
  Шаблоны по обследованиям</b>
</div>
<style>
  table.table tbody tr:hover {background:#e8e8e8}
  table.table thead {background:#d1d1d1}
  table.table thead th {text-align: center}
  table.table tbody tr td {padding:3px 10px;}
</style>
<script>
  function openKdo(id){
    openMainPage('/templates/edit.s?id=' + id, true);
  }
</script>
<table class="table table-striped table-bordered table-hover grid dataTable hand" style="width: 600px; margin: auto;">
  <thead>
    <tr>
      <th>Тип</th>
      <th>Наименование</th>
      <th>Шаблон</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${kdos}" var="k">
    <tr ondblclick="openKdo(${k.id})">
      <td nowrap="">${k.kdoType.name}</td>
      <td nowrap="">${k.name}</td>
      <td align="center" nowrap=""><c:if test="${k.template != '' && k.template != null}">Есть</c:if><c:if test="${k.template == '' || k.template == null}">Нет</c:if></td>
    </tr>
  </c:forEach>
  </tbody>
</table>