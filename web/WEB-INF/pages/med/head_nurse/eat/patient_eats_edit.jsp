<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Склады → Питание → пациент: стол на каждый приём пищи; выбранный стол переносится на следующие строки --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<style>
  #peRows td { vertical-align:middle; }
  #peRows tr.day td { border-top:2px solid #E6E8EC; }
  #peRows .fm-in { max-width:320px; }
  #peRows tr.ref td { background:#FFF7F7; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cutlery"></i></span>
        <div>
          <h2>${patient.surname} ${patient.name} ${patient.middlename}</h2>
          <span class="fm-count">ИБ №<b>${patient.yearNum}</b> · питание по дням</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <span class="fm-count" style="max-width:340px">Стол, выбранный в строке, переносится на все строки ниже</span>
      <button type="button" class="fm-btn primary" id="peSaveBtn" onclick="savePatientSave()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="setPage('/head_nurse/eat.s?id=${eat_id}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap">
      <form name="patient-eat" id="patient-eat" onsubmit="savePatientSave(); return false">
        <table class="fm-grid">
          <thead>
          <tr>
            <th style="width:130px">Дата</th>
            <th style="width:220px">Приём пищи</th>
            <th>Стол</th>
          </tr>
          </thead>
          <tbody id="peRows">
          <c:set var="prevDate" value=""/>
          <c:forEach items="${eats}" var="eat" varStatus="loop">
            <fmt:formatDate pattern="dd.MM.yyyy" value="${eat.actDate}" var="d"/>
            <tr id="patient-eat-row-${loop.index}" class="${d != prevDate && loop.index > 0 ? 'day' : ''}${eat.state == 'REF' ? ' ref' : ''}">
              <td class="nw"><c:if test="${d != prevDate}"><b>${d}</b></c:if></td>
              <td class="mut">${eat.menuType.name}</td>
              <td>
                <c:choose>
                  <c:when test="${eat.state == 'ENT' || eat.state == 'REF'}">
                    <%-- id отправляется только для редактируемых строк, в паре со своим столом --%>
                    <input type="hidden" name="id" value="${eat.id}">
                    <select class="fm-in" name="table" onchange="setPatientTable(this, ${loop.index})">
                      <option value="">Не выбран</option>
                      <option <c:if test="${eat.state == 'REF'}">selected</c:if> value="-1">Отказ</option>
                      <c:forEach items="${tables}" var="table">
                        <option <c:if test="${table.id == eat.table.id && eat.state != 'REF'}">selected</c:if> value="${table.id}">${table.name}</option>
                      </c:forEach>
                    </select>
                  </c:when>
                  <c:otherwise>
                    <span class="hn-st con">${empty eat.table.name ? 'подтверждено' : eat.table.name}</span>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
            <c:set var="prevDate" value="${d}"/>
          </c:forEach>
          </tbody>
        </table>
        <c:if test="${empty eats}"><div class="fm-empty" style="display:block"><i class="fa fa-cutlery"></i>Записей питания нет</div></c:if>
      </form>
    </div>
  </div>
</div>
<script>
  function savePatientSave() {
    $('#peSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/lv/eat.s', method: 'post', data: $('#patient-eat').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) openMsg(res);
        else FmsToast.show(res.msg, 'err');
      },
      complete: function () { $('#peSaveBtn').prop('disabled', false); }
    });
  }
  function setPatientTable(dom, idx) {
    $('#peRows tr').each(function () {
      var i = +this.id.replace('patient-eat-row-', '');
      if (i > idx) $(this).find('select[name=table]').val(dom.value);
      $(this).toggleClass('ref', $(this).find('select[name=table]').val() === '-1');
    });
  }
</script>
