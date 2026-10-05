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
  <div class="doc-title">ТЕКШИРУВЛАР</div>

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
      <th style="width:36px">№</th>
      <th>Номи</th>
      <th style="width:90px">Сана</th>
      <th>Маълумотлар</th>
    </tr>
    <c:forEach items="${plans}" var="p" varStatus="loop">
      <tr>
        <td class="c">${loop.index + 1}</td>
        <td>${p.c4}</td>
        <td class="c">${p.c5}</td>
        <td>${p.c6}</td>
      </tr>
    </c:forEach>
    <c:forEach items="${consuls}" var="c">
      <tr>
        <td class="c">-</td>
        <td>Консультация: ${c.copied} - ${c.lvName}</td>
        <td class="c">${c.date}</td>
        <td>&nbsp;</td>
      </tr>
    </c:forEach>
  </table>
</div>
