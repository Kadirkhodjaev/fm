<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=windows-1251");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
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
  <div id="ser_${ser.id}" style="padding:10px"></div>
</c:forEach>
</body>
<%-- печатный вид листа (pp-*): пациент, услуги, значения вне нормы, подпись; классы ставит скрипт после загрузки услуг --%>
<style>
  :root { --fs:${sessionScope.fontSize}px; }
  body { margin:0; padding:8px 4px 24px; background:#fff; color:#111827; font-family:'Inter', 'Segoe UI', Arial, sans-serif; }
  table.pp-pat { border-collapse:collapse; max-width:840px; }
  table.pp-pat td { border:0 !important; border-bottom:1px solid #E5E7EB !important; padding:5px 8px !important; text-align:left !important; font-weight:400 !important; }
  table.pp-pat td:first-child { color:#6B7280; width:170px; }
  table.pp-pat td:last-child { font-weight:600 !important; }
  .pp-ser { max-width:840px; margin:0 auto; }
  .pp-ser table { border-collapse:collapse !important; }
  .pp-ser td { border:0 !important; padding:5px 8px !important; color:#111827; }
  .pp-ser tr.pp-title td { text-align:center !important; font-weight:700 !important; padding:16px 0 10px !important; }
  .pp-ser tr.pp-th td { background:#F3F4F6; color:#374151 !important; font-weight:700 !important; text-transform:uppercase; letter-spacing:.3px;
    font-size:calc(var(--fs) * .8) !important; border-top:1px solid #9CA3AF !important; border-bottom:1px solid #9CA3AF !important; text-align:center !important; }
  .pp-ser tr.pp-row td { border-bottom:1px solid #E5E7EB !important; }
  .pp-ser td.pp-v { font-weight:700; }
  .pp-ser td.pp-n { white-space:nowrap; }
  .pp-ser td.pp-out { color:#B91C1C !important; }
  .pp-ser tr.pp-sign td { padding:26px 8px 0 !important; border:0 !important; }
  .pp-sign-line { display:flex; align-items:flex-end; gap:12px; font-weight:400; }
  .pp-sign-line .ln { flex:1; max-width:220px; border-bottom:1px solid #111827; height:1px; }
  @media print { body { padding:0; } @page { margin:12mm 12mm; } }
</style>
<script>
  // после загрузки всех услуг: шапка таблицы, значения (вне нормы «a-b» — красным со стрелкой), подпись врача
  function ppStyle() {
    var VAL = /резул|натиж|кийм/i,
        NORM = /норм|меъёр/i, DOC = /^\s*Врач/;
    function num(s) { s = String(s).replace(/\s/g, '').replace(',', '.'); return s !== '' && !isNaN(s) ? Number(s) : null; }
    $('table').each(function () {
      if (this.rows.length && $(this).find('td').filter(function () { return /Ф\.И\.О|ФИО/.test($(this).text()); }).length && !$(this).closest('.pp-ser').length)
        $(this).addClass('pp-pat');
    });
    // пустые поля текстовых услуг (в том числе старые «undefined») не печатаем: из-за них подпись врача уезжала вниз
    $('.pp-ser tr').each(function () {
      var tx = $.trim($(this).text());
      if ((tx === '' || tx === 'undefined') && !$(this).find('img, input, textarea, select').length) $(this).remove();
    });
    $('.pp-ser > table').each(function () {
      var t = this, vi = -1, ni = -1, hc = 0;
      for (var r = 0; r < t.rows.length; r++) {
        var row = t.rows[r], c = row.cells, txt = $(row).text();
        if (r == 0 && c.length == 1) { row.className += ' pp-title'; continue; }
        if (DOC.test(txt) && (r == t.rows.length - 1)) {
          var parts = $(row).find('td td, div').map(function () { return $.trim($(this).text()); }).get(), fio = parts.length ? parts[parts.length - 1] : '';
          if (DOC.test(fio)) fio = '';
          row.className += ' pp-sign';
          row.innerHTML = '<td colspan="10"><div class="pp-sign-line"><span>Врач</span><span class="ln"></span><b></b></div></td>';
          $(row).find('b').text(fio);
          continue;
        }
        if (vi < 0 && VAL.test(txt) && c.length > 1) {
          row.className += ' pp-th'; hc = c.length;
          for (var i = 0; i < c.length; i++) { var x = $(c[i]).text(); if (vi < 0 && VAL.test(x)) vi = i; if (ni < 0 && NORM.test(x)) ni = i; }
          continue;
        }
        if (vi < 0 || c.length != hc) continue;
        row.className += ' pp-row';
        c[vi].className += ' pp-v';
        if (ni < 0) continue;
        c[ni].className += ' pp-n';
        var m = /^\s*(\d+(?:[.,]\d+)?)\s*-\s*(\d+(?:[.,]\d+)?)\s*$/.exec($(c[ni]).text()), v = num($(c[vi]).text());
        if (!m || v == null) continue;
        var lo = num(m[1]), hi = num(m[2]);
        if (v < lo || v > hi) { c[vi].className += ' pp-out'; c[vi].innerHTML += v < lo ? ' &darr;' : ' &uarr;'; }
      }
    });
  }
  $(function () {
    var left = $('div[id^=ser_]').length;
    $('div[id^=ser_]').each(function () {
      $(this).addClass('pp-ser').load('/amb/view.s?id=' + this.id.substring(4), function () { if (--left == 0) ppStyle(); });
    });
    if (!left) ppStyle();
  });
</script>
</html>
