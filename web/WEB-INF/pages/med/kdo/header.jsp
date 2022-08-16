<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=Windows-1251");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<html>
<head></head>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>
<body style="background:white;">
<c:if test="${print}">
  <div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee;">
    <table width="100%" >
      <tr>
        <td class="bold"><div style="font-size:20px; margin-top: -10px; color: #337ab7">${patFio}</div></td>
        <td width="500px" class="right">
          <ul class="pagination" style="margin-top: 5px">
            <c:if test="${!isArchive}">
              <li class="paginate_button" tabindex="0"><a href="#" onclick="save(); return false;"><i title="Сохранить" class="fa fa-print"></i> Сохранить</a></li>
              <c:if test="${plan.resultId > 0 && plan.isDone != 'Y'}">
                <li class="paginate_button bold" tabindex="0"><a href="#" onclick="conf(); return false;"><i title="Подтвердить" class="fa fa-print"></i> Подтвердить</a></li>
              </c:if>
              <c:if test="${plan.resultId > 0}">
                <li class="paginate_button" tabindex="0"><a href="#" onclick="printPage(); return false;"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
              </c:if>
              <li class="paginate_button" tabindex="0"><a href="#" onclick="parent.setPage('/patients/list.s'); return false;"><i title="Назад" class="fa fa-arrow-left"></i> Назад</a></li>
            </c:if>
            <c:if test="${isArchive}">
              <li class="paginate_button" tabindex="0"><a href="#" onclick="printPage(); return false;"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
              <li class="paginate_button" tabindex="0"><a href="#" onclick="parent.setPage('/patients/archive.s'); return false;"><i title="Назад" class="fa fa-arrow-left"></i> Назад</a></li>
            </c:if>
          </ul>
        </td>
      </tr>
    </table>
  </div>
</c:if>
<iframe style="display: none" name="frm"></iframe>
<%@include file="/incs/msgs/successError.jsp"%>
<form action='save.s?planId=${plan.id}' id="formAction" name="formAction" method="post" target="frm">
  <c:if test="${!print}">
    <style>
      * {font-size:${sessionScope.fontSize}px !important;}
    </style>
  </c:if>
  <table id="obs" style="border-spacing: 0;border-collapse: collapse; <c:if test="${print}">width:${plan.kdo.cssWidth}px;</c:if><c:if test="${!print}">width:96%;</c:if> margin:auto">
    <c:if test="${form.shapka && !print && idx == ''}">
      <tr>
        <td align=center style="padding:10px; border:1px solid #ababab;font-weight:bold">
          ${idx}
          <div style="float:left;text-align:left;">${form.shapka_left}</div>
          <div style="float:right;text-align:right;">${form.shapka_right}</div>
        </td>
      </tr>
    </c:if>
    <c:if test="${idx == 0 || idx == ''}">
      <tr>
        <td style="border:1px solid #ababab">${patInfo}</td>
      </tr>
    </c:if>
    <tr>
      <td align=center style="padding:10px; border:1px solid #ababab;position: relative">
        <div style="position: absolute; right:10px; font-size: 12px !important; font-weight: bold">Дата: <fmt:formatDate pattern="dd.MM.yyyy" value="${plan.resDate}"/></div>
        <b>${plan.kdo.name}</b>
      </td>
    </tr>
    <tr>
      <td style="">
        <table width="100%" style="margin-top:-2px; border-spacing: 0;border-collapse: collapse; font-size: 12px;">
