<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Печатьная форма для Питания</title>
</head>
<body>
  <table style="width:100%">
    <tr>
      <td colspan="6" style="font-weight: bold;text-align: center; font-size: 20px">Питание</td>
    </tr>
    <tr>
      <td style="font-weight: bold; text-align: right">Отделение:</td>
      <td>${eat.dept.name}</td>
      <td style="font-weight: bold; text-align: right">Дата:</td>
      <td><fmt:formatDate pattern="dd.MM.yyyy" value="${eat.actDate}"/></td>
      <td style="font-weight: bold; text-align: right">Тип:</td>
      <td>${eat.menuType.name}</td>
    </tr>
  </table>
  <table style="width:100%; border-collapse: collapse">
    <tr>
      <td style="border:1px solid black; background: #ababab; text-align: center; font-weight: bold">Стол</td>
      <td style="border:1px solid black; background: #ababab; text-align: center; width:30px; font-weight: bold">#</td>
      <td style="border:1px solid black; background: #ababab; text-align: center; font-weight: bold">Клиенты</td>
      <td style="border:1px solid black; background: #ababab; text-align: center; font-weight: bold">Палата</td>
    </tr>
    <c:forEach items="${rows}" var="r">
      <tr>
        <td style="border:1px solid black; text-align: center" rowspan="${fn:length(r.patients) + 1}">${r.name}</td>
      </tr>
      <c:forEach items="${r.patients}" var="p" varStatus="loop">
        <tr>
          <td style="border:1px solid black; text-align: center">${loop.index + 1}</td>
          <td style="border:1px solid black; width:90%">${p.fio}</td>
          <td style="border:1px solid black; text-align: center;">${p.metka}</td>
        </tr>
      </c:forEach>
    </c:forEach>
  </table>
</body>
</html>
