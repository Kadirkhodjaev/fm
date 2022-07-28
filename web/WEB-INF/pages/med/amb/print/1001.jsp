<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td colspan="4" style="padding:5px;text-align:center;font-weight: bold">Физико-химические свойства</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Результат</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Норма</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ед. изм.</td>
  </tr>
  <c:forEach begin="0" end="13" step="1" var="r">
    <tr>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].name}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].html}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].norma}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].ei}</td>
    </tr>
  </c:forEach>
  <tr>
    <td colspan="4" style="padding:5px;text-align:center;font-weight: bold">Микроскопия</td>
  </tr>
  <c:forEach begin="14" end="22" step="1" var="r">
    <tr>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].name}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].html}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].norma}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[r].ei}</td>
    </tr>
  </c:forEach>
  <tr>
    <td colspan="4" style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="font-weight:bold;padding-left:20px;">Врач</td>
          <td width="50%" style="font-weight:bold;text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
