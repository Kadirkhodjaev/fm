<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<html>
<body style="text-align: center;font-family: Bahnschrift">
<div style="margin-top:-10px">
  <div style="width:6.8cm; margin: auto">
    <div style="text-align: center; font-weight: bold; margin-top:10px">
      ${org_name}
    </div>
    <div style="text-align: center; font-size:11px; margin-top:10px; margin-bottom:10px">
      ${address}
    </div>
    <table style="width:100%; font-size: 13px">
      <tr>
        <td>ИНН:</td>
        <td style="text-align: right">${inn}</td>
      </tr>
      <tr>
        <td>Дата: <fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.regDate}" /></td>
        <td style="text-align: right">Время: ${cur_time}</td>
      </tr>
      <tr>
        <td>Номер чека:</td>
        <td style="text-align: right">№ ${pat.id}</td>
      </tr>
      <tr>
        <td>Кассир:</td>
        <td style="text-align: right">${casher}</td>
      </tr>
      <tr>
        <td colspan="2">Пациент:</td>
      </tr>
      <tr>
        <td colspan="2" style="font-size:16px;text-align:center; font-weight:bold">${pat.client.surname} ${pat.client.name} ${pat.client.middlename}<br/><span style="font-size:13px"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.client.birthdate}"/></span></td>
      </tr>
    </table>
    <table style="width:100%">
      <tr>
        <td colspan="2" style="border-bottom:1px dashed black"></td>
      </tr>
      <tr>
        <td style="font-size:12px">Оказанные услуги</td>
        <td style="font-size:12px;text-align: right">Сумма</td>
      </tr>
      <tr>
        <td colspan="2" style="border-bottom:1px dashed black"></td>
      </tr>
      <c:forEach items="${rows}" var="row">
        <tr>
          <td style="font-size: 12px">${row.service.name}</td>
          <td style="font-size: 12px; text-align:right"><fmt:formatNumber value = "${row.price}" type = "number"/></td>
        </tr>
        <tr>
          <td colspan="2" style="border-bottom:1px dotted black"></td>
        </tr>
      </c:forEach>
      <tr>
        <td style="font-size:12px">Всего</td>
        <td style="font-size:12px; text-align: right"><fmt:formatNumber value = "${sum}" type = "number"/></td>
      </tr>
      <tr>
        <td style="font-size:12px">в т.ч. скидка</td>
        <td style="font-size:12px; text-align: right"><fmt:formatNumber value = "${sale}" type = "number"/></td>
      </tr>
      <tr>
        <td colspan="2" style="border-bottom:1px dashed black"></td>
      </tr>
      <tr>
        <td style="font-size:12px; font-weight:bold">ИТОГО К ОПЛАТЕ</td>
        <td style="font-size:12px; font-weight:bold; text-align: right"><fmt:formatNumber value = "${sum - sale}" type = "number"/></td>
      </tr>
    </table>
    <div style="font-weight: bold; font-size: 13px; margin-top:10px; text-align: center">
      ${deviz}
    </div>
    <c:if test="${qrcode == 'Y'}">
      <div style="font-weight: bold; font-size: 13px; margin-top:10px; text-align: center">
        <img src="#" id="qrcodefield"/>
        <div style="position: relative; top:-15px">проверка результатов</div>
      </div>
    </c:if>
  </div>
</div>
</body>
</html>
<c:if test="${qrcode == 'Y'}">
  <script>
    $(function(){
      $('#qrcodefield').attr("src", '${qrcodeurl}${pat.qrcode}');
    })
  </script>
</c:if>
