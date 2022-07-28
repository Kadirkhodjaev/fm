<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<div>
  <div class="row" style="margin:20px 0 0 0;">
    <div class="col-md-12">
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-4">
              <i class="fa fa-twitter fa-fw"></i>
              Физиотерапия - ПОСТ
            </div>
            <div class="col-md-8">
              <table style="float: right">
                <tr>
                  <td style="padding: 0 5px; width:70px">
                    <select class="form-control chzn-select" title="Комната" onchange="setKdoRoom(this.value)">
                      <option value="0">Все</option>
                      <c:forEach items="${rooms}" var="rm">
                        <option <c:if test="${room == rm.name}">selected</c:if> value="${rm.name}">${rm.name}</option>
                      </c:forEach>
                    </select>
                  </td>
                  <td style="padding: 0 5px; width:250px">
                    <select class="form-control chzn-select" title="Услуги" onchange="setPostKdo(this.value)">
                      <option <c:if test="${kdoId == '0'}">selected</c:if> value="0">Все</option>
                      <c:forEach items="${kdos}" var="kdo">
                        <option <c:if test="${kdoId == kdo.value.id}">selected</c:if> value="${kdo.value.id}">${kdo.value.name}</option>
                      </c:forEach>
                    </select>
                  </td>
                  <td style="padding: 0 5px">
                    <input name="dated" id="dated" type="text" onchange="setPostDate(this.value)" class="form-control datepicker" value="${dated}"/>
                  </td>
                  <td style="padding: 0 5px; width:350px">
                    <select class="form-control chzn-select" title="Пациенты" onchange="setPostSearch(this.value)">
                      <option <c:if test="${patId == '0'}">selected</c:if> value="0">Все</option>
                      <c:forEach items="${rows}" var="pat">
                        <option <c:if test="${patId == pat.id}">selected</c:if> value="${pat.id}">${pat.fio}</option>
                      </c:forEach>
                    </select>
                  </td>
                  <td style="padding: 0 5px">
                    <select id="patient_status" title="Статус" class="form-control" onchange="setPostFilter()">
                      <option <c:if test="${status == '0'}">selected</c:if> value="0">Все</option>
                      <option <c:if test="${status == 'Y'}">selected</c:if> value="Y">Пришел</option>
                      <option <c:if test="${status == 'N'}">selected</c:if> value="N">Не пришел</option>
                      <option <c:if test="${status == 'V'}">selected</c:if> value="V">Отмен врача</option>
                      <option <c:if test="${status == 'P'}">selected</c:if> value="P">Отказ</option>
                    </select>
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <div class="panel-body" id="panel_body" style="position:relative; overflow: auto; height:400px">
          <div class="list-group">
            <table class="table table-bordered">
              <tr>
                <td class="center bold">№</td>
                <td class="center bold">Пациент</td>
                <td class="center bold">Палата</td>
                <td class="center bold">Комната</td>
                <td class="center bold">Процедура</td>
                <td class="center bold">Коммент врача</td>
                <td class="center bold">Статус</td>
                <td class="center bold">Дата и время</td>
              </tr>
              <c:set var="oper" value="${0}" />
              <c:forEach items="${rows}" var="rw" varStatus="loop">
                <c:if test="${fn:length(rw.list) > 0}">
                  <c:set var="oper" value="${oper + 1}" />
                  <tr class="hover">
                    <td style="vertical-align:middle" rowspan="${fn:length(rw.list) + 1}" class="center">${oper}</td>
                    <td style="vertical-align:middle" rowspan="${fn:length(rw.list) + 1}">${rw.fio}</td>
                    <td style="text-align:center; vertical-align:middle" rowspan="${fn:length(rw.list) + 1}">${rw.name}</td>
                  </tr>
                  <c:forEach items="${rw.list}" var="rs">
                    <tr class="hover">
                      <td class="center">${rs.c7}</td>
                      <td>${rs.c1}</td>
                      <td>${rs.c2}</td>
                      <td class="center">
                        <select class="form-control" onchange="setPostStatus(${rs.id}, this.value)">
                          <option <c:if test="${rs.c3 == 'N'}">selected</c:if> value="N">Не пришел</option>
                          <option <c:if test="${rs.c3 == 'Y'}">selected</c:if> value="Y">Пришел</option>
                          <option <c:if test="${rs.c3 == 'P'}">selected</c:if> value="P">Отказ пациента</option>
                          <option <c:if test="${rs.c3 == 'V'}">selected</c:if> value="V">Отмен врача</option>
                        </select>
                      </td>
                      <td class="center">${rs.c4}</td>
                    </tr>
                  </c:forEach>
                  <tr>
                    <td colspan="6"></td>
                  </tr>
                </c:if>
              </c:forEach>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  $(function(){
    $('#panel_body').width($(window).width() - 250).height($(window).height() - 190);
    $(".chzn-select").chosen();
  });
  function setPostFilter() {
    setPage('/nurses/fizio.s?dated=' + $('#dated').val() + '&status=' + $('#patient_status').val());
  }
  function setPostStatus(id, tp) {
    $.ajax({
      url: '/nurses/fizio.s',
      method: 'post',
      data: 'id=' + id + '&type=' + tp,
      dataType: 'json',
      success: function (res) {
        if(!res.success) alert(res.msg);
      }
    });
  }
  function setPostDate(val) {
    setPage('/nurses/fizio.s?dated=' + val);
  }
  function setPostSearch(val) {
    setPage('/nurses/fizio.s?dated=' + $('#dated').val() + '&patient=' + val + "&status=0");
  }
  function setPostKdo(id) {
    setPage('/nurses/fizio.s?dated=' + $('#dated').val() + '&kdo=' + id + "&status=0");
  }
  function setKdoRoom(id) {
    setPage('/nurses/fizio.s?dated=' + $('#dated').val() + '&room=' + id + "&status=0");
  }
</script>
