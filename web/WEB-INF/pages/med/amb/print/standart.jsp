<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Резултат</td>
    <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
      <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Норма</td>
    </c:if>
    <c:if test="${form.eiFlag == null || form.eiFlag == 'Y'}">
      <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ед. изм.</td>
    </c:if>
  </tr>
  <c:forEach items="${ser.fields}" var="field">
    <tr>
      <td style="padding:5px;text-align:right;border:1px solid black;">${field.name}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.html}</td>
      <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
        <td style="padding:5px;text-align:center;border:1px solid black;">${field.norma}</td>
      </c:if>
      <c:if test="${form.eiFlag == null || form.eiFlag == 'Y'}">
        <td style="padding:5px;text-align:center;border:1px solid black;">${field.ei}</td>
      </c:if>
    </tr>
  </c:forEach>
  <tr>
    <td colspan="4" style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="width:49%;padding-left:20px;">Врач</td>
          <td width="50%" style="text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
