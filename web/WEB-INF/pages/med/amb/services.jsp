<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
  function saveServices() {
    $.ajax({
      url: '/amb/services.s',
      method: 'post',
      data: $('#services').serialize(),
      dataType: 'json',
      success:function (res) {
        openMainPage('/amb/reg.s?id=${id}');
      }
    });
  }
</script>
<f:form method="post" id="services">
  <div class="panel panel-info" style="width: 100% !important; margin: auto">
    <div class="panel-heading">
      Список обследования
      <div style="float:right">
        <button class="btn btn-sm btn-success" onclick="saveServices()" type="button" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
        <button class="btn btn-sm" type="button" onclick="openMainPage('/amb/reg.s?id=${id}')" style="margin-top: -5px"><i class="fa fa-reply"></i> Назад</button>
      </div>
    </div>
    <ul class="nav nav-tabs">
      <c:forEach items="${groups}" var="g" varStatus="loop">
        <li <c:if test="${loop.index == 0}">class="active"</c:if> ><a href="#page${g.group.id}" data-toggle="tab" aria-expanded="true">${g.group.name}</a></li>
      </c:forEach>
    </ul>
    <div class="tab-content">
      <c:forEach items="${groups}" var="g" varStatus="loop">
        <div class="tab-pane <c:if test="${loop.index == 0}">active</c:if> fade in" id="page${g.group.id}">
          <table class="formTable" style="width:100%">
            <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
            <c:forEach items="${g.services}" var="k">
              <tr>
                <td align="center">
                  <input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids">
                </td>
                <td>
                  <label for="kdo${k.id}">${k.name} ${k.form_id}</label>
                </td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </c:forEach>
    </div>
  </div>
</f:form>
