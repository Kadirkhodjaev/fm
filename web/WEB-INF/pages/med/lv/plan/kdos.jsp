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
  <div class="panel panel-info" style="width: 1100px !important; margin: auto">
    <div class="panel-heading">
      Список обследования
      <div style="float:right">
        <button class="hidden" id="saveBtn" type="submit" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
        <button class="btn btn-sm" type="button" onclick="setLocation('/lv/plan/index.s')" style="margin-top: -5px"><i class="fa fa-reply"></i> Назад</button>
      </div>
    </div>
    <ul class="nav nav-tabs">
      <li class="active"><a href="#page1" data-toggle="tab" aria-expanded="true">Лаборатория</a></li>
      <c:if test="${fn:length(uzis) > 0}">
        <li class=""><a href="#page2" data-toggle="tab" aria-expanded="false">УЗИ</a></li>
      </c:if>
      <c:if test="${fn:length(rens) > 0}">
        <li class=""><a href="#page3" data-toggle="tab" aria-expanded="false">Рентген</a></li>
      </c:if>
      <c:if test="${fn:length(vems) > 0}">
        <li class=""><a href="#page4" data-toggle="tab" aria-expanded="false">ВЭМ</a></li>
      </c:if>
      <c:if test="${fn:length(endos) > 0}">
        <li class=""><a href="#page9" data-toggle="tab" aria-expanded="false">Эндоскопия</a></li>
      </c:if>
      <c:if test="${fn:length(sms) > 0}">
        <li class=""><a href="#page5" data-toggle="tab" aria-expanded="false">ЭКГ</a></li>
      </c:if>
      <c:if test="${fn:length(mskt) > 0}">
        <li class=""><a href="#page6" data-toggle="tab" aria-expanded="false">МСКТ</a></li>
      </c:if>
      <c:if test="${fn:length(neyros) > 0}">
        <li class=""><a href="#page10" data-toggle="tab" aria-expanded="false">Нейрофизиология</a></li>
      </c:if>
      <c:if test="${fn:length(xolters) > 0}">
        <li class=""><a href="#page11" data-toggle="tab" aria-expanded="false">Холтер</a></li>
      </c:if>
      <c:if test="${fn:length(gineks) > 0}">
        <li class=""><a href="#page12" data-toggle="tab" aria-expanded="false">Гинекология</a></li>
      </c:if>
      <c:if test="${fn:length(lors) > 0}">
        <li class=""><a href="#page13" data-toggle="tab" aria-expanded="false">ЛОР</a></li>
      </c:if>
      <c:if test="${fn:length(okulists) > 0}">
        <li class=""><a href="#page14" data-toggle="tab" aria-expanded="false">Окулист</a></li>
      </c:if>
      <%--<c:if test="${fn:length(fizio) > 0}">
        <li class=""><a href="#page7" data-toggle="tab" aria-expanded="false">Физиотерапия</a></li>
      </c:if>--%>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="page1">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${labs}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page2">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${uzis}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page3">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${rens}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page4">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${vems}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page5">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${sms}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page6">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${mskt}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page7">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${fizio}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page9">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${endos}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page10">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${neyros}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page11">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${xolters}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page12">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${gineks}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page13">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${lors}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
      <div class="tab-pane fade" id="page14">
        <table class="formTable" style="width:100%">
          <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
          <c:forEach items="${okulists}" var="k">
            <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
          </c:forEach>
        </table>
      </div>
    </div>
  </div>
  </f:form>
