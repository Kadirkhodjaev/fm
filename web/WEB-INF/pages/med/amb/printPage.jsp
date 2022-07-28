<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<html>
<body>
<div>
  <table style="width:100%; display:none">
    <tr>
      <td style="padding-left:75px">
        <img src="/res/imgs/fm_logo.png" style="width:180px">
      </td>
      <td rowspan="2" style="font-size:16px !important; font-weight:bold; text-align:right;padding-top:20px">
        ЦП "Farxod Mada Shifo"<br/>
        Республика Узбекистан<br/>
        Ташкантская область<br/>
        Кибрайский район<br/>
        ул. Зебинисо, 8А<br/>
        Наш сайт: www.forux.uz<br/>
        email: forux@mail.ru<br/>
        Тел/Факс: (71) 289-24-66
      </td>
    </tr>
    <tr>
      <td style="text-align:left;font-weight:bold">
        <div style="font-size:16px !important;padding-left:90px">Свидетельство №1878</div>
        <div style="font-size:16px !important;padding-left:100px">Лицензия №01727</div>
      </td>
    </tr>
  </table>
  <div style="height:110px;"></div>
  <table style="margin:auto; width:100%;" cellspacing="0" cellpadding="0">
    <tr>
      <td style="padding:2px; width:200px; border:1px solid black; text-align:center; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">Ф.И.О.</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">${patient.surname} ${patient.name} ${patient.middlename}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">Год рождения</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">${patient.birthyear}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">Дата и время</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${patient.crOn}"/></td>
    </tr>
  </table>
</div>
<c:forEach items="${services}" var="ser">
  <table style="width:100%;margin-top:10px">
    <tr>
      <td style="font-weight:bold; text-align:center; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
    </tr>
    <c:if test="${ser.result.c1 != 'undefined' && ser.result.c1 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c1_name}</td></tr>
      <tr><td>${ser.result.c1}</td></tr>
    </c:if>
    <c:if test="${ser.result.c2 != 'undefined' && ser.result.c2 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c2_name}</td></tr>
      <tr><td>${ser.result.c2}</td></tr>
    </c:if>
    <c:if test="${ser.result.c3 != 'undefined' && ser.result.c3 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c3_name}</td></tr>
      <tr><td>${ser.result.c3}</td></tr>
    </c:if>
    <c:if test="${ser.result.c4 != 'undefined' && ser.result.c4 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c4_name}</td></tr>
      <tr><td>${ser.result.c4}</td></tr>
    </c:if>
    <c:if test="${ser.result.c5 != 'undefined' && ser.result.c5 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c5_name}</td></tr>
      <tr><td>${ser.result.c5}</td></tr>
    </c:if>
    <c:if test="${ser.result.c6 != 'undefined' && ser.result.c6 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c6_name}</td></tr>
      <tr><td>${ser.result.c6}</td></tr>
    </c:if>
    <c:if test="${ser.result.c7 != 'undefined' && ser.result.c7 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c7_name}</td></tr>
      <tr><td>${ser.result.c7}</td></tr>
    </c:if>
    <c:if test="${ser.result.c8 != 'undefined' && ser.result.c8 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c8_name}</td></tr>
      <tr><td>${ser.result.c8}</td></tr>
    </c:if>
    <c:if test="${ser.result.c9 != 'undefined' && ser.result.c9 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c9_name}</td></tr>
      <tr><td>${ser.result.c9}</td></tr>
    </c:if>
    <c:if test="${ser.result.c10 != 'undefined' && ser.result.c10 != null}">
      <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c10_name}</td></tr>
      <tr><td>${ser.result.c10}</td></tr>
    </c:if>
    <tr>
      <td style="padding:20px 0;font-weight:bold">
        <div style="float:left;padding-left:20px;">
          Врач
        </div>
        <div style="float:right;padding-right:20px;">
          ${ser.worker.fio}
        </div>
      </td>
    </tr>
  </table>
</c:forEach>
</body>
</html>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=windows-1251");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
