<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<body style="text-align: center;font-family: Bahnschrift">
<div style="margin-top:-10px">
  <div style="width:6.8cm; margin: auto">
    <div style="text-align: center">
      <img src="/res/imgs/fm_logo.png" style="width:4cm;">
    </div>
    <div style="text-align: center; font-weight: bold; margin-top:10px">
      Многопрофильная клиника<br/>
      «Farxod Madad Shifo»
    </div>
    <div style="text-align: center; font-size:11px; margin-top:10px; margin-bottom:10px">
      РУз, обл.Ташкент, Кибрайский р-н, ул. Зебинисо, 8А<br/>
      тел: 55 500 28 88
    </div>
    <table style="width:100%; font-size: 13px">
      <tr>
        <td>ИНН:</td>
        <td style="text-align: right">206 955 732</td>
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
        <td colspan="2" style="font-size:16px;text-align:center; font-weight:bold">${pat.surname} ${pat.name} ${pat.middlename}</td>
      </tr>
    </table>
    <table style="width:100%">
      <tr>
        <td colspan="3" style="border-bottom:1px dashed black"></td>
      </tr>
      <tr>
        <td style="font-size:12px">Оказанные услуги</td>
        <td style="font-size:12px" nowrap>Кол-во</td>
        <td style="font-size:12px">Сумма</td>
      </tr>
      <tr>
        <td colspan="3" style="border-bottom:1px dashed black"></td>
      </tr>
      <c:forEach items="${drugs}" var="row">
        <tr>
          <td style="font-size: 12px">${row.drug.drug.name}</td>
          <td style="font-size: 12px; text-align: center">${row.rasxod}</td>
          <td style="font-size: 12px; text-align:right"><fmt:formatNumber value = "${(row.drug.price + row.drug.nds) * row.rasxod}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
        </tr>
        <tr>
          <td colspan="3" style="border-bottom:1px dotted black"></td>
        </tr>
      </c:forEach>
      <tr>
        <td style="font-size: 12px">ИТОГО медикаменты</td>
        <td style="font-size: 12px; text-align: center">${drug_count}</td>
        <td style="font-size: 12px; text-align:right"><fmt:formatNumber value = "${drug_sum}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
      </tr>
      <tr>
        <td colspan="3" style="border-bottom:1px dotted black"></td>
      </tr>
      <tr>
        <td style="font-size: 12px">Услуги</td>
        <td style="font-size: 12px; text-align: center">${fn:length(rows)}</td>
        <td style="font-size: 12px; text-align:right"><fmt:formatNumber value = "${sum}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
      </tr>
      <tr>
        <td colspan="3" style="border-bottom:1px dotted black"></td>
      </tr>
      <tr>
        <td style="font-size:12px" colspan="2">Всего c НДС</td>
        <td style="font-size:12px; text-align: right"><fmt:formatNumber value = "${sum + drug_sum}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
      </tr>
      <tr>
        <td style="font-size:12px" colspan="2">в т.ч. скидка</td>
        <td style="font-size:12px; text-align: right"><fmt:formatNumber value = "${sale}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
      </tr>
      <tr>
        <td colspan="3" style="border-bottom:1px dashed black"></td>
      </tr>
      <tr>
        <td style="font-size:12px; font-weight:bold" colspan="2">ИТОГО</td>
        <td style="font-size:12px; font-weight:bold; text-align: right"><fmt:formatNumber value = "${sum + drug_sum - sale}" minFractionDigits="2" maxFractionDigits="2" type = "number"/></td>
      </tr>
    </table>
    <div style="font-weight: bold; font-size: 13px; margin-top:10px; text-align: center">
      ВАШЕ ЗДОРОВЬЕ - НАШ ПРИОРИТЕТ
    </div>
    <c:if test="${qrcode == 'Y'}">
      <div style="font-weight: bold; font-size: 13px; margin-top:10px; text-align: center">
        <img src="#" id="qrcodefield"/>
        <div style="position: relative; top:-15px">Результаты анализа онлайн!</div>
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
