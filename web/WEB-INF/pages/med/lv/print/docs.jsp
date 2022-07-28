<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
  .text-size-2 * {font-size:${sessionScope.fontSize - 2}px !important;}
  table, p, div { width:95% !important; max-width: 95% !important; margin:auto}
</style>
<%@include file="docs/reg.jsp"%>
<p style="page-break-after:always"></p>
<%@include file="docs/extra.jsp"%>
<p style="page-break-after:always"></p>
<%@include file="docs/osm.jsp"%>