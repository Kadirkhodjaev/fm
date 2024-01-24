<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="panel panel-info w-100">
  <div class="panel-heading">
    <span class="fa fa-users"></span> Реестр клиентов
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
        <th style="width:50px">№</th>
        <th>ФИО</th>
        <th style="width: 150px">Пол</th>
        <th style="width: 150px">Дата рождения</th>
        <th style="width: 150px">Документ</th>
        <th style="width: 150px">Страна</th>
        <th style="width: 150px">Региод</th>
        <th style="width: 150px">Телефон.</th>
        <th style="width: 150px">Дата рег.</th>
      </tr>
      </thead>
      <tbody style="overflow: scroll">
      <c:forEach items="${rows}" var="p" varStatus="loop">
        <tr ondblclick="view(${p.id})">
          <td class="center">${loop.index + 1}</td>
          <td><a href="#" onclick="view(${p.id}); return false;">${p.fio}</a></td>
          <td class="center">${p.sex}</td>
          <td class="center">${p.birthdate}</td>
          <td class="center">${p.docSeria} ${p.docNum}</td>
          <td class="center">${p.country}</td>
          <td class="center">${p.region}</td>
          <td class="center">${p.tel}</td>
          <td class="center">${p.dateReg}</td>
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
    setPage('${sessionScope.ENV.curUrl}?action=page_size&page_size=' + val);
  }
  function setWord(val) {
    if(event.keyCode === 13)
      setPage('${sessionScope.ENV.curUrl}?action=search&word=' + encodeURIComponent(val));
  }
  function setPageNum(val) {
    setPage('${sessionScope.ENV.curUrl}?action=page_num&page_num=' + val)
  }
  function setNav(code) {
    setPage('${sessionScope.ENV.curUrl}?action=' + code);
  }
  function view(id) {
    setPage('/clients/view.s?id=' + id);
  }
</script>
