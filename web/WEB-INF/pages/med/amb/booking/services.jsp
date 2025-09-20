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
      url: '/amb/booking/services.s',
      method: 'post',
      data: $('#services').serialize(),
      dataType: 'json',
      success:function (res) {
        setPage('/amb/booking.s?id=${id}');
      }
    });
  }
</script>
<f:form method="post" id="services">
  <input type="hidden" name="id" value="${id}">
  <div class="panel panel-info">
    <div class="panel-heading">
      Список обследования
      <div style="float:right">
        <button class="btn btn-icon btn-success" onclick="saveServices()" type="button" title="Сохранить"><i class="fa fa-check"></i> Сохранить</button>
        <button class="btn btn-icon" type="button" onclick="setPage('/amb/booking.s?id=${id}')"><i class="fa fa-reply"></i> Назад</button>
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
