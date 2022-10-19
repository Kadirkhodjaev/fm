<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addStat() {
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
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список стационарных услуг
    <div style="float:right">
      <table style="width:400px">
        <tr>
          <td>
            <select class="form-control" onchange="setPage('admin/stat/services.s?group=' + this.value)" id="sel_kdo_group">
              <option value="0">Все</option>
              <c:forEach items="${groups}" var="g">
                <option <c:if test="${g.id == group}">selected</c:if> value="${g.id}">${g.name}</option>
              </c:forEach>
            </select>
          </td>
          <td style="width:80px"><button class="btn btn-sm btn-success" type="button" onclick="addStat()" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button></td>
        </tr>
      </table>
    </div>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>ID</th>
          <th>Группировка</th>
          <th>Наименование</th>
          <th>Стоимость</th>
          <th>Стоимость (Иностранцы)</th>
          <th>Реальная стоимость</th>
          <th>Реальная стоимость (Иностранцы)</th>
          <th>Состояние</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td style="vertical-align: middle" class="center">${loop.index + 1}</td>
            <td style="vertical-align: middle">${s.kdoType.name}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="editDict(${s.id});return false;">${s.name}</a>
            </td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.real_price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_real_price}" type = "number"/></td>
            <td style="vertical-align: middle; text-align: center">
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
            <tr id="uzi-free">
              <td class="right bold">1 услуга бесплатная?:</td>
              <td class="left">
                <input type="checkbox" name="priced" value="Y"/>
              </td>
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
      alert('Наименование не может быть пустым');
      return;
    }
    if($('#kdo_group').val() == '' || $('#kdo_group').val() == null) {
      alert('Группа не может быть пустым');
      return;
    }
    $.ajax({
      url: '/admin/stat/kdoSave.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert("<ui:message code="successSave"/>");
          setPage('/admin/stat/services.s?group=' + $('#sel_kdo_group').val());
        } else {
          alert(res.msg);
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
      url: '/admin/stat/getKdo.s',
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
          $('*[name=minTime]').val(res.minTime);
          $('*[name=maxTime]').val(res.maxTime);
          $('*[name=group]').val(res.group);
          $('*[name=room]').val(res.room);
          $('*[name=fizei]').val(res.fizei);
          $('*[name=necKdo]').prop('checked', res.necKdo == 'Y');
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
          alert(res.msg);
        }
      }
    });
  }
</script>
