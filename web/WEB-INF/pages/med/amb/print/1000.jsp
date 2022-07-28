<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="5" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">&nbsp;</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Результат</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Норма</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ед. изм.</td>
  </tr>
  <c:forEach items="${ser.fields}" var="field">
    <tr>
      <td style="padding:5px;text-align:center;border:1px solid black;">
        <c:choose>
          <c:when test="${field.ord == 1}">WBC</c:when>
          <c:when test="${field.ord == 2}">Lymph#</c:when>
          <c:when test="${field.ord == 3}">Mid#</c:when>
          <c:when test="${field.ord == 4}">Gran#</c:when>
          <c:when test="${field.ord == 5}">Lymph%</c:when>
          <c:when test="${field.ord == 6}">Mid%</c:when>
          <c:when test="${field.ord == 7}">Gran%</c:when>
          <c:when test="${field.ord == 8}">RBC</c:when>
          <c:when test="${field.ord == 9}">HGB</c:when>
          <c:when test="${field.ord == 10}">HCT</c:when>
          <c:when test="${field.ord == 11}">MCV</c:when>
          <c:when test="${field.ord == 12}">MCH</c:when>
          <c:when test="${field.ord == 13}">MCHC</c:when>
          <c:when test="${field.ord == 14}">RDW-CV</c:when>
          <c:when test="${field.ord == 15}">RDW-SD</c:when>
          <c:when test="${field.ord == 16}">PLT</c:when>
          <c:when test="${field.ord == 17}">MPV</c:when>
          <c:when test="${field.ord == 18}">PDW</c:when>
          <c:when test="${field.ord == 19}">PCT</c:when>
          <c:when test="${field.ord == 20}">&nbsp;</c:when>
        </c:choose>
      </td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${field.name}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.html}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.norma}</td>
      <td style="padding:5px;text-align:center;border:1px solid black;">${field.ei}</td>
    </tr>
  </c:forEach>
  <tr>
    <td colspan="5" style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="font-weight:bold;padding-left:20px;">Врач</td>
          <td width="50%" style="font-weight:bold;text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
