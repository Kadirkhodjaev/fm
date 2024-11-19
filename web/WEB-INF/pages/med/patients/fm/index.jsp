<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .pageNum {height: 28px;padding: 6px 4px;font-size: 12px;border: 1px solid #ccc;}
  .grid {font-size: 12px}
  .grid tr {cursor: hand}
  .grid thead {background:#d1d1d1}
  .grid thead tr th {text-align: center; border:1px solid #ddd !important;}
  .paginationBlock {text-align: right; height: 32px; margin-top: -10px}
  .grid tbody tr:hover {background: #f9f9f9}
  .grid tbody tr td, .grid thead tr th {padding: 4px !important;}
  .grid tbody tr.selected {background: #e8e8e8}
</style>
<script>
  $(document).ready(function(){
    <c:if test="${authErr}">
    alert('Время Вашей сессий истекло. Авторизуйтесь еще раз!');
    parent.location = 'login.s';
    </c:if>
    var fieldId = '${newFieldId}';
    if(fieldId != '') {
      $('.grid thead th').has("id").attr("class", "sorting");
      $('.grid thead th[id=${newFieldId}]').attr("class", "${htmlClass}");
    }
    <c:if test="${roleId != 7 || curUrl == '/patients/archive.s'}">
    $('.panel-body').height($(window).height() - 100);
    </c:if>
    <c:if test="${roleId == 7 && curUrl != '/patients/archive.s'}">
    $('.panel-body').css('height', '65%');
    </c:if>
    $(window).bind("resize", function() {
      <c:if test="${roleId != 7 || curUrl == '/patients/archive.s'}">
      $('.panel-body').height($(window).height() - 100);
      </c:if>
      <c:if test="${roleId == 7 && curUrl != '/patients/archive.s'}">
      $('.panel-body').css('height', '65%');
      </c:if>
    });
    var selectedRow = getCookie("selectedRow");
    if(selectedRow){
      setRow(selectedRow);
    } else
      setRow(0);
  });

  function setRow(idx){
    $('.grid tbody tr[class=selected]').attr("class", "");
    var elem = $('.grid tbody tr[q=' + idx + ']');
    elem = elem.attr("id") ? elem : $('.grid tbody tr[q="0"]');
    if(elem.attr("id")){
      // Задаем класс выбранному елементу
      elem.attr("class", "selected");
      // Утанавливаем кукий выбранной строки
      setCookie("selectedRow", elem.attr("q"));
      if(${roleId == 7}) {
        $('#kdoList').load('/kdo/index.s?id=' + elem.attr("id"));
      }
    } else {
      // Удаляем кукий выбранной строки
      deleteCookie("selectedRow");
    }
  }

  function addEditPatient(id) {
    if(${roleId != 5 && roleId != 9 && roleId != 8 && roleId != 6 && roleId != 16 && roleId != 7 && roleId != 11 && curUrl != '/patients/archive.s'})
      setPage('${addEditUrl}' + id);
    else {
      <c:if test="${sessionScope.ENV.roleId == 13}">
        setPage('${addEditUrl}' + id);
      </c:if>
      <c:if test="${sessionScope.ENV.roleId != 13}">
        openMainPage('${addEditUrl}' + id, false);
      </c:if>
    }
  }

  function checkAll(dom){
    var doms = document.getElementsByClassName("patientCheckbox");
    for(var i=0; i<doms.length; i++)
      doms[i].checked = dom.checked;
  }

  function setSort(column, id){
    setPage('/patients/index.s?action=sort&column=' + column + (id != null ? "&colId=" + id : ""));
  }

  function printPage(){
    alert('Print Page');
  }

  function setPageNum(page){
    setPage('/patients/index.s?action=page&page=' + page);
  }

  function setNav(page){
    if(page == 'prev'){
      <c:if test="${sessionScope.patientGrid.page > 1}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'begin'){
      <c:if test="${sessionScope.patientGrid.page > 1}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'next'){
      <c:if test="${sessionScope.patientGrid.page != sessionScope.patientGrid.maxPage}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'end'){
      <c:if test="${sessionScope.patientGrid.page != sessionScope.patientGrid.maxPage}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
  }

  function keyDown(e) {
    if(e.keyCode == 40 || e.keyCode == 38) {
      var idx = $('.grid tbody tr[class=selected]').attr('q');
      var elem = $('.grid tbody tr[q=' + (parseInt(idx) + 1 - (e.keyCode == 38 ? 2 : 0)) + ']');
      if(elem.attr("q")) {
        setRow(parseInt(idx) + 1 - (e.keyCode == 38 ? 2 : 0));
      }
    }
    if(e.keyCode == 33 || e.keyCode == 34) {
      setNav(e.keyCode == 33 ? 'prev' : 'next');
    }
    if(e.keyCode == 33 || e.keyCode == 34)
      setNav(e.keyCode == 33 ? 'prev' : 'next');
    if(e.keyCode == 35 || e.keyCode == 36)
      setNav(e.keyCode == 35 ? 'end' : 'begin');
    if(e.keyCode == 13) {
      if(document.activeElement.id == 'filterInput')
        return false;
      var id = $('.grid tbody tr[class=selected]').attr("id");
      addEditPatient(id);
    }
    if(e.keyCode == 32) {
      var pId = $('.grid tbody tr[class=selected]').attr("id");
      var doms = document.getElementsByClassName("patientCheckbox");
      for(var d=0;d<doms.length;d++) {
        if(doms[d].value == pId)
          doms[d].checked = !doms[d].checked;
      }
    }
  }

  function setConfirmPatient(){
    var vals = '';
    $('.patientCheckbox').each(function(){
      if($(this).is(":checked"))
        vals += 'id=' + $(this).val() + '&';
    });
    if(vals != '')
      setPage('/patients/confirm.s?' + vals);
  }
  function setPatientFlag(flag) {
    setPage('/patients/archive.s?flag=' + flag)
  }
</script>
<div class="panel-body" style="border:1px solid #ababab; border-radius: 4px">
  <c:if test="${((roleId == 3 || roleId == 4 || roleId == 5 || roleId == 6) && curUrl != '/patients/consul.s' && curUrl != '/patients/archive.s') || (roleId == 6 && curUrl == '/patients/archive.s')}">
    <button class="btn btn-success btn-sm" onclick="setConfirmPatient()" title="Подтвердить" style="float:left; margin-top: -12px;">Подтвердить</button>
  </c:if>
  <div class="paginationBlock">
    <c:if test="${curUrl == '/patients/archive.s'}">
      <select class="wpx-150 form-control" style="display: unset; position: relative; top:-20px" onchange="setPatientFlag(this.value)">
        <option value="0">Все</option>
        <option <c:if test="${flag == 'DONE'}">selected</c:if> value="DONE">С клиентом</option>
        <option <c:if test="${flag == 'UNDONE'}">selected</c:if> value="UNDONE">Без клиента</option>
      </select>
    </c:if>
    <ul class="pagination">
      <li class="paginate_button disabled" tabindex="0"><a href="#">${sessionScope.patientGrid.startPos}..${sessionScope.patientGrid.endPos} из ${sessionScope.patientGrid.rowCount}</a></li>
      <c:if test="${sessionScope.patientGrid.maxPage > 1}">
        <li class="paginate_button previous <c:if test="${sessionScope.patientGrid.page == 1}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_previous"><a onclick="setNav('begin')" href="#"><i class="fa fa-fast-backward"></i>&nbsp;</a></li>
        <li class="paginate_button previous <c:if test="${sessionScope.patientGrid.page == 1}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_previous"><a onclick="setNav('prev')" href="#"><i class="fa fa-backward"></i>&nbsp;</a></li>
        <li class="paginate_button" aria-controls="dataTables-example" tabindex="0">
          <select class="pageNum" style='float:left' onchange="setPageNum(this.value)">
            <c:forEach begin="1" end="${sessionScope.patientGrid.maxPage}" var="elem">
              <option <c:if test="${sessionScope.patientGrid.page == elem}">selected</c:if> value="${elem}">${elem}</option>
            </c:forEach>
          </select>
        </li>
        <li class="paginate_button next <c:if test="${sessionScope.patientGrid.page == sessionScope.patientGrid.maxPage}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_next"><a onclick="setNav('next')" href="#"><i class="fa fa-forward"></i>&nbsp;</a></li>
        <li class="paginate_button next <c:if test="${sessionScope.patientGrid.page == sessionScope.patientGrid.maxPage}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_next"><a onclick="setNav('end')" href="#"><i class="fa fa-fast-forward"></i>&nbsp;</a></li>
      </c:if>
    </ul>
  </div>
  <div class="table-responsive" style="overflow-y: auto; height: 95%">
    <%@include file="/incs/msgs/successError.jsp"%>
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <thead>
      <tr>
        <c:if test="${roleId != 7}">
          <th><input type="checkbox" onclick="checkAll(this)"/></th>
        </c:if>
        <th>#</th>
        <th>&nbsp;</th>
        <th>ФИО</th>
        <th nowrap>Год рождения</th>
        <th nowrap>Дата рег.</th>
        <th nowrap>Дата вып.</th>
        <th nowrap>Номер И/Б</th>
        <th nowrap>Отд./Пал.</th>
        <th nowrap>ФИО ЛВ</th>
      </tr>
      </thead>
      <tbody style="overflow: scroll">
      <c:forEach items="${list}" var="p" varStatus="loop">
        <tr onclick="setRow(${loop.index})" ondblclick="addEditPatient(${p.id})" id="${p.id}" q='${loop.index}'>
          <c:if test="${roleId != 7}">
            <td class="center"><c:if test="${p.showCheckbox}"><input type="checkbox" class="patientCheckbox" value="${p.id}"/></c:if></td>
          </c:if>
          <td class="center">${loop.index + 1}</td>
          <td class="center"><img src='/res/imgs/${p.iconUrl}.gif'/></td>
          <td><a href="#" onclick="addEditPatient(${p.id}); return false;">${p.fio}</a></td>
          <td class="center">${p.birthYear}</td>
          <td class="center">${p.dateBegin}</td>
          <td class="center">${p.dateEnd}</td>
          <td class="center">${p.ibNum}</td>
          <td class="center">${p.otdPal}</td>
          <td>${p.lv}</td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.table-responsive -->
</div>
<c:if test="${roleId == 7 && curUrl != '/patients/archive.s'}">
  <span id="formAction" class="hidden"></span>
  <div style="height:35%; border:1px solid #ababab; border-radius: 4px; overflow-x: auto" id="kdoList"></div>
</c:if>
