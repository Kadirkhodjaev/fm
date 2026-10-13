<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%-- Лист назначения по прежней схеме (LvDrugs: таблетки и инъекции) — для старых пациентов.
     Два листа: таблетки и инъекции; у каждого препарата две строки клеток по дням для отметок медсестры --%>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<c:set var="days" value="${empty dates ? 12 : fn:length(dates)}"/>
<style>
  .dgp { width:100%; max-width:1000px; margin:0 auto; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs}px; color:#000; line-height:1.35; }
  .dgp table { border-collapse:collapse; width:100%; }
  .dgp table, .dgp td, .dgp th { font-size:inherit; }
  .dgp .doc-title { text-align:center; font-size:${fs + 6}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .dgp .info td { border:1px solid #888; padding:3px 8px; }
  .dgp .info .l { width:14%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .dgp .info .v { font-weight:bold; }
  .dgp .grid { margin-top:12px; }
  .dgp .grid th, .dgp .grid td { border:1px solid #888; padding:3px 5px; vertical-align:middle; }
  .dgp .grid th { background:#f3f3f3; font-weight:bold; text-align:center; }
  .dgp .grid th.day { width:24px; height:62px; padding:2px 0; }
  .dgp .grid th.day span { display:inline-block; writing-mode:vertical-rl; transform:rotate(180deg); font-size:${fs - 2}px; font-weight:normal; white-space:nowrap; }
  .dgp .grid .sec td { font-weight:bold; text-transform:uppercase; letter-spacing:.4px; background:#fafafa; }
  .dgp .grid .n { width:28px; text-align:center; }
  .dgp .grid .dt { width:82px; text-align:center; white-space:nowrap; }
  .dgp .grid .cell { height:18px; }
  .dgp .grid .mut { color:#444; font-size:${fs - 1}px; }
  .dgp .sign { margin-top:18px; text-align:center; font-weight:bold; }
  .dgp tr { page-break-inside:avoid; break-inside:avoid; }
  .dgp .page { page-break-after:always; break-after:page; }
  .dgp .page:last-child { page-break-after:auto; break-after:auto; }
  .dgp .page + .page { margin-top:30px; }
  @media print { .dgp { max-width:none; } .dgp .page + .page { margin-top:0; } }
</style>
<div class="dgp">
  <c:forEach items="tabs,ines" var="kind">
    <c:set var="list" value="${kind == 'tabs' ? tabs : ines}"/>
    <div class="page">
      <div class="doc-title">НАЗНАЧЕНИЕ</div>
      <table class="info">
        <tr>
          <td class="l">Бемор</td><td class="v">${pat.surname} ${pat.name} ${pat.middlename}</td>
          <td class="l">Тугилган йили</td><td class="v">${pat.birthyear}</td>
        </tr>
        <tr>
          <td class="l">Булим</td><td class="v">${pat.dept.name}</td>
          <td class="l">Хона</td><td class="v">${pat.room.name}<c:if test="${not empty pat.room.roomType.name}"> - ${pat.room.roomType.name}</c:if></td>
        </tr>
      </table>
      <table class="grid">
        <tr>
          <th class="n">№</th>
          <th>Номи</th>
          <th class="dt">Б/С</th>
          <th class="dt">Т/С</th>
          <c:if test="${not empty dates}"><c:forEach items="${dates}" var="date"><th class="day"><span>${date}</span></th></c:forEach></c:if>
          <c:if test="${empty dates}"><c:forEach begin="1" end="${days}"><th class="day"></th></c:forEach></c:if>
        </tr>
        <tr class="sec"><td colspan="${days + 4}">${kind == 'tabs' ? 'Таблеткалар' : 'Инъекциялар'}</td></tr>
        <c:forEach items="${list}" var="drug" varStatus="loop">
          <tr>
            <td class="n" rowspan="2">${loop.index + 1}</td>
            <td rowspan="2">
              <b>${drug.drugName}</b><c:if test="${kind == 'ines' && not empty drug.cat}">, ${drug.cat}</c:if>
              <div class="mut">
                <c:if test="${not empty drug.note}">${drug.note}; </c:if>Вакти:
                <c:if test="${drug.morningTime}">эрталаб;</c:if><c:if test="${drug.noonTime}">тушлик;</c:if><c:if test="${drug.eveningTime}">${kind == 'tabs' ? 'кечкурун' : 'кечаси'};</c:if>
              </div>
            </td>
            <td class="dt" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.startDate}"/></td>
            <td class="dt" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.endDate}"/></td>
            <c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach>
          </tr>
          <tr><c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach></tr>
        </c:forEach>
        <%-- пустые строки для дописывания от руки --%>
        <c:forEach begin="${fn:length(list) + 1}" end="${fn:length(list) + 5}" var="extra">
          <tr>
            <td class="n" rowspan="2">${extra}</td>
            <td rowspan="2">&nbsp;</td><td class="dt" rowspan="2"></td><td class="dt" rowspan="2"></td>
            <c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach>
          </tr>
          <tr><c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach></tr>
        </c:forEach>
        <c:if test="${kind == 'ines'}">
          <tr><td colspan="4">Спирт 70%</td><c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach></tr>
          <tr><td colspan="4">Пахта</td><c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach></tr>
        </c:if>
        <tr><td colspan="4">Хамшира имзоси</td><c:forEach begin="1" end="${days}"><td class="cell"></td></c:forEach></tr>
      </table>
      <div class="sign">Даволовчи шифокор: <u>${lv}</u></div>
    </div>
  </c:forEach>
</div>
