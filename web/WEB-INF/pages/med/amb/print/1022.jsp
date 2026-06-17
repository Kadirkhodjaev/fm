<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="5" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td colspan="6" style="padding:5px; text-align: center">Обнаруженные микроорганизмы</td>
    <td colspan="2" style="padding:5px; text-align: center">KOE</td>
  </tr>
  <tr>
    <td colspan="6" rowspan="2" style="padding:5px; text-align: center">Serratia marcescens</td>
    <td colspan="2" style="padding:5px; text-align: center">KOE 10<sup>5</sup></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px; text-align: center">KOE</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Антибиотик</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;" nowrap>Ум. устойчивы</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Устойчивый</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Чувствительный</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Антибиотик</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;" nowrap>Ум. устойчивы</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Устойчивый</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Чувствительный</td>
  </tr>
  <c:forEach begin="0" end="63" step="3" var="field">
    <tr>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field].name}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field].html}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 1].html}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 2].html}</td>

      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 63].name}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 63].html}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 64].html}</td>
      <td style="padding:5px;text-align:left;border:1px solid black;">${fields[field + 64].html}</td>
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
