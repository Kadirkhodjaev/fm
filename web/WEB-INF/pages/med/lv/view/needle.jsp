<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Карточка пациента (просмотр) → Иглотерапия: количество сеансов сохраняется сразу при изменении; у архивного пациента только просмотр --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<c:set var="ndArch" value="${pat.state == 'ARCH'}"/>
<div class="ld-sheet" style="max-width:960px">
  <div class="ld-title">
    <i class="fa fa-thumb-tack" style="color:#9AA1AC"></i> Иглотерапия
    <span class="sub">${pat.surname} ${pat.name} ${pat.middlename}<c:if test="${not empty pat.birthyear}"> · ${pat.birthyear} г.р.</c:if></span>
    <span class="sp"></span>
    <c:if test="${ndArch}"><span class="ld-tag" title="Пациент в архиве"><i class="fa fa-lock"></i>только просмотр</span></c:if>
  </div>
  <div class="ld-body">
    <c:if test="${empty plans}"><div class="ld-empty">Иглотерапия не назначена</div></c:if>
    <c:if test="${not empty plans}">
      <table class="fm-grid" style="margin-top:12px">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:120px">Дата</th>
          <th style="width:120px">Кол-во</th>
          <th>Примечание</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${plans}" var="p">
          <tr>
            <td><b>${p.kdo.name}</b></td>
            <td><fmt:formatDate pattern="dd.MM.yyyy" value="${p.actDate}"/></td>
            <td>
              <c:if test="${ndArch}">${p.counter == null ? 0 : p.counter}</c:if>
              <c:if test="${!ndArch}">
                <input type="number" min="0" class="fm-in" style="width:90px; text-align:center" value="${p.counter == null ? 0 : p.counter}" onchange="ndSet(${p.id}, this.value)">
              </c:if>
            </td>
            <td class="mut">${p.comment}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</div>
<script>
  function ndSet(p, v) {
    $.ajax({
      url: '/view/needle.s', method: 'post', data: 'p=' + p + '&v=' + v, dataType: 'json',
      success: function (res) { FmsToast.show(res.msg || (res.success ? 'Сохранено' : 'Не удалось сохранить'), res.success ? 'ok' : 'err'); },
      error: function () { FmsToast.show('Не удалось сохранить', 'err'); }
    });
  }
</script>
