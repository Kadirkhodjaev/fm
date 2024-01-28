<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="panel panel-info w-100" style="margin-bottom:0">
  <div class="panel-heading">
    <span class="fa fa-users"></span> Список пациентов
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
  <div class="grid-block shadow-block">
    <table class="w-100 table-bordered table-hover grid hand">
      <thead>
        <tr class="table-header-stikcy table-header">
          <th style="width:50px">#</th>
          <th style="width:50px">&nbsp;</th>
          <th>ФИО</th>
          <th style="width:130px">Год рождения</th>
          <th>Телефон</th>
          <th>Страна</th>
          <th>Регион</th>
          <th style="width:130px">Дата рег.</th>
          <th style="width:130px">Состояние</th>
        </tr>
      </thead>
      <tbody style="overflow: scroll">
      <c:forEach items="${patients}" var="p" varStatus="loop">
        <tr <c:if test="${is_fizio}">ondblclick="view(${p.id})"</c:if> onclick="setRow(${loop.index})" id="grid_row_${loop.index}" patient="${p.id}">
          <td class="center">${loop.index + 1}</td>
          <td class="center"><img src='/res/imgs/${p.icon}.gif'/></td>
          <td>
            <c:if test="${is_fizio}">
              <a href="#" onclick="view(${p.id}); return false;">${p.fio}</a>
            </c:if>
            <c:if test="${!is_fizio}">
              ${p.fio}
            </c:if>
          </td>
          <td class="center">${p.birthdate}</td>
          <td class="center">${p.tel}</td>
          <td class="center">${p.country}</td>
          <td class="center">${p.region}</td>
          <td class="center">${p.dateReg}</td>
          <td class="center">${p.state}</td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
  <div id="service_block" class="overflow-auto">
    sdasda
  </div>
</div>
<script>
  let lrw = localStorage.getItem('${sessionScope.ENV.curUrl}_row');
  let row = lrw == null ? '0' : lrw;
  $(() => {
    <c:if test="${grid.word != ''}">
      $('#amb-search-field').focus()
    </c:if>
    setRow(row);
    resizeIt();
  })
  $(window).resize(() => {
    resizeIt();
  })
  function resizeIt() {
    $('.grid-block').height($(document).height() / 2);
    $('#service_block').height($(document).height() - $('.grid-block').height() - 144);
  }
  function setRow(idx) {
    $('#grid_row_' + row).removeClass('selected');
    $('#service_block').html('').load('/ambs/patient/services.s?grid=1&id=' + $('#grid_row_' + idx).attr('patient'));
    row = idx;
    localStorage.setItem('${sessionScope.ENV.curUrl}_row', idx);
    $('#grid_row_' + idx).addClass('selected');
  }
  function setPageSize(val) {
    setPage('${sessionScope.ENV.curUrl}?action=page_size&page_size=' + val);
  }
  function setWord(val) {
    if(event.keyCode === 13) {
      setPage('${sessionScope.ENV.curUrl}?action=search&word=' + encodeURIComponent(val))
    }
  }
  function setPageNum(val) {
    setPage('${sessionScope.ENV.curUrl}?action=page_num&page_num=' + val)
  }
  function setNav(code) {
    setPage('${sessionScope.ENV.curUrl}?action=' + code);
  }
  function view(id) {
    setPage('${view_url}' + id);
  }
</script>
