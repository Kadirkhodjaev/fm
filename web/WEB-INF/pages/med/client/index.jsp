<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
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
    var fieldId = '${newFieldId}';
    if(fieldId != '') {
      $('.grid thead th').has("id").attr("class", "sorting");
      $('.grid thead th[id=${newFieldId}]').attr("class", "${htmlClass}");
    }
    $('.panel-body').height($(window).height() - 95);
    var selectedClientRow = getCookie("selectedClientRow");
    if(selectedClientRow){
      setRow(selectedClientRow);
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
      setCookie("selectedClientRow", elem.attr("q"));
    } else {
      // Удаляем кукий выбранной строки
      deleteCookie("selectedClientRow");
    }
  }

  function addEditPatient(id) {
    setPage('/client/edit.s?id=' + id);
  }

  function setSort(column, id){
    setPage('/client/list.s?action=sort&column=' + column + (id != null ? "&colId=" + id : ""));
  }

  function setPageNum(page){
    setPage('/client/list.s?action=page&page=' + page);
  }

  function setNav(page){
    if(page == 'prev'){
      <c:if test="${sessionScope.clientGrid.page > 1}">
      setPage('/client/list.s?action=' + page);
      </c:if>
    }
    if(page == 'begin'){
      <c:if test="${sessionScope.clientGrid.page > 1}">
      setPage('/client/list.s?action=' + page);
      </c:if>
    }
    if(page == 'next'){
      <c:if test="${sessionScope.clientGrid.page != sessionScope.clientGrid.maxPage}">
      setPage('/client/list.s?action=' + page);
      </c:if>
    }
    if(page == 'end'){
      <c:if test="${sessionScope.clientGrid.page != sessionScope.clientGrid.maxPage}">
      setPage('/client/list.s?action=' + page);
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
</script>
<div class="panel-body" style="border:1px solid #ababab; border-radius: 4px">
  <div class="paginationBlock">
    <ul class="pagination">
      <li class="paginate_button disabled" tabindex="0"><a href="#">${sessionScope.clientGrid.startPos}..${sessionScope.clientGrid.endPos} из ${sessionScope.clientGrid.rowCount}</a></li>
      <c:if test="${sessionScope.clientGrid.maxPage > 1}">
        <li class="paginate_button previous <c:if test="${sessionScope.clientGrid.page == 1}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_previous"><a onclick="setNav('begin')" href="#"><i class="fa fa-fast-backward"></i>&nbsp;</a></li>
        <li class="paginate_button previous <c:if test="${sessionScope.clientGrid.page == 1}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_previous"><a onclick="setNav('prev')" href="#"><i class="fa fa-backward"></i>&nbsp;</a></li>
        <li class="paginate_button" aria-controls="dataTables-example" tabindex="0">
          <select class="pageNum" style='float:left' onchange="setPageNum(this.value)">
            <c:forEach begin="1" end="${sessionScope.clientGrid.maxPage}" var="elem">
              <option <c:if test="${sessionScope.clientGrid.page == elem}">selected</c:if> value="${elem}">${elem}</option>
            </c:forEach>
          </select>
        </li>
        <li class="paginate_button next <c:if test="${sessionScope.clientGrid.page == sessionScope.clientGrid.maxPage}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_next"><a onclick="setNav('next')" href="#"><i class="fa fa-forward"></i>&nbsp;</a></li>
        <li class="paginate_button next <c:if test="${sessionScope.clientGrid.page == sessionScope.clientGrid.maxPage}">disabled</c:if>" aria-controls="dataTables-example" tabindex="0" id="dataTables-example_next"><a onclick="setNav('end')" href="#"><i class="fa fa-fast-forward"></i>&nbsp;</a></li>
      </c:if>
    </ul>
  </div>
  <div class="table-responsive" style="overflow-y: auto; height: 95%">
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <thead>
      <tr>
        <th style="width:50px">#</th>
        <th class="sorting" id="thsurname" onclick="setSort('surname', null)">ФИО</th>
        <th class="sorting" id="thbirthyear" style="width:130px" onclick="setSort('birthyear', null)">Дата рождения</th>
        <th class="sorting" id="thDate_Begin" style="width:130px" onclick="setSort('address', null)">Адрес</th>
        <th class="sorting" id="thState" style="width:130px" onclick="setSort('tel', null)">Телефон</th>
        <th class="sorting" id="thcrOn" style="width:130px" onclick="setSort('crOn', null)">Дата и время рег</th>
      </tr>
      </thead>
      <tbody style="overflow: scroll">
      <c:forEach items="${list}" var="p" varStatus="loop">
        <tr onclick="setRow(${loop.index})" ondblclick="addEditPatient(${p.id})" id="${p.id}" q='${loop.index}'>
          <td class="center">${loop.index + 1}</td>
          <td>${p.surname} ${p.name} ${p.middlename}</td>
          <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${p.birthdate}" /></td>
          <td class="center">${p.country.name} ${p.region.name} ${p.address}</td>
          <td class="center">${p.tel}</td>
          <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy hh:MM" value = "${p.crOn}" /></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.table-responsive -->
</div>
