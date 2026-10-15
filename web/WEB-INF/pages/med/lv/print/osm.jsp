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
<%-- Основные разделы осмотра (полная ширина) и их заголовки --%>
<c:set var="mainKeys" value="c1,c2,c8,c3"/>
<c:set var="mainTitles" value="${fn:split('Шикоятлари|Anamnesis morbi|Anamnesis vitae|Status praesens', '|')}"/>
<%-- Системы органов (компактная таблица: слева название, справа текст) --%>
<c:set var="sysKeys" value="c9,c10,c11,c12,c13,c14,c15,c16"/>
<c:set var="sysTitles" value="${fn:split('Нафас олиш системаси|Қон айланиш системаси|Хазм қилиш системаси|Сийдик-таносил системаси|Нерв системаси|Эндокрин системаси|Қалқонсимон без|Меъда ости бези', '|')}"/>
<%-- Заключительные разделы --%>
<c:set var="endKeys" value="c4,c5,c18,c19"/>
<c:set var="endTitles" value="${fn:split('Стационар даволанишдан олдинги муолажалар|Тахминий ташхис: Асосий|Тахминий ташхис: Хамрох|Тахминий ташхис: Асорати', '|')}"/>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
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
  .osmp .sys td { padding:3px 8px 3px 0; border-bottom:1px dotted #aaa; }
  .osmp .sys .lab { width:24%; font-weight:bold; }
  .osmp .sys .txt { text-align:justify; }
  .osmp .sign { margin-top:20px; }
  .osmp .sign td { padding:4px 0; vertical-align:bottom; }
  .osmp .sign .line { border-bottom:1px solid #000; width:34%; }
  .osmp p { margin:0 0 3px 0; }
  .osmp ul, .osmp ol { margin:2px 0 4px 20px; padding:0; }
  /* Не разрываем только шапку и подписи. Разделы должны переноситься на следующую страницу по строкам. */
  .osmp .info tr, .osmp .sign tr { page-break-inside:avoid; break-inside:avoid; }
  /* Заголовок раздела не остаётся внизу страницы отдельно от текста */
  .osmp .sec-h, .osmp .grp-h, .osmp .dx-h { page-break-after:avoid; break-after:avoid; }
  /* Длинный текст системы органов (например, нервная система) тоже может переноситься */
  .osmp .sys tr, .osmp .sys td { page-break-inside:auto; break-inside:auto; }
  @media print { .osmp { max-width:none; } }
</style>
<div class="osmp">
  <div class="doc-title">БЎЛИМДАГИ КЎРИК</div>
  <div class="doc-date">Сана: ${form.c7}</div>

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

  <%-- основные разделы --%>
  <div>
    <c:forTokens items="${mainKeys}" delims="," var="k" varStatus="st">
      <c:set var="v" value="${form[k]}"/>
      <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
        <div class="sec-h">${mainTitles[st.index]}</div>
        <div class="sec-b">${v}</div>
      </c:if>
    </c:forTokens>
  </div>

  <%-- системы органов --%>
  <c:set var="hasSys" value="false"/>
  <c:forTokens items="${sysKeys}" delims="," var="k">
    <c:set var="v" value="${form[k]}"/>
    <c:if test="${not empty fn:trim(v) and v ne '<br>'}"><c:set var="hasSys" value="true"/></c:if>
  </c:forTokens>
  <c:if test="${hasSys}">
    <div>
      <div class="grp-h">Органлар ва системалар текшируви</div>
    </div>
    <table class="sys">
      <c:forTokens items="${sysKeys}" delims="," var="k" varStatus="st">
        <c:set var="v" value="${form[k]}"/>
        <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
          <tr>
            <td class="lab">${sysTitles[st.index]}</td>
            <td class="txt">${v}</td>
          </tr>
        </c:if>
      </c:forTokens>
    </table>
  </c:if>

  <%-- заключительные разделы --%>
  <div>
    <c:forTokens items="${endKeys}" delims="," var="k" varStatus="st">
      <c:set var="v" value="${form[k]}"/>
      <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
        <div class="sec-h">${endTitles[st.index]}</div>
        <div class="sec-b">${v}</div>
      </c:if>
    </c:forTokens>
  </div>

  <table class="sign">
    <tr>
      <td style="width:14%"><b>Шифокор:</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${lvFio}</td>
    </tr>
  </table>
</div>
