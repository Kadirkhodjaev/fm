<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<%-- отступ сверху под фирменный бланк (было 110px) --%>
<c:set var="topGap" value="110"/>
<%-- клинический диагноз при поступлении --%>
<c:set var="dx1Keys" value="c1,c8,c9"/>
<%-- жалобы, анамнез, объективно, обследования, лечение --%>
<c:set var="mainKeys" value="c2,c3,c4,c5,c6"/>
<c:set var="mainTitles" value="${fn:split('Шикоятлар|Анамнез|Объектив|Утказилган текширувлар|Утказилган даволашлар', '|')}"/>
<%-- диагноз при выписке --%>
<c:set var="dx2Keys" value="c10,c11,c12"/>
<c:set var="dxTitles" value="${fn:split('Асосий|Хамрох|Асорати', '|')}"/>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
  .osmp { width:100%; max-width:790px; margin:0 auto; padding-top:${topGap}px; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs + 2}px; color:#000; line-height:1.35; }
  .osmp table { border-collapse:collapse; width:100%; }
  /* В таблицах шрифт наследуется: без doctype браузер иначе ставит в td свой размер 16px */
  .osmp table, .osmp td { font-size:inherit; }
  .osmp td { color:#000; vertical-align:top; }
  .osmp .org { text-align:center; font-weight:bold; font-size:${fs + 1}px; padding:0 0 2px 0; }
  .osmp .doc-title { text-align:center; font-size:${fs + 6}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .osmp .info td { border:1px solid #888; padding:3px 8px; }
  .osmp .info .l { width:19%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:31%; font-weight:bold; }
  .osmp .sec-h { font-weight:bold; padding:8px 0 2px 0; border-bottom:1px solid #888; text-transform:uppercase; font-size:${fs - 1}px; letter-spacing:.4px; }
  .osmp .sec-b { padding:3px 0 1px 0; text-align:justify; }
  .osmp .grp-h { font-weight:bold; padding:10px 0 2px 0; border-bottom:2px solid #000; text-transform:uppercase; letter-spacing:.4px; }
  .osmp .dx-h { font-weight:bold; padding:5px 0 0 0; }
  .osmp .sign { margin-top:20px; }
  .osmp .sign td { padding:8px 0 3px 0; vertical-align:bottom; }
  .osmp .sign .line { border-bottom:1px solid #000; width:30%; }
  .osmp p { margin:0 0 3px 0; }
  .osmp ul, .osmp ol { margin:2px 0 4px 20px; padding:0; }
  /* Не разрываем только шапку и подписи. Разделы выписки должны переноситься на следующую страницу по строкам. */
  .osmp .info tr, .osmp .sign tr { page-break-inside:avoid; break-inside:avoid; }
  /* Заголовок раздела не остаётся внизу страницы отдельно от текста */
  .osmp .sec-h, .osmp .grp-h, .osmp .dx-h { page-break-after:avoid; break-after:avoid; }
  .osmp .sec-b { page-break-inside:auto; break-inside:auto; }
  @media print { .osmp { max-width:none; } }
</style>
<div class="osmp">
  <div class="org">«Фарход Мадад Шифо» хусусий корхонаси</div>
  <div class="doc-title">Касаллик тарихидан кучирма № ${form.patient.yearNum}</div>

  <table class="info">
    <tr>
      <td class="l">Бемор</td>
      <td class="v" colspan="3">${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    </tr>
    <tr>
      <td class="l">Тугилган йили</td>
      <td class="v">${form.patient.birthyear}</td>
      <td class="l">Бўлим</td>
      <td class="v">${form.patient.dept.name}</td>
    </tr>
    <tr>
      <td class="l">Касалхонага келди</td>
      <td class="v">${dateBegin}</td>
      <td class="l">Касалхонадан кетди</td>
      <td class="v">${dateEnd}</td>
    </tr>
  </table>

  <%-- клинический диагноз --%>
  <c:set var="hasDx1" value="false"/>
  <c:forTokens items="${dx1Keys}" delims="," var="k">
    <c:set var="v" value="${form[k]}"/>
    <c:if test="${not empty fn:trim(v) and v ne '<br>'}"><c:set var="hasDx1" value="true"/></c:if>
  </c:forTokens>
  <c:if test="${hasDx1}">
    <div>
      <div class="grp-h">Клиник ташхис</div>
      <c:forTokens items="${dx1Keys}" delims="," var="k" varStatus="st">
        <c:set var="v" value="${form[k]}"/>
        <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
          <div class="dx-h">${dxTitles[st.index]}:</div>
          <div class="sec-b">${v}</div>
        </c:if>
      </c:forTokens>
    </div>
  </c:if>

  <%-- шикоятлар, анамнез, объектив, текширувлар, даволаш --%>
  <div>
    <c:forTokens items="${mainKeys}" delims="," var="k" varStatus="st">
      <c:set var="v" value="${form[k]}"/>
      <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
        <div class="sec-h">${mainTitles[st.index]}</div>
        <div class="sec-b">${v}</div>
      </c:if>
    </c:forTokens>
  </div>

  <%-- диагноз при выписке --%>
  <c:set var="hasDx2" value="false"/>
  <c:forTokens items="${dx2Keys}" delims="," var="k">
    <c:set var="v" value="${form[k]}"/>
    <c:if test="${not empty fn:trim(v) and v ne '<br>'}"><c:set var="hasDx2" value="true"/></c:if>
  </c:forTokens>
  <c:if test="${hasDx2}">
    <div>
      <div class="grp-h">Чиқарув вақтидаги ташхис</div>
      <c:forTokens items="${dx2Keys}" delims="," var="k" varStatus="st">
        <c:set var="v" value="${form[k]}"/>
        <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
          <div class="dx-h">${dxTitles[st.index]}:</div>
          <div class="sec-b">${v}</div>
        </c:if>
      </c:forTokens>
    </div>
  </c:if>

  <%-- рекомендации --%>
  <c:if test="${not empty fn:trim(form.c7) and form.c7 ne '<br>'}">
    <div>
      <div class="sec-h">Тавсия</div>
      <div class="sec-b">${form.c7}</div>
    </div>
  </c:if>

  <table class="sign">
    <tr>
      <td style="width:22%"><b>Даволовчи шифокор</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${lvFio}</td>
    </tr>
    <tr>
      <td style="width:22%"><b>Булим мудири</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${form.patient.zavlv.fio}</td>
    </tr>
    <tr>
      <td style="width:22%"><b>Бош шифокор</b></td>
      <td class="line">&nbsp;</td>
      <td style="width:4%">&nbsp;</td>
      <td style="text-align:right">${zamGlb}</td>
    </tr>
  </table>
</div>
