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
  <b>Пациент:</b> №${pat.yearNum} - ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>Год рождения:</b> ${pat.birthyear}
  &nbsp;&nbsp;<b>Отделение:</b> ${pat.dept.name}
  &nbsp;&nbsp;<b>Палата:</b> ${pat.room.name}
  &nbsp;&nbsp;<b>Диета №:</b> ${tableNum.name}
</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:1px">№</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Наименование</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Дата нач</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Дата окон</td>
    <c:forEach items="${dates}" var="date">
      <td style="position:relative; border:1px solid #ababab;font-weight:bold;width:25px;padding:20px 0"><div style="position: absolute; top:12px; left:-3px; -webkit-transform: rotate(270deg);">${date}</div></td>
    </c:forEach>
  </tr>
  <tr><td colspan="${fn:length(dates) + 4}" style="font-weight:bold;padding:5px;border:1px solid #ababab">Таблетки</td></tr>
  <c:if test="${fn:length(tabs) > 0}">
    <c:forEach items="${tabs}" var="drug" varStatus="loop">
      <tr>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">${loop.index + 1}</td>
        <td style="border:1px solid #ababab" rowspan="2">
          <b>
            <c:forEach items="${drug.rows}" var="row" varStatus="loop">
              <c:if test="${row.source == 'own'}">
                <u>${row.name}</u>
              </c:if>
              <c:if test="${row.source != 'own'}">
                ${row.name}
              </c:if>
              <c:if test="${loop.index + 1 < fn:length(drug.rows)}"> + </c:if>
            </c:forEach>
          </b> (${drug.note})
        </td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateBegin}"/></td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateEnd}"/></td>
        <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
          <td style="border:1px solid #ababab; vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${drug.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.checked}">+</c:if></c:forEach>&nbsp;</td>
        </c:forEach>
      </tr>
      <tr>
        <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
          <td style="border:1px solid #ababab; vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${drug.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.disabled}">+</c:if></c:forEach>&nbsp;</td>
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
      <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
    <tr>
      <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
  </c:forEach>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Подпись медсестры</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 2}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr><td colspan="${fn:length(dates) + 5}" style="padding:10px">&nbsp;</td></tr>
  <tr>
    <td colspan="${fn:length(dates) + 5}" style="padding:10px;text-align: center;"><b>Лечащий врач: <u>${lv}</u></b></td>
  </tr>
</table>
<p style="page-break-after:always"></p>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  НАЗНАЧЕНИЕ
</p>
<p style="width:95%; margin: auto; text-align: center;padding: 5px">
  <b>Пациент:</b> №${pat.yearNum} - ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>Год рождения:</b> ${pat.birthyear}
  &nbsp;&nbsp;<b>Отделение:</b> ${pat.dept.name}
  &nbsp;&nbsp;<b>Палата:</b> ${pat.room.name}
  &nbsp;&nbsp;<b>Диета №:</b> ${tableNum.name}
</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:1px">№</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Наимнеование</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Время</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Дата нач</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Дата окон</td>
    <c:forEach items="${dates}" var="date">
      <td style="position:relative; border:1px solid #ababab;font-weight:bold;width:25px;padding:20px 0"><div style="position: absolute; top:12px; left:-3px; -webkit-transform: rotate(270deg);">${date}</div></td>
    </c:forEach>
  </tr>
  <tr><td colspan="${fn:length(dates) + 5}" style="font-weight:bold;padding:5px;border:1px solid #ababab">Инъекции</td></tr>
  <c:if test="${fn:length(ines) > 0}">
    <c:forEach items="${ines}" var="drug" varStatus="loop">
      <tr>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2">${loop.index + 1}</td>
        <td style="border:1px solid #ababab" rowspan="2">
          <b>
            <c:forEach items="${drug.rows}" var="row" varStatus="loop">
              <c:if test="${row.source == 'own'}">
                <u>${row.name}</u>
              </c:if>
              <c:if test="${row.source != 'own'}">
                ${row.name}
              </c:if>
              <c:if test="${loop.index + 1 < fn:length(drug.rows)}"> + </c:if>
            </c:forEach>
          </b> (${drug.note})<c:if test="${drug.injectionType != null}"> - ${drug.injectionType.name}</c:if>
        </td>
        <td style="border:1px solid #ababab" rowspan="2">&nbsp;</td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateBegin}"/></td>
        <td style="border:1px solid #ababab;text-align:center" rowspan="2"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateEnd}"/></td>
        <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
          <td style="border:1px solid #ababab; vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${drug.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.checked}">+</c:if></c:forEach>&nbsp;</td>
        </c:forEach>
      </tr>
      <tr>
        <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
          <td style="border:1px solid #ababab; vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${drug.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.disabled}">+</c:if></c:forEach>&nbsp;</td>
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
      <td style="border:1px solid #ababab;text-align:center" rowspan="2">&nbsp;</td>
      <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
    <tr>
      <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
        <td style="border:1px solid #ababab">&nbsp;</td>
      </c:forEach>
    </tr>
  </c:forEach>

  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Спирт 70%</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Вата</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Шприц</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Система</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Перчатка</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr>
    <td style="border:1px solid #ababab;padding: 4px" colspan="2">Подпись медсестры</td>
    <c:forEach var="i" begin="1" end="${fn:length(dates) + 3}" step="1" varStatus="loop">
      <td style="border:1px solid #ababab">&nbsp;</td>
    </c:forEach>
  </tr>
  <tr><td colspan="${fn:length(dates) + 5}" style="padding:10px">&nbsp;</td></tr>
  <tr>
    <td colspan="${fn:length(dates) + 5}" style="padding:10px;text-align: center;"><b>Лечащий врач: <u>${lv}</u></b></td>
  </tr>
</table>
