<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<style>
  .osmp { width:100%; margin:0 auto; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs}px; color:#000; line-height:1.35; }
  .osmp table { border-collapse:collapse; width:100%; }
  .osmp td, .osmp th { color:#000; vertical-align:top; }
  .osmp .doc-title { text-align:center; font-size:${fs + 5}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .osmp .info td { border:1px solid #888; padding:5px 9px; }
  .osmp .info .l { width:17%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:33%; font-weight:bold; }
  .osmp .tbl { margin-top:14px; }
  .osmp .tbl th { border:1px solid #888; background:#f3f3f3; padding:5px 4px; font-size:${fs - 2}px; text-align:center; vertical-align:middle; }
  .osmp .tbl td { border:1px solid #888; padding:6px 6px; }
  .osmp .tbl .name .t { font-weight:bold; }
  .osmp .tbl .name .s { font-size:${fs - 1}px; color:#333; }
  .osmp .tbl .c { text-align:center; vertical-align:middle; }
  .osmp .tbl .d { text-align:center; vertical-align:middle; font-weight:bold; width:34px; padding:6px 2px; }
  .osmp .tbl .sig { width:90px; }
  .osmp tr { page-break-inside:avoid; }
</style>
<div class="osmp">
  <div class="doc-title">ФИЗИОТЕРАПИЯ</div>

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
    <tr>
      <td class="l">Бўлим</td>
      <td class="v">${pat.dept.name}</td>
      <td class="l">Хона</td>
      <td class="v">${pat.room.name}<c:if test="${not empty pat.room.roomType.name}"> - ${pat.room.roomType.name}</c:if></td>
    </tr>
  </table>

  <table class="tbl">
    <tr>
      <th style="text-align:left">Муолажа</th>
      <th style="width:50px">Сони</th>
      <c:forEach items="${dates}" var="date">
        <th class="d"><fmt:formatDate pattern="dd.MM" value="${date.date}"/></th>
      </c:forEach>
      <th class="sig">Бемор имзоси</th>
      <th class="sig">Хамшира</th>
    </tr>
    <c:forEach items="${pfizios}" var="fizio">
      <tr>
        <td class="name">
          <div class="t">${fizio.c1}</div>
          <c:if test="${not empty fizio.c2 or not empty fizio.c3}">
            <div class="s">${fizio.c2}<c:if test="${not empty fizio.c2 and not empty fizio.c3}">; </c:if>${fizio.c3}</div>
          </c:if>
        </td>
        <td class="c">${fizio.counter}</td>
        <c:forEach items="${ds[fizio.id]}" var="date">
          <td class="d"><c:if test="${date.state == 'Y'}">+</c:if>&nbsp;</td>
        </c:forEach>
        <td class="sig">&nbsp;</td>
        <td class="sig">&nbsp;</td>
      </tr>
    </c:forEach>
  </table>
</div>
