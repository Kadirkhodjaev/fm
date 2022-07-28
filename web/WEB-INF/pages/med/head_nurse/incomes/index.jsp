<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading" style="padding:0 20px;">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Приход</td>
        <td style="width:140px;padding:5px">
          <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
        </td>
        <td style="width:10px;vertical-align: middle">
          -
        </td>
        <td style="width:140px;padding:5px">
          <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
        </td>
        <td style="vertical-align: middle">
          <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
        </td>
        <td style="width:250px">
          <select class="form-control" required id="dr" onchange="setCashStat()">
            <option <c:if test="${filter_direction == '0'}">selected</c:if> value="0">Все</option>
            <c:forEach items="${directions}" var="cc">
              <option <c:if test="${filter_direction == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
            </c:forEach>
          </select>
        </td>
        <td align="right" style="vertical-align: middle;width:100px">
          <button  class="btn btn-sm btn-success" onclick="setPage('/head_nurse/incomes/save.s?id=0')" style="float:right;"><i class="fa fa-plus"></i> Добавить</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>№</th>
          <th>#</th>
          <th>Получатель</th>
          <th>Документ</th>
          <th>Кол-во</th>
          <th>Сумма</th>
          <th>Создания</th>
          <th>Отправка</th>
          <th>Подтверждения</th>
          <th>Распаковка</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj">
          <tr ondblclick="setPage('/head_nurse/incomes/save.s?id=${obj.ib}')">
            <td align="center" style="width:80px">${obj.ib}</td>
            <td align="center" style="width:30px">
              <c:if test="${obj.c5 == 'ENT'}">
                <img src="/res/imgs/red.gif">
              </c:if>
              <c:if test="${obj.c5 == 'CON' || obj.c5 == null}">
                <img src="/res/imgs/green.gif">
              </c:if>
              <c:if test="${obj.c5 == 'SND'}">
                <img src="/res/imgs/yellow.gif">
              </c:if>
            </td>
            <td align="center">${obj.c6}</td>
            <td align="center">${obj.c1}</td>
            <td align="center">${obj.c2}</td>
            <td align="right"><fmt:formatNumber value="${obj.c3}" type = "number"/></td>
            <td align="center" style="width:150px">${obj.c7}</td>
            <td align="center" style="width:150px">${obj.c8}</td>
            <td align="center" style="width:150px">${obj.c9}</td>
            <td align="center" style="width:80px">
              <c:if test="${obj.c10 == 'N'}">
                <img src="/res/imgs/red.gif">
              </c:if>
              <c:if test="${obj.c10 == 'Y'}">
                <img src="/res/imgs/green.gif">
              </c:if>
              <c:if test="${obj.c10 == 'D'}">
                <img src="/res/imgs/yellow.gif">
              </c:if>
            </td>
            <td class="center">
              <c:if test="${obj.c5 == 'ENT'}">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${obj.ib})"><i class="fa fa-minus"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<script>
  function addDrugDict(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function editDrugDict(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/drugs/dict/get.s',
      method: 'post',
      data: 'code=category&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=name]').val(res.name);
          $('*[name=state]').prop('checked', res.state == 'A');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#category-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/drugs/dict/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/drugs/dicts.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function delDrugRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/incomes/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            setPage('/head_nurse/incomes.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    var direction = document.getElementById("dr");
    setPage('/head_nurse/incomes.s?period_start=' + start.value + '&period_end=' + end.value + '&dr=' + direction.value);
  }
</script>