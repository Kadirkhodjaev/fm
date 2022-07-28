<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<table class="table table-bordered miniGrid">
  <thead>
    <tr>
      <th style="width:50px">№</th>
      <th>Партнер</th>
      <th style="width:100px">Дата</th>
      <th style="width:100px">Цена</th>
      <th style="width:100px">Кол-во</th>
    </tr>
  </thead>
  <c:forEach items="${rows}" var="d" varStatus="row">
    <tr class="hand hover">
      <td class="center">${lp.index + 1}</td>
      <td>${d.act.contract.partner.name}</td>
      <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${d.act.regDate}" /></td>
      <td class="right"><fmt:formatNumber value = "${d.price}" type = "number"/></td>
      <td class="right">${d.blockCount}</td>
    </tr>
  </c:forEach>
</table>