<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
  .osmp td { color:#000; vertical-align:top; }
  .osmp .doc-title { text-align:center; font-size:${fs + 5}px; font-weight:bold; letter-spacing:.6px; padding:0 0 10px 0; }
  .osmp .info td { border:1px solid #888; padding:5px 9px; }
  .osmp .info .l { width:17%; background:#f3f3f3; color:#333; font-size:${fs - 1}px; }
  .osmp .info .v { width:33%; font-weight:bold; }
  .osmp .rec { margin-top:14px; }
  .osmp .rec td { border:1px solid #888; padding:6px 10px; }
  .osmp .rec .h { background:#f3f3f3; font-weight:bold; }
  .osmp .rec .h span { font-weight:normal; color:#333; margin-left:14px; }
  .osmp .rec .b { text-align:justify; }
  .osmp .rec .s { text-align:right; border-top:0; padding-top:12px; }
  .osmp p { margin:0 0 3px 0; }
  .osmp ul, .osmp ol { margin:2px 0 4px 20px; padding:0; }
  .osmp .rec { page-break-inside:avoid; }
</style>
<div class="osmp">
  <div class="doc-title">КУНДАЛИКЛАР</div>

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

  <c:forEach items="${dairies}" var="d">
    <table class="rec">
      <tr>
        <td class="h">
          Сана: <b>${d.c2}</b>
          <c:if test="${not empty d.c3}"><span>Пульс (уд/мин): <b>${d.c3}</b></span></c:if>
          <c:if test="${not empty d.c6 or not empty d.c7}"><span>К/Б: <b>${d.c6} / ${d.c7}</b></span></c:if>
        </td>
      </tr>
      <tr><td class="b">${d.c5}</td></tr>
      <tr><td class="s">Шифокор: <b>${d.c8}</b> &nbsp; ______________</td></tr>
    </table>
  </c:forEach>
</div>
