<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Статистика</title>
</head>
<style>
  * {font-size:${fontSize}px !important;}
</style>
<body>
  <p style="width:95%;margin:auto;text-align:center;font-weight:bold;padding:20px">
    План обследования по отделению: ${deptName}
  </p>
  <table style="margin:auto;width:95%;border-collapse:collapse;">
    <tr>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px">ФИО</td>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px">Наименование</td>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px">Дата</td>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px">Описание</td>
    </tr>
    <c:forEach items="${plans}" var="plan">
      <tr>
        <c:if test="${plan.c30 != 'Y'}">
          <td style="border:1px solid black;padding:8px">${plan.c1}</td>
          <td style="border:1px solid black;padding:8px">${plan.c3}</td>
          <td style="border:1px solid black;padding:8px;text-align:center">${plan.c4}</td>
          <td style="border:1px solid black;padding:8px">${plan.c5}</td>
        </c:if>
        <c:if test="${plan.c30 == 'Y'}">
          <td align="center" style="border:1px solid black;padding:8px;font-weight: bold" colspan="4">${plan.c1}</td>
        </c:if>
      </tr>
    </c:forEach>
  </table>
  <div style="text-align:right; padding-top:20px; padding-right:40px;">${currTime}</div>
</body>
</html>
