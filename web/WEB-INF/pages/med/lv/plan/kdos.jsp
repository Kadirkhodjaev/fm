<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<f:form method="post">
  <div class="panel panel-info" style="width: 100% !important; margin: auto">
    <div class="panel-heading">
      Список обследования
      <div style="float:right">
        <button class="hidden" id="saveBtn" type="submit" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
        <button class="btn btn-sm" type="button" onclick="setLocation('/lv/plan/index.s')" style="margin-top: -5px"><i class="fa fa-reply"></i> Назад</button>
      </div>
    </div>
    <ul class="nav nav-tabs">
      <c:forEach items="${types}" var="ty" varStatus="loop">
        <li class="<c:if test="${loop.index == 0}">active</c:if>"><a href="#page${ty.id}" data-toggle="tab" aria-expanded="true">${ty.name}</a></li>
      </c:forEach>
    </ul>
    <div class="tab-content">
      <c:forEach items="${types}" var="ty" varStatus="loop">
        <div class="tab-pane <c:if test="${loop.index == 0}">active</c:if> fade in" id="page${ty.id}">
          <table class="formTable" style="width:100%">
            <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
            <c:forEach items="${ty.list}" var="k">
              <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.c1}</label></td></tr>
            </c:forEach>
          </table>
        </div>
      </c:forEach>
    </div>
  </div>
  </f:form>
