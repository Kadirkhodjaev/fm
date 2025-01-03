<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="panel panel-info">
  <div class="panel-heading">
    Аптека - Новое поступление по датам
  </div>
  <table class="table">
    <tr>
      <td class="bold text-center">№</td>
      <td class="bold text-center">Наименование</td>
      <td class="bold text-center">Дата</td>
    </tr>
    <c:forEach items="${drugs}" var="d" varStatus="loop">
      <tr class="hover">
        <td class="text-center" style="width: 80px">${loop.index + 1}</td>
        <td>
          ${d.drug.name}
        </td>
        <td class="text-center" style="width:150px">
          <fmt:formatDate pattern="dd.MM.yyyy" value="${d.act.regDate}"/>
        </td>
      </tr>
    </c:forEach>
  </table>
</div>
