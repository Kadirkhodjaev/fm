<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=Windows-1251");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<%-- frag: бланк без страницы, только таблица полей и данные (пакетный ввод, /kdo/batch.s) --%>
<c:if test="${!frag}">
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
<script src="/res/js/common.js?v=2026101309"></script>
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
              <li class="paginate_button" tabindex="0"><a href="#" onclick="save(); return false;"><i title="Сохранить" class="fa fa-floppy-o"></i> Сохранить</a></li>
              <c:if test="${plan.resultId > 0 && plan.isDone != 'Y'}">
                <li class="paginate_button bold" tabindex="0"><a href="#" onclick="conf(); return false;"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
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
    <%-- печатный вид листа (kp-*): шапка, пациент, название, таблица результатов, подпись; размер шрифта — от выбранного --%>
    <style>
      :root { --fs:${sessionScope.fontSize}px; }
      body { margin:0; padding:16px 0 24px; background:#fff !important; color:#111827; font-family:'Inter', 'Segoe UI', Arial, sans-serif; }
      #obs { width:100% !important; max-width:840px; }
      #obs > tbody > tr > td { border:0 !important; padding:0 !important; }
      #obs td.kp-shapka { padding:0 0 10px !important; border-bottom:2px solid #111827 !important; font-weight:400 !important; }
      #obs td.kp-shapka div { font-size:calc(var(--fs) * .78) !important; line-height:1.4; color:#374151; }
      #obs td.kp-shapka div:first-of-type { font-weight:700; color:#111827; }
      #obs td.kp-pat { padding:8px 0 !important; border-bottom:1px solid #E5E7EB !important; }
      #obs td.kp-pat table { width:100%; }
      #obs td.kp-pat td { padding:3px 6px !important; border:0 !important; }
      #obs td.kp-pat b { color:#6B7280; font-weight:500; }
      #obs td.kp-title { position:relative; padding:14px 0 10px !important; text-align:center; }
      #obs td.kp-title b { font-size:calc(var(--fs) * 1.2) !important; font-weight:700; letter-spacing:.2px; }
      #obs td.kp-title .kp-date { position:static !important; display:block; margin-top:3px; font-size:calc(var(--fs) * .8) !important; font-weight:500 !important; color:#6B7280; }
      #obs td.kp-res > table { margin-top:0 !important; }
      #obs td.kp-res > table td { border:0 !important; border-bottom:1px solid #E5E7EB !important; padding:5px 8px !important; background:none !important; color:#111827; }
      #obs td.kp-res > table tr.kp-th td { background:#F3F4F6 !important; color:#374151 !important; font-weight:700; border-top:1px solid #9CA3AF !important;
        border-bottom:1px solid #9CA3AF !important; font-size:calc(var(--fs) * .8) !important; text-transform:uppercase; letter-spacing:.3px; }
      #obs td.kp-res td.kp-v { font-weight:700; }
      #obs td.kp-res td.kp-out { color:#B91C1C !important; }
      #obs td.kp-res td.kp-doc { border-bottom:0 !important; padding:28px 8px 0 !important; font-weight:400 !important; }
      .kp-sign { display:flex; align-items:flex-end; gap:12px; }
      .kp-sign .ln { flex:1; max-width:220px; border-bottom:1px solid #111827; height:1px; }
      @media print { body { padding:0; } @page { margin:12mm 12mm; } }
    </style>
  </c:if>
  <table id="obs" style="border-spacing: 0;border-collapse: collapse; <c:if test="${print}">width:${plan.kdo.cssWidth}px;</c:if><c:if test="${!print}">width:96%;</c:if> margin:auto">
    <c:if test="${form.shapka && !print && idx == ''}">
      <tr>
        <td align=center class="kp-shapka" style="padding:10px; border:1px solid #ababab;font-weight:bold">
          ${idx}
          <div style="float:left;text-align:left;">${form.shapka_left}</div>
          <div style="float:right;text-align:right;">${form.shapka_right}</div>
        </td>
      </tr>
    </c:if>
    <c:if test="${idx == 0 || idx == ''}">
      <tr>
        <td class="kp-pat" style="border:1px solid #ababab">${patInfo}</td>
      </tr>
    </c:if>
    <tr>
      <td align=center class="kp-title" style="padding:10px; border:1px solid #ababab;position: relative">
        <b>${plan.kdo.name}</b>
        <div class="kp-date" style="position: absolute; right:10px; font-size: 12px !important; font-weight: bold">Дата: <fmt:formatDate pattern="dd.MM.yyyy" value="${plan.resDate}"/></div>
      </td>
    </tr>
    <tr>
      <td class="kp-res" style="">
</c:if>
        <table width="100%" style="margin-top:-2px; border-spacing: 0;border-collapse: collapse; font-size: 12px;">
