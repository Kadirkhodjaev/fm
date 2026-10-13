<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Диагноз из выписки (печать «Диагноз»): клинический диагноз при поступлении и диагноз при выписке --%>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=diagnoz.doc;");
  }
%>
<c:set var="fs" value="${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}"/>
<c:set var="dx1Keys" value="c1,c8,c9"/>
<c:set var="dx2Keys" value="c10,c11,c12"/>
<c:set var="dxTitles" value="${fn:split('Асосий|Хамрох|Асорати', '|')}"/>
<style>
  .dxp { width:100%; max-width:790px; margin:0 auto; font-family:Arial, 'Segoe UI', sans-serif; font-size:${fs + 2}px; color:#000; line-height:1.35; }
  .dxp table { border-collapse:collapse; width:100%; }
  .dxp table, .dxp td { font-size:inherit; }
  .dxp .doc-title { text-align:center; font-size:${fs + 6}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .dxp .info td { border:1px solid #888; padding:3px 8px; }
  .dxp .info .l { width:19%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .dxp .info .v { font-weight:bold; }
  .dxp .grp-h { font-weight:bold; padding:10px 0 2px 0; border-bottom:2px solid #000; text-transform:uppercase; letter-spacing:.4px; page-break-after:avoid; }
  .dxp .dx-h { font-weight:bold; padding:5px 0 0 0; page-break-after:avoid; }
  .dxp .sec-b { padding:3px 0 1px 0; text-align:justify; }
  .dxp .empty { padding:16px 0; color:#666; text-align:center; }
  @media print { .dxp { max-width:none; } }
</style>
<div class="dxp">
  <div class="doc-title">Ташхис</div>
  <c:choose>
    <c:when test="${empty form}"><div class="empty">Выписка ещё не заполнена</div></c:when>
    <c:otherwise>
      <table class="info">
        <tr>
          <td class="l">Бемор</td>
          <td class="v">${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
          <td class="l">ИБ №</td>
          <td class="v">${form.patient.yearNum}</td>
        </tr>
      </table>
      <c:forTokens items="dx1,dx2" delims="," var="grp">
        <c:set var="keys" value="${grp == 'dx1' ? dx1Keys : dx2Keys}"/>
        <c:set var="has" value="false"/>
        <c:forTokens items="${keys}" delims="," var="k">
          <c:set var="v" value="${form[k]}"/>
          <c:if test="${not empty fn:trim(v) and v ne '<br>'}"><c:set var="has" value="true"/></c:if>
        </c:forTokens>
        <c:if test="${has}">
          <div class="grp-h">${grp == 'dx1' ? 'Клиник ташхис' : 'Чиқарув вақтидаги ташхис'}</div>
          <c:forTokens items="${keys}" delims="," var="k" varStatus="st">
            <c:set var="v" value="${form[k]}"/>
            <c:if test="${not empty fn:trim(v) and v ne '<br>'}">
              <div class="dx-h">${dxTitles[st.index]}:</div>
              <div class="sec-b">${v}</div>
            </c:if>
          </c:forTokens>
        </c:if>
      </c:forTokens>
    </c:otherwise>
  </c:choose>
</div>
