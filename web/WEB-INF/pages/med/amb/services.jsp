<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<style>
  .blink_me {
    animation: blinker 1s linear infinite;
  }

  @keyframes blinker {
    50% {
      opacity: 0;
    }
  }
</style>
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
            <tr><td align="center" width="20">&nbsp;</td><td align="center"><b>Наименование</b></td><td align="center"><b>Стоимость</b></td></tr>
            <c:forEach items="${g.services}" var="k">
              <tr>
                <td align="center">
                  <input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids">
                </td>
                <td>
                  <label for="kdo${k.id}">
                    ${k.name}
                    <c:if test="${k.saleProc > 0}">
                      <span style="font-weight:bold; color:red" class="blink_me">(Акция! Скидка:${k.saleProc}%)</span>
                    </c:if>
                  </label>
                </td>
                <td class="text-right wpx-100">
                  <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${k.price}"/>
                </td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </c:forEach>
    </div>
  </div>
</f:form>
