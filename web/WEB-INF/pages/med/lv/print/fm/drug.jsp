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
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
</style>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  НАЗНАЧЕНИЕ
</p>
<p style="width:95%; margin: auto; text-align: center;padding: 5px">
  <b>Бемор:</b> ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>Тугилган йили:</b> ${pat.birthyear}
  &nbsp;&nbsp;<b>Булим:</b> ${pat.dept.name}
  &nbsp;&nbsp;<b>Хона:</b> ${pat.room.name} - ${pat.room.roomType.name}
  &nbsp;&nbsp;<b>Стол:</b> ${table}

</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:1px">№</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Номи</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Б/С</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Т/С</td>
    <c:forEach items="${dates}" var="date">
      <td style="position:relative; border:1px solid #ababab;font-weight:bold;width:25px;padding:20px 0"><div style="position: absolute; top:12px; left:-3px; -webkit-transform: rotate(270deg);">${date}</div></td>
    </c:forEach>
  </tr>
  <tr><td colspan="16" style="font-weight:bold;padding:5px;border:1px solid #ababab">Таблекалар</td></tr>
  <c:if test="${fn:length(tabs) > 0}">
    <c:forEach items="${tabs}" var="drug" varStatus="loop">
      <tr>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">${loop.index + 1}</td>
        <td style="border:1px solid #ababab" rowspan="2"><b>${drug.drugName};</b> (${drug.note}; Вакти: <c:if test="${drug.morningTime}">Эрталаб;</c:if><c:if test="${drug.noonTime}">Тушлик;</c:if><c:if test="${drug.eveningTime}">Кечкурун;</c:if>)</td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.startDate}"/></td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
        <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
          <td style="border:1px solid #ababab">&nbsp;</td>
        </c:forEach>
      </tr>
      <tr>
        <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
          <td style="border:1px solid #ababab">&nbsp;</td>
        </c:forEach>
      </tr>
    </c:forEach>
  </c:if>
  <c:forEach begin="${fn:length(tabs) + 1}" end="${fn:length(tabs) + 5}" step="1" var="extra">
    <tr>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">${extra}</td>
      <td style="border:1px solid #ababab" rowspan="2">&nbsp;</td>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
      <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
    <tr>
      <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
  </c:forEach>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Хамшира имзоси</td>
    <c:forEach var="i" begin="0" end="13" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr><td colspan="16" style="padding:10px">&nbsp;</td></tr>
  <tr>
    <td colspan="16" style="padding:10px;text-align: center;"><b>Даволовчи шифокор: <u>${lv}</u></b></td>
  </tr>
</table>
<p style="page-break-after:always"></p>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  НАЗНАЧЕНИЕ
</p>
<p style="width:95%; margin: auto; text-align: center;padding: 5px">
  <b>Бемор:</b> ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>Тугилган йили:</b> ${pat.birthyear}
  &nbsp;&nbsp;<b>Булим:</b> ${pat.dept.name}
  &nbsp;&nbsp;<b>Хона:</b> ${pat.room.name} - ${pat.room.roomType.name}
  &nbsp;&nbsp;<b>Стол:</b> ${table}

</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <c:if test="${fn:length(ines) > 0}">
    <tr>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:1px">№</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Номи</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Б/С</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Т/С</td>
      <c:forEach items="${dates}" var="date">
        <td style="position:relative; border:1px solid #ababab;font-weight:bold;width:25px;padding:20px 0"><div style="position: absolute; top:12px; left:-3px; -webkit-transform: rotate(270deg);">${date}</div></td>
      </c:forEach>
    </tr>
    <tr><td colspan="16" style="font-weight:bold;padding:5px;border:1px solid #ababab">Инъекциялар</td></tr>
    <c:forEach items="${ines}" var="drug" varStatus="loop">
      <tr>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">${loop.index + 1}</td>
        <td style="border:1px solid #ababab" rowspan="2"><b>${drug.drugName};</b>(${drug.note}; Вакти: <c:if test="${drug.morningTime}">Эрталаб;</c:if><c:if test="${drug.noonTime}">Тушлик;</c:if><c:if test="${drug.eveningTime}">Кечаси;</c:if>)</td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.startDate}"/></td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
        <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
          <td style="border:1px solid #ababab">&nbsp;</td>
        </c:forEach>
      </tr>
      <tr>
        <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
          <td style="border:1px solid #ababab">&nbsp;</td>
        </c:forEach>
      </tr>
    </c:forEach>
  </c:if>
  <c:forEach begin="${fn:length(ines) + 1}" end="${fn:length(ines) + 5}" step="1" var="extra">
    <tr>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">${extra}</td>
      <td style="border:1px solid #ababab" rowspan="2">&nbsp;</td>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
      <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
    <tr>
      <c:forEach var="i" begin="0" end="11" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
  </c:forEach>

  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Спирт 70%</td>
    <c:forEach var="i" begin="0" end="13" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Пахта</td>
    <c:forEach var="i" begin="0" end="13" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Хамшира имзоси</td>
    <c:forEach var="i" begin="0" end="13" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr><td colspan="16" style="padding:10px">&nbsp;</td></tr>
  <tr>
    <td colspan="16" style="padding:10px;text-align: center;"><b>Даволовчи шифокор: <u>${lv}</u></b></td>
  </tr>
</table>