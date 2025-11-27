<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addStatService() {
    $('#addEditForm').find('*[name=group]').val('');
    $('#addEditForm').find('*[name=id]').val('');
    $('#addEditForm').find('*[name=name]').val('');
    $('#addEditForm').find('*[name=price]').val('0');
    $('#addEditForm').find('*[name=for_price]').val('0');
    $('#addEditForm').find('*[name=real_price]').val('0');
    $('#addEditForm').find('*[name=for_real_price]').val('0');
    $('#addEditForm').find('*[name=state]').attr('checked', true);
    $('#addEditForm').find('*[name=necKdo]').attr('checked', false);
    $('#uzi-free').hide();
    $('.form777').hide();
    $('#modal_window').click();
  }
  function setStatGroup(dom) {
    $('#uzi-free').toggle(dom.value == 4);
  }
  var button = getDOM('toExcel');
  button.addEventListener('click', function (e) {
    var table = document.querySelector('#excel_table');
    TableToExcel.convert(table);
  });
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>
          Список стационарных услуг
        </td>
        <td class="wpx-400">
          <select class="form-control" onchange="setPage('core/stat/services.s?group=' + this.value)" id="sel_kdo_group">
            <option value="0">Все</option>
            <c:forEach items="${groups}" var="g">
              <option <c:if test="${g.id == group}">selected</c:if> value="${g.id}">${g.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="wpx-150">
          <select class="form-control" onchange="setPage('core/stat/services.s?state=' + this.value)">
            <option <c:if test="${stateCode == '0'}">selected</c:if> value="0">Все</option>
            <option <c:if test="${stateCode == 'A'}">selected</c:if> value="A">Активный</option>
            <option <c:if test="${stateCode == 'P'}">selected</c:if> value="P">Пассивный</option>
          </select>
        </td>
        <td class="right wpx-200">
          <button class="btn btn-icon btn-success" type="button" onclick="addStatService()"><i class="fa fa-plus"></i> Добавить</button>
          <button class="btn btn-info btn-icon" id="toExcel">
            <span class="fa fa-file-excel-o"></span> Excel
          </button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered" id="excel_table" data-cols-width="10,20,40,20,20,20,20,20,20,20,20,20">
        <thead>
        <tr>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">ID</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Группировка</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Наименование</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (Иностранцы)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Стоимость (Иностранцы) (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Реальная стоимость</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Реальная стоимость (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Реальная стоимость (Иностранцы)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Реальная стоимость (Иностранцы) (С НДС)</th>
          <th data-a-h="center" data-b-a-s="thin" data-f-bold="true">Состояние</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle" class="center">${s.id}</td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle">${s.kdoType.name}</td>
            <td data-a-h="left" data-b-a-s="thin" style="vertical-align: middle">
              <a href="#" onclick="editDict(${s.id});return false;">${s.name}</a>
            </td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.real_price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.real_price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_real_price}" type = "number"/></td>
            <td data-a-h="right" data-b-a-s="thin" style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_real_price * (100 + sessionScope.ENV.params['NDS_PROC']) / 100}" type = "number"/></td>
            <td data-a-h="center" data-b-a-s="thin" style="vertical-align: middle; text-align: center">
              <c:if test="${s.state == 'A'}">Активный</c:if>
              <c:if test="${s.state == 'P'}">Пассивный</c:if>
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
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:900px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты услуги</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Группа*:</td>
              <td>
                <select id="kdo_group" class="form-control" name="group" onchange="setStatGroup(this)">
                  <c:forEach items="${groups}" var="g">
                  <option value="${g.id}">${g.name}</option>
                </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="kdo-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Форма*:</td>
              <td>
                <select id="form_id" class="form-control" name="form_id" onchange="setForm(this)">
                  <c:forEach items="${forms}" var="g">
                    <option value="${g.id}">${g.id} - ${g.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr class="form777">
              <td class="right bold">Норма*:</td>
              <td>
                <input type="text" id="norma" class="form-control" name="norma" value=""/>
              </td>
            </tr>
            <tr class="form777">
              <td class="right bold">Ед. изм.*:</td>
              <td>
                <input type="text" id="ei" class="form-control" name="ei" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Цена (Резиденты)*:</td>
              <td>
                <input type="text" id="kdo-price" class="form-control right" name="price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Цена (Не резиденты)*:</td>
              <td>
                <input type="text" id="kdo-for-price" class="form-control right" name="for_price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Процент вознограждения (%):</td>
              <td>
                <input type="text" id="bonus_proc" class="form-control right" name="bonus_proc" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Реальная стоимость*:</td>
              <td>
                <input type="text" id="kdo-real-price" class="form-control right" name="real_price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Реальная стоимость (Иностранцы)*:</td>
              <td>
                <input type="text" id="kdo-for-real-price" class="form-control right" name="for_real_price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Физиотерапия время (мин)*:</td>
              <td>
                <input type="text" id="minTime" class="form-control right" name="minTime" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Физиотерапия время (макс)*:</td>
              <td>
                <input type="text" id="maxTime" class="form-control right" name="maxTime" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Комната*:</td>
              <td>
                <input type="text" id="room" class="form-control center" name="room" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Единица для физиотерапии*:</td>
              <td>
                <input type="text" id="fizei" class="form-control center" name="fizei" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Обязательное обследование?:</td>
              <td class="left">
                <input type="checkbox" checked name="necKdo" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Внешняя услуга?:</td>
              <td class="left">
                <input type="checkbox" checked name="out_service" value="Y"/>
              </td>
            </tr>
            <tr id="uzi-free">
              <td class="right bold">1 услуга бесплатная?:</td>
              <td class="left">
                <input type="checkbox" name="priced" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Пользователи:</td>
              <td class="left" id="kdo_users"></td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveStatKdo()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function saveStatKdo() {
    if($('#kdo-name').val() == '') {
      errMsg('Наименование не может быть пустым');
      return;
    }
    if($('#kdo_group').val() == '' || $('#kdo_group').val() == null) {
      errMsg('Группа не может быть пустым');
      return;
    }
    $.ajax({
      url: '/core/stat/service/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if (res.success) {
          getDOM('close-modal').click();
          setTimeout(function() {
            setPage('/core/stat/services.s?group=' + $('#sel_kdo_group').val());
          }, 500);
        }
      }
    });
  }
  function setForm(dom){
    if(dom.value == 777) {
      $('.form777').show();
    } else {
      $('.form777').hide();
    }
  }
  function editDict(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/core/stat/kdo/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(id);
          $('*[name=name]').val(res.name);
          $('*[name=price]').val(res.price);
          $('*[name=form_id]').val(res.form);
          $('*[name=norma]').val(res.norma);
          $('*[name=ei]').val(res.ei);
          $('*[name=for_price]').val(res.for_price);
          $('*[name=real_price]').val(res.real_price);
          $('*[name=for_real_price]').val(res.for_real_price);
          $('*[name=bonus_proc]').val(res.bonus_proc);
          $('*[name=minTime]').val(res.minTime);
          $('*[name=maxTime]').val(res.maxTime);
          $('*[name=group]').val(res.group);
          $('*[name=room]').val(res.room);
          $('*[name=fizei]').val(res.fizei);
          $('#kdo_users').html(res.users);
          $('*[name=necKdo]').prop('checked', res.necKdo == 'Y');
          $('*[name=out_service]').prop('checked', res.out_service == 'Y');
          $('*[name=state]').prop('checked', res.state == 'A');
          if(res.kdoType === 4) {
            $('#uzi-free').show();
            $('*[name=priced]').prop('checked', res.priced == 'Y');
          } else
            $('#uzi-free').hide();
          if(res.form == 777) {
            $('.form777').show();
          } else {
            $('.form777').hide();
          }
        } else {
          errMsg(res.msg);
        }
      }
    });
  }
</script>
