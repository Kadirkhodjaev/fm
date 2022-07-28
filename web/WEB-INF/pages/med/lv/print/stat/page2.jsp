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
    План обследования по отделению: ${deptName} на дату ${date}
  </p>
  <table style="margin:auto;width:95%;border-collapse:collapse;">
    <tr>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px">№</td>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px" nowrap>Пациент</td>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px" nowrap>Данные</td>
      <c:forEach items="${types}" var="type" varStatus="loop">
        <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px;" nowrap>${type.name}</td>
      </c:forEach>
      <td style="border:1px solid black; text-align: center; font-weight:bold;padding:8px" nowrap>Консультация</td>
    </tr>
    <c:forEach items="${rows}" var="row" varStatus="loop">
      <tr>
        <td style="border:1px solid black;padding:8px">${loop.index + 1}</td>
        <td style="border:1px solid black;padding:8px; font-weight: bold">${row.c1}</td>
        <td style="border:1px solid black;padding:8px" nowrap><b>Год рож.:</b>${row.c2}<br><b>ИБ №:</b>${row.c4}<br><b>Дата рег.:</b>${row.c3}<br><b>Палата:</b>${row.c30}</td>
        <td style="border:1px solid black;padding:8px">${row.c11}</td>
        <td style="border:1px solid black;padding:8px">${row.c12}</td>
        <td style="border:1px solid black;padding:8px">${row.c13}</td>
        <td style="border:1px solid black;padding:8px">${row.c14}</td>
        <td style="border:1px solid black;padding:8px">${row.c16}</td>
        <td style="border:1px solid black;padding:8px">${row.c20}</td>
        <td style="border:1px solid black;padding:8px">${row.c21}</td>
        <td style="border:1px solid black;padding:8px">${row.c22}</td>
        <td style="border:1px solid black;padding:8px">${row.c23}</td>
        <td style="border:1px solid black;padding:8px">${row.c24}</td>
        <td style="border:1px solid black;padding:8px" nowrap>${row.c25}</td>
      </tr>
    </c:forEach>
  </table>
  <div style="text-align:right; padding-top:20px; padding-right:40px;">${currTime}</div>
</body>
</html>
