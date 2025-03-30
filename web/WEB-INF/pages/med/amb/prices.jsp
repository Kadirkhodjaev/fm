<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/css/styles.css" rel="stylesheet" type="text/css">
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
<div class="panel panel-info" style="width: 100% !important; margin: auto">
  <div class="panel-heading">
    Список обследования
  </div>
  <ul class="nav nav-tabs">
    <c:forEach items="${groups}" var="g" varStatus="loop">
      <li <c:if test="${loop.index == 0}">class="active"</c:if> ><a href="#page${g.group.id}" data-toggle="tab" aria-expanded="true">${g.group.name}</a></li>
    </c:forEach>
  </ul>
  <div class="tab-content">
    <c:forEach items="${groups}" var="g" varStatus="loop">
      <div class="tab-pane <c:if test="${loop.index == 0}">active</c:if> fade in" id="page${g.group.id}">
        <table class="formTable w-100">
          <tr>
            <td class="text-center"><b>Наименование</b></td>
            <td class="text-center wpx-200"><b>Стоимость</b></td>
            <td class="text-center wpx-200"><b>Стоимость (Иностранцы)</b></td>
          </tr>
          <c:forEach items="${g.services}" var="k">
            <tr>
              <td>${k.name}</td>
              <td class="text-right">
                <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${k.price * 1.12}"/>
              </td>
              <td class="text-right">
                <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${k.for_price * 1.12}"/>
              </td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </c:forEach>
  </div>
</div>
