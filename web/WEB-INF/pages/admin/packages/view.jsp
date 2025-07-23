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
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading bold">
    Реквизиты документа
    <button  class="btn btn-sm btn-default" onclick="setPage('/admin/pack/index.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <button  class="btn btn-sm btn-success" onclick="savePackage()" style="float:right;margin-top:-5px"><i class="fa fa-save"></i> Сохранить</button>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <form id="addEditForm">
        <input type="hidden" name="id" value="${obj.id}"/>
        <table class="table table-bordered">
          <tr>
            <td class="bold center">Наименование: </td>
            <td colspan="9">
              <input class="form-control" type="text" maxlength="512" value="${obj.name}" name="name"/>
            </td>
          </tr>
          <tr>
            <td class="bold center">Описание: </td>
            <td colspan="9">
              <textarea class="form-control" maxlength="2000" name="text">${obj.text}</textarea>
            </td>
          </tr>
          <tr>
            <td class="bold center">Стоимость:</td>
            <td>
              <input class="form-control right" type="number" name="price" maxlength="16" value="${obj.price}"/>
            </td>
            <td class="bold center">Стоимость с НДС:</td>
            <td>
              <input class="form-control right" type="number" name="price" maxlength="16" value="${obj.price * (100 + ndsProc) / 100}"/>
            </td>
            <td class="bold center">Дата начала:</td>
            <td>
              <input name="start" id="date_start" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.start}" />"/>
            </td>
            <td class="bold center">Дата окончания:</td>
            <td>
              <input name="end" id="date_end" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.end}" />"/>
            </td>
            <td class="bold center">Активный?</td>
            <td style="text-align: center; vertical-align: middle">
              <input name="state" tabindex="-1" type="checkbox" value="A" <c:if test="${obj.id == null || obj.state == 'A'}">checked</c:if>/>
            </td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>
<c:if test="${obj.id > 0}">
  <div class="panel panel-info" style="width: 100%; margin: auto">
    <div class="panel-heading bold">
      Добавить услугу
    </div>
    <div class="panel-body">
      <table class="table table-bordered">
        <tr>
          <td>
            <c:if test="${obj.ambStat == 'STAT'}">
              <select class="form-control chzn-select" name="kdo" id="kdo_id">
                <option value=""></option>
                <c:forEach items="${kdos}" var="cc">
                  <option value="${cc.id}">${cc.name} (Группа: ${cc.kdoType.name}, Стоимость:${cc.price})</option>
                </c:forEach>
              </select>
            </c:if>
            <c:if test="${obj.ambStat == 'AMB'}">
              <select class="form-control chzn-select" name="kdo" id="kdo_id">
                <option value=""></option>
                <c:forEach items="${services}" var="cc">
                  <option value="${cc.id}">${cc.name} (Группа: ${cc.group.name}, Стоимость:${cc.price})</option>
                </c:forEach>
              </select>
            </c:if>
          </td>
          <td>
            <button class="btn btn-success btn-sm" style="height:25px;padding:2px 10px" type="button" onclick="addKdo()">
              <b class="fa fa-plus"></b>
            </button>
          </td>
        </tr>
      </table>
    </div>
  </div>
  <div class="panel panel-info" style="width: 100%; margin: auto">
    <div class="panel-heading bold">
      Добавленные услуги: Сумма со скидкой - <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></span> Сумма без скидки - <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${real_summ}"/></span>
    </div>
    <div class="panel-body">
      <table class="table table-bordered miniGrid">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Реальная стоимость</th>
          <th>Реальная стоимость с НДС</th>
          <th>% скидки</th>
          <th>Стоимость</th>
          <th>Стоимость с НДС</th>
          <th style="width:150px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="rw" varStatus="loop">
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td>${rw.name}</td>
          <td class="text-right">
            <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${rw.claimCount}"/>
          </td>
          <td class="text-right">
            <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${rw.claimCount * (100 + ndsProc) / 100}"/>
          </td>
          <td style="width:250px">
            <input class="form-control right" type="number" value="${rw.drugCount}" onblur="setKdoPrice(${rw.id}, this)"/>
          </td>
          <td style="width:250px" class="text-right">
            <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${rw.price}"/>
          </td>
          <td style="width:250px" class="text-right">
            <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${rw.price * (100 + ndsProc) / 100}"/>
          </td>
          <td class="center">
            <button class="btn btn-danger btn-sm" onclick="delKdo(${rw.id})" style="height:20px;padding:1px 10px">
              <span class="fa fa-minus"></span>
            </button>
          </td>
        </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</c:if>
<script>
  function setKdoPrice(id, dom) {
    if(dom.value != '')
      $.ajax({
        url: '/admin/pack/price.s',
        method: 'post',
        data: 'id=' + id + '&proc=' + dom.value,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/admin/pack/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
  }
  function savePackage() {
    $.ajax({
      url: '/admin/pack/info.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/admin/pack/info.s?id=' + res.id);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function addKdo() {
    if($('#kdo_id').val() > 0) {
      $.ajax({
        url: '/admin/pack/add.s',
        method: 'post',
        data: 'id=${obj.id}&kdo=' + $('#kdo_id').val(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно сохранены");
            setPage('/admin/pack/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function delKdo(id) {
    if(confirm('Вы действительно хотите удалить услугу?')) {
      $.ajax({
        url: '/admin/pack/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно сохранены");
            setPage('/admin/pack/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  $(function(){
    $(".chzn-select").chosen();
  });
</script>
