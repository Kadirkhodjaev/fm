<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="background-color:#e8e8e8; padding:5px; margin-bottom:5px">
  Пациент: <b>${p.surname} ${p.name} ${p.middlename}</b>
</div>
<table class="table table-striped table-bordered table-hover grid dataTable hand" style="width: 800px; margin: auto;">
  <thead>
  <tr>
    <th>&nbsp;</th>
    <th>&nbsp;</th>
    <th>Наименование</th>
    <th>Дата</th>
    <th>Примечание</th>
  </tr>
  </thead>
  <tbody>
    <c:forEach items="${plans}" var="p" varStatus="loop">
      <tr ondblclick="setPage('/kdo/f${p.c2}.s?id=${p.c1}')">
        <td class="center">${loop.index + 1}</td>
        <td class="center"><img src='/res/imgs/${p.c6}.gif'/></td>
        <td><a href="#" onclick="setPage('/kdo/kdo.s?id=${p.c1}&kdo=${p.c2}')">${p.c3}</a></td>
        <td align=center>${p.c4}</td>
        <td>${p.c5}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>