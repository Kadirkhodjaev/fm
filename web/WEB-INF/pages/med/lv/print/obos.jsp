<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<%-- Разделы до диагноза и их заголовки --%>
<c:set var="mainKeys" value="c1,c2,c3,c4"/>
<c:set var="mainTitles" value="${fn:split('Шикоятлари|Anamnez|Status praesens|Текширув ва тахлиллар', '|')}"/>
<%-- Диагноз: основной, сопутствующий, осложнения --%>
<c:set var="dxKeys" value="c5,c6,c7"/>
<c:set var="dxTitles" value="${fn:split('Асосий|Хамрох|Асорати', '|')}"/>
<style>
  .osmp { width:100%; max-width:790px; margin:0 auto; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs + 2}px; color:#000; line-height:1.35; }
  .osmp table { border-collapse:collapse; width:100%; }
  /* В таблицах шрифт наследуется: без doctype браузер иначе ставит в td свой размер 16px */
  .osmp table, .osmp td { font-size:inherit; }
  .osmp td { color:#000; vertical-align:top; }
  .osmp .doc-title { text-align:center; font-size:${fs + 6}px; font-weight:bold; letter-spacing:.6px; padding:0 0 2px 0; }
  .osmp .doc-date { text-align:center; color:#444; padding:0 0 10px 0; }
  .osmp .info td { border:1px solid #888; padding:3px 8px; }
  .osmp .info .l { width:17%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:33%; font-weight:bold; }
  .osmp .sec-h { font-weight:bold; padding:8px 0 2px 0; border-bottom:1px solid #888; text-transform:uppercase; font-size:${fs - 1}px; letter-spacing:.4px; }
  .osmp .sec-b { padding:3px 0 1px 0; text-align:justify; }
  .osmp .grp-h { font-weight:bold; padding:10px 0 2px 0; border-bottom:2px solid #000; text-transform:uppercase; letter-spacing:.4px; }
  .osmp .dx-h { font-weight:bold; padding:5px 0 0 0; }
  .osmp .sign { margin-top:20px; }
  .osmp .sign td { padding:8px 0 3px 0; vertical-align:bottom; }
  .osmp .sign .line { border-bottom:1px solid #000; width:34%; }
  .osmp p { margin:0 0 3px 0; }
  .osmp ul, .osmp ol { margin:2px 0 4px 20px; padding:0; }
  /* Не разрываем только шапку и подписи. Разделы должны переноситься на следующую страницу по строкам. */
  .osmp .info tr, .osmp .sign tr { page-break-inside:avoid; break-inside:avoid; }
  /* Заголовок раздела не остаётся внизу страницы отдельно от текста */
  .osmp .sec-h, .osmp .grp-h, .osmp .dx-h { page-break-after:avoid; break-after:avoid; }
  @media print { .osmp { max-width:none; } }
</style>
<div class="osmp">
  <div class="doc-title">КЛИНИК ТАШХИСНИ АСОСЛАШ</div>
  <div class="doc-date">Сана: ${form.c8}</div>

  <table class="info">
    <tr>
      <td class="l">Бемор</td>
      <td class="v" colspan="3">${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    </tr>
    <tr>
      <td class="l">Тугилган йили</td>
      <td class="v">${form.patient.birthyear}</td>
      <td class="l">ИБ №</td>
      <td class="v">${form.patient.yearNum}</td>
    </tr>
    <tr>
      <td class="l">Бўлим</td>
      <td class="v">${form.patient.dept.name}</td>
      <td class="l">Палата</td>
      <td class="v">${form.patient.room.name}</td>
    </tr>
    <tr>
      <td class="l">Ётқизилган сана</td>
      <td class="v" colspan="3"><fmt:formatDate pattern="dd.MM.yyyy" value="${form.patient.dateBegin}"/></td>
    </tr>
  </table>

  <%-- жалобы, анамнез, статус, обследования --%>
  <div>
    <c:forTokens items="${mainKeys}" delims="," var="k" varStatus="st">
      <c:set var="v" value="${form[k]}"/>
      <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
        <div class="sec-h">${mainTitles[st.index]}</div>
        <div class="sec-b">${v}</div>
      </c:if>
    </c:forTokens>
  </div>

  <%-- диагноз --%>
  <c:set var="hasDx" value="false"/>
  <c:forTokens items="${dxKeys}" delims="," var="k">
    <c:set var="v" value="${form[k]}"/>
    <c:if test="${not empty fn:trim(v) and v ne '<br>'}"><c:set var="hasDx" value="true"/></c:if>
  </c:forTokens>
  <c:if test="${hasDx}">
    <div>
      <div class="grp-h">Ташхис</div>
      <c:forTokens items="${dxKeys}" delims="," var="k" varStatus="st">
        <c:set var="v" value="${form[k]}"/>
        <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
          <div class="dx-h">${dxTitles[st.index]}:</div>
          <div class="sec-b">${v}</div>
        </c:if>
      </c:forTokens>
    </div>
  </c:if>

  <table class="sign">
    <tr>
      <td style="width:24%"><b>Даволовчи шифокор</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${lvFio}</td>
    </tr>
    <tr>
      <td style="width:24%"><b>Булим бошлиги</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${form.patient.zavlv.fio}</td>
    </tr>
  </table>
</div>
