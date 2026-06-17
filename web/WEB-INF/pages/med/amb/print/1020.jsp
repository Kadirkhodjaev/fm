<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;" rowspan="2">Название исследования</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;" colspan="2">Результат</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Количественный</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Относительный<br>Lg(X/ОБМ)</td>
  </tr>
  <c:forEach items="${ser.fields}" var="a" varStatus="loop">
    <c:if test="${loop.index % 2 == 0}">
      <tr>
        <td style="padding:5px;text-align:right;border:1px solid black;">${a.name}</td>
        <td style="padding:5px;text-align: center;border:1px solid black;">
          <c:if test="${loop.index < 10}">
            ${a.norma}
          </c:if>
          <c:if test="${loop.index >= 10}">
            ${a.html}
          </c:if>
        </td>
        <td style="padding:5px;text-align: center;border:1px solid black;">${ser.fields[loop.index + 1].html}</td>
      </tr>
    </c:if>
    <c:if test="${loop.index == 2}">
      <tr>
        <td colspan="4" style="padding:5px;text-align: center;font-weight: bold;border:1px solid black;">НОРМОФЛОРА</td>
      </tr>
    </c:if>
    <c:if test="${loop.index == 5}">
      <tr>
        <td colspan="4" style="padding:5px;text-align: center;font-weight: bold;border:1px solid black;">ОБЛИГАТНО-АНАЭРОБНЫЕ МИКРООРГАНИЗМЫ</td>
      </tr>
    </c:if>
    <c:if test="${loop.index == 7}">
      <tr>
        <td colspan="4" style="padding:5px;text-align: center;font-weight: bold;border:1px solid black;">ДРОЖЖЕПОДОБНЫЕ ГРИБЫ</td>
      </tr>
    </c:if>
    <c:if test="${loop.index == 9}">
      <tr>
        <td colspan="4" style="padding:5px;text-align: center;font-weight: bold;border:1px solid black;">МИКОПЛАЗМЫ</td>
      </tr>
    </c:if>
    <c:if test="${loop.index == 13}">
      <tr>
        <td colspan="4" style="padding:5px;text-align: center;font-weight: bold;border:1px solid black;">ПАТОГЕННЫЕ МИКРООРГАНИЗМЫ</td>
      </tr>
    </c:if>
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
