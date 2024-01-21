<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="panel panel-info w-100">
  <div class="panel-heading">
    <span class="fa fa-users"></span> Список текущих пациентов
  </div>
  <div class="right pt-5">
    <ul class="pagination mb-0">
      <li class="paginate_button" tabindex="0">
        <input type="text" class="grid-search-field uppercase" id="amb-search-field" placeholder="Поиск" onkeydown="setWord(this.value)" value="${grid.word}"/>
      </li>
      <li class="paginate_button" tabindex="0">
        <select class="paginator-select" onchange="setPageSize(this.value)">
          <c:forEach items="${grid.pageSizes}" var="elem">
            <option <c:if test="${grid.pageSize == elem}">selected</c:if> value="${elem}">${elem}</option>
          </c:forEach>
        </select>
      </li>
      <li class="paginate_button" tabindex="0">
        <div class="float-left p-4">- ${grid.rowCount}</div>
      </li>
      <li class="paginate_button <c:if test="${grid.page == 1}">disabled</c:if>" tabindex="0"><a onclick="setNav('begin')" href="#"><i class="fa fa-fast-backward"></i>&nbsp;</a></li>
      <li class="paginate_button <c:if test="${grid.page == 1}">disabled</c:if>" tabindex="0"><a onclick="setNav('prev')" href="#"><i class="fa fa-backward"></i>&nbsp;</a></li>
      <li class="paginate_button" aria-controls="dataTables-example" tabindex="0">
        <select class="paginator-select" onchange="setPageNum(this.value)">
          <c:forEach begin="1" end="${grid.maxPage}" var="elem">
            <option <c:if test="${grid.page == elem}">selected</c:if> value="${elem}">${elem}</option>
          </c:forEach>
        </select>
      </li>
      <li class="paginate_button <c:if test="${grid.page == grid.maxPage}">disabled</c:if>" tabindex="0"><a onclick="setNav('next')" href="#"><i class="fa fa-forward"></i>&nbsp;</a></li>
      <li class="paginate_button <c:if test="${grid.page == grid.maxPage}">disabled</c:if>" tabindex="0"><a onclick="setNav('end')" href="#"><i class="fa fa-fast-forward"></i>&nbsp;</a></li>
    </ul>
  </div>
  <div class="table-responsive" style="overflow-y: auto; height: 95%">
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <thead>
      <tr>
        <th style="width:50px">#</th>
        <th style="width:50px">&nbsp;</th>
        <th class="sorting" id="thsurname" onclick="setSort('surname', null)">ФИО</th>
        <th class="sorting" id="thbirthyear" style="width:130px" onclick="setSort('birthyear', null)">Год рождения</th>
        <th class="sorting" id="thDate_Begin" style="width:130px" onclick="setSort('Reg_Date', null)">Дата рег.</th>
        <th class="sorting" id="thState" style="width:130px" onclick="setSort('state', null)">Состояние</th>
      </tr>
      </thead>
      <tbody style="overflow: scroll">
      <c:forEach items="${patients}" var="p" varStatus="loop">
        <tr onclick="setRow(${loop.index})" ondblclick="addEditPatient(${p.id})" id="${p.id}" q='${loop.index}'>
          <td class="center">${loop.index + 1}</td>
          <td class="center"><img src='/res/imgs/${p.icon}.gif'/></td>
          <td><a href="#" onclick="view(${p.id}); return false;">${p.fio}</a></td>
          <td class="center">${p.birthdate}</td>
          <td class="center">${p.dateReg}</td>
          <td class="center">${p.state}</td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<script>
  $(() => {
    <c:if test="${grid.word != ''}">
      $('#amb-search-field').focus()
    </c:if>
  })
  function setPageSize(val) {
    setPage('/ambs/patients.s?action=page_size&page_size=' + val);
  }
  function setWord(val) {
    if(event.keyCode === 13) {
      setPage('/ambs/patients.s?action=search&word=' + val)
    }
  }
  function setPageNum(val) {
    setPage('/ambs/patients.s?action=page_num&page_num=' + val)
  }
  function setNav(code) {
    setPage('/ambs/patients.s?action=' + code);
  }
  function view(id) {
    setPage('/ambs/reg.s?id=' + id);
  }
</script>
