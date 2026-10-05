<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
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
  .osmp .doc-title { text-align:center; font-size:${fs + 5}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; text-transform:uppercase; }
  .osmp .info td { border:1px solid #888; padding:5px 9px; }
  .osmp .info .l { width:17%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:33%; font-weight:bold; }
  .osmp .tbl { margin-top:14px; }
  .osmp .tbl th { border:1px solid #888; background:#f3f3f3; padding:6px 9px; font-size:${fs - 1}px; text-transform:uppercase; letter-spacing:.3px; text-align:center; vertical-align:middle; }
  .osmp .tbl td { border:1px solid #888; padding:6px 9px; }
  .osmp .tbl .c { text-align:center; }
  .osmp .tbl .nm { font-weight:bold; }
  .osmp .tbl .pl { font-weight:normal; color:#555; margin:0 4px; }
  .osmp .sign { margin-top:34px; }
  .osmp .sign td { padding:12px 0 4px 0; vertical-align:bottom; }
  .osmp .sign .line { border-bottom:1px solid #000; width:34%; }
  .osmp tr { page-break-inside:avoid; }
</style>
<div class="osmp">
  <div class="doc-title">Обоснование препаратов</div>

  <table class="info">
    <tr>
      <td class="l">Пациент</td>
      <td class="v" colspan="3">${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
    </tr>
    <tr>
      <td class="l">Год рождения</td>
      <td class="v">${pat.birthyear}</td>
      <td class="l">ИБ №</td>
      <td class="v">${pat.yearNum}</td>
    </tr>
  </table>

  <table class="tbl">
    <tr>
      <th style="width:36px">№</th>
      <th>Наименование</th>
      <th style="width:90px">Дата начала</th>
      <th style="width:150px">Цель</th>
      <th style="width:150px">Доза</th>
    </tr>
    <c:forEach items="${list}" var="drug" varStatus="lp">
      <tr>
        <td class="c">${lp.index + 1}</td>
        <td class="nm"><c:forEach items="${drug.rows}" var="row" varStatus="loop">${row.name}<c:if test="${loop.index + 1 < fn:length(drug.rows)}"><span class="pl">+</span></c:if></c:forEach></td>
        <td class="c"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateBegin}"/></td>
        <td class="c">${drug.goal.name}</td>
        <td class="c">${drug.note}</td>
      </tr>
    </c:forEach>
  </table>

  <table class="sign">
    <tr>
      <td style="width:20%"><b>Лечащий врач</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${lvFio}</td>
    </tr>
  </table>
</div>
