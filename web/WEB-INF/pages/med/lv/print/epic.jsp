<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
  .osmp { width:100%; max-width:790px; margin:0 auto; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs}px; color:#000; line-height:1.4; }
  .osmp table { border-collapse:collapse; width:100%; }
  .osmp td, .osmp th { color:#000; vertical-align:top; }
  .osmp .doc-title { text-align:center; font-size:${fs + 5}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .osmp .info td { border:1px solid #888; padding:5px 9px; }
  .osmp .info .l { width:17%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:33%; font-weight:bold; }
  .osmp .tbl { margin-top:14px; }
  .osmp .tbl th { border:1px solid #888; background:#f3f3f3; padding:6px 9px; font-size:${fs - 1}px; text-transform:uppercase; letter-spacing:.3px; text-align:center; }
  .osmp .tbl td { border:1px solid #888; padding:6px 9px; }
  .osmp .tbl .c { text-align:center; white-space:nowrap; }
  .osmp tr { page-break-inside:avoid; }
</style>
<div class="osmp">
  <div class="doc-title">УТКАЗИЛИШ ЭПИКРИЗИ</div>

  <table class="info">
    <tr>
      <td class="l">Бемор</td>
      <td class="v" colspan="3">${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
    </tr>
    <tr>
      <td class="l">Тугилган йили</td>
      <td class="v">${pat.birthyear}</td>
      <td class="l">ИБ №</td>
      <td class="v">${pat.yearNum}</td>
    </tr>
  </table>

  <table class="tbl">
    <tr>
      <th colspan="2">Давр</th>
      <th rowspan="2">Булим</th>
      <th rowspan="2">Хона</th>
      <th rowspan="2">Шифокор</th>
    </tr>
    <tr>
      <th>дан</th>
      <th>гача</th>
    </tr>
    <c:forEach items="${epics}" var="e">
      <tr>
        <td class="c">${e.c1}</td>
        <td class="c">${e.c2}</td>
        <td>${e.c3}</td>
        <td class="c">${e.c4}</td>
        <td>${e.c5}</td>
      </tr>
    </c:forEach>
  </table>
</div>
