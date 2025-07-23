<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  tr th {text-align: center; background: #e8e8e8}
</style>
<ul class="nav nav-tabs">
  <li onclick="setPageCode('amb')" class="<c:if test="${page == 'amb'}">active</c:if>"><a href="#profile" data-toggle="tab" aria-expanded="false">Амбулатория</a></li>
  <%--<li onclick="setPageCode('amb')" class="<c:if test="${page == 'amb'}">active</c:if>"><a href="#messages" data-toggle="tab" aria-expanded="false">Амбулатория</a></li>--%>
</ul>

<div class="tab-content">
  <%--<div class="tab-pane fade <c:if test="${page != 'amb'}">in active</c:if>" id="profile">
    <div class="panel-body">
      <table class="table table-bordered table-hover">
        <tr>
          <th>Категория</th>
          <th>Наименование</th>
          <th style="width:150px">Дата начала</th>
          <th style="width:150px">Дата окончания</th>
          <th style="width:150px">Процент акций</th>
          <th style="width:80px">Действия</th>
        </tr>
        <c:forEach items="${kdos}" var="kdo" varStatus="loop">
          <tr class="hand hover" style="<c:if test="${kdo.saleProc > 0}">color:red; font-weight: bold</c:if>">
            <td style="vertical-align: middle; padding-left:10px" nowrap>${kdo.kdoType.name}</td>
            <td style="vertical-align: middle; padding-left:10px">${kdo.name}</td>
            <td>
              <input name="saleStart" id="statStart${loop.index}" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${kdo.saleStart}" />"/>
            </td>
            <td class="center">
              <input name="saleEnd" id="statEnd${loop.index}" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${kdo.saleEnd}" />"/>
            </td>
            <td class="center">
              <input type="number" id="statProc${loop.index}" maxlength="3" class="form-control right" value="${kdo.saleProc}">
            </td>
            <td class="center">
              <button title="Сохранить" type="button" class="btn btn-success btn-sm" style="height:24px; padding:2px 10px" onclick="saveRow(${kdo.id}, ${loop.index}, 'stat')"><b class="fa fa-check"></b></button>
              <button title="Удалить акцию" type="button" class="btn btn-danger btn-sm" style="height:24px; padding:2px 10px" onclick="removeRow(${kdo.id}, 'stat')"><b class="fa fa-remove"></b></button>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>--%>
  <div class="tab-pane fade <c:if test="${page == 'amb'}">in active</c:if>" id="messages">
    <div class="panel-body">
      <table class="table table-bordered table-hover">
        <tr>
          <th>Категория</th>
          <th>Наименование</th>
          <th style="width:150px">Дата начала</th>
          <th style="width:150px">Дата окончания</th>
          <th style="width:150px">Процент акций</th>
          <th style="width:80px">Действия</th>
        </tr>
        <c:forEach items="${services}" var="kdo" varStatus="loop">
          <tr class="hand hover" style="<c:if test="${kdo.saleProc > 0}">color:red; font-weight: bold</c:if>">
            <td style="vertical-align: middle; padding-left:10px" nowrap>${kdo.group.name}</td>
            <td style="vertical-align: middle; padding-left:10px">${kdo.name}</td>
            <td>
              <input name="saleStart" id="ambStart${loop.index}" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${kdo.saleStart}" />"/>
            </td>
            <td class="center">
              <input name="saleEnd" id="ambEnd${loop.index}" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${kdo.saleEnd}" />"/>
            </td>
            <td class="center">
              <input type="number" id="ambProc${loop.index}" maxlength="3" class="form-control right" value="${kdo.saleProc}">
            </td>
            <td class="center">
              <button title="Сохранить" type="button" class="btn btn-success btn-sm" style="height:24px; padding:2px 10px" onclick="saveRow(${kdo.id}, ${loop.index}, 'amb')"><b class="fa fa-check"></b></button>
              <button title="Удалить акцию" type="button" class="btn btn-danger btn-sm" style="height:24px; padding:2px 10px" onclick="removeRow(${kdo.id}, 'amb')"><b class="fa fa-remove"></b></button>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</div>
<script>
  var page = '${page}';
  function setPageCode(code) {
    this.page = code;
  }
  function saveRow(id, idx, code) {
    let start = $('#' + code + 'Start' + idx).val();
    let end = $('#' + code + 'End' + idx).val();
    let proc = $('#' + code + 'Proc' + idx).val();

    if(start != '' && end != '' && proc != '') {
      $.ajax({
        url: '/cashbox/sale/row/save.s',
        method: 'post',
        data: 'id=' + id + '&start=' + start + '&end=' + end + '&proc=' + proc + '&code=' + code,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно сохранены");
            setPage('/cashbox/sales.s?page=' + page)
          } else {
            alert(res.msg);
          }
        }
      });
    } else {
      alert('Не все поля заполнены');
    }
  }
  function removeRow(id, code) {
    if(confirm('Вы действительно анулировать акцию?')) {
      $.ajax({
        url: '/cashbox/sale/row/remove.s',
        method: 'post',
        data: 'id=' + id + '&code=' + code,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно удалены");
            setPage('/cashbox/sales.s?page=' + page)
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>



