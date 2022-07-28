<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Результат</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Норма</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ед. изм.</td>
  </tr>
  <c:forEach items="${ser.fields}" var="field">
    <tr>
      <td style="padding:5px;text-align:right;border:1px solid black;">${ser.service.name}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.html}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.norma}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.ei}</td>
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
