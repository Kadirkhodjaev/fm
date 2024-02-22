<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/suneditor/suneditor.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/jquery.mask.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/suneditor/suneditor.min.js"></script>
<div class="w-100 text-center border-bottom-1">
  <table class="w-100">
    <tr>
      <td style="width:30px" class="p-3 text-center">
        <c:if test="${!service.closed}">
          <c:if test="${!(service.result > 0)}">
            <img src="/res/imgs/red.gif" alt="">
          </c:if>
          <c:if test="${service.result > 0}">
            <img src="/res/imgs/yellow.gif" alt="">
          </c:if>
        </c:if>
        <c:if test="${service.closed}">
          <img src="/res/imgs/green.gif" alt="">
        </c:if>
      </td>
      <td class="text-left p-3" style="vertical-align:bottom">
        <h4 class="bold" style="margin-top:15px">
          ${service.service.name}
        </h4>
      </td>
      <td class="text-right p-3" style="width:250px; padding-right:10px">
        <button class="btn btn-info btn-icon" type="button" onclick="printForm()">
          <i class="fa fa-print"></i> Печать
        </button>
      </td>
    </tr>
  </table>
</div>
<table class="w-100 light-table">
  <c:if test="${!text_exist}">
    <thead>
    <tr>
      <c:if test="${code_exist}">
        <td class="wpx-100">Код</td>
      </c:if>
      <td>Наименование</td>
      <c:forEach items="${cols}" var="f" varStatus="loop">
        <td>${f.name}</td>
      </c:forEach>
      <c:if test="${norma_exist}">
        <td>Норма</td>
      </c:if>
      <c:if test="${ei_exist}">
        <td>Ед.изм.</td>
      </c:if>
    </tr>
    </thead>
  </c:if>
  <tbody>
  <c:forEach items="${fields}" var="f" varStatus="loop">
    <c:if test="${f.typeCode != 'title' && !text_exist}">
      <tr>
        <c:if test="${code_exist}">
          <td class="pb-2 text-center">${f.code}</td>
        </c:if>
        <td class="pb-2">${f.name}</td>
        <c:forEach items="${f.fields}" var="a" varStatus="lp">
          <td class="pb-2 text-center">${res[a.fieldName]}</td>
        </c:forEach>
        <c:if test="${norma_exist}">
          <td class="text-center">${f.norma}</td>
        </c:if>
        <c:if test="${ei_exist}">
          <td class="text-center wpx-100">${f.ei}</td>
        </c:if>
      </tr>
    </c:if>
    <c:if test="${f.typeCode == 'title'}">
      <tr>
        <td class="text-center bold pb-2" colspan="${fn:length(cols) + 1}">${f.name}</td>
      </tr>
    </c:if>
    <c:if test="${f.typeCode != 'title' && text_exist}">
      <tr>
        <td class="bold">${f.name}:</td>
      </tr>
      <tr>
        <td>${res[f.fieldName]}</td>
      </tr>
    </c:if>
  </c:forEach>
  </tbody>
</table>
<script>
  function printForm() {

  }
</script>
