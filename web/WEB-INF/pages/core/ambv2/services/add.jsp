<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/jquery.mask.js"></script>
<script src="/res/js/common.js"></script>
<style>
  .table tr td {padding:10px !important;}
</style>
<div class="panel panel-info wpx-1400 margin-auto">
  <div class="panel-heading">
    Реквизиты услуги
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button"><a href="#" onclick="saveAmb()" title="Сохранить"><i class="fa fa-save"></i> Сохранить</a></li>
      <li class="paginate_button"><a href="#" onclick="$('#pager').load('/core/ambv2/services.s')" title="Назад"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <div class="panel-body">
    <form id="bf">
      <input type="hidden" name="id" value="${ser.id}">
      <table class="table table-bordered">
        <tr>
          <td class="bold">Категория:</td>
          <td>
            <select name="group" class="form-control" required>
              <option value="">Не выбрано</option>
              <c:forEach items="${groups}" var="t">
                <option <c:if test="${ser.group.id == t.id}">selected</c:if> value="${t.id}">${t.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td class="bold">Наименование:</td>
          <td><input type="text" class="form-control" value="${ser.name}" name="name" required></td>
        </tr>
        <tr>
          <td class="bold">Стоимость:</td>
          <td><input type="text" class="form-control right" value="${ser.price}" name="price" required></td>
        </tr>
        <tr>
          <td class="bold">Стоимость (Иностранцы):</td>
          <td><input type="text" class="form-control right" value="${ser.for_price}" name="for_price" required></td>
        </tr>
        <tr>
          <td class="bold">Очередность: </td>
          <td><input type="number" class="form-control center" name="ord" value="${ser.ord}"/></td>
        </tr>
        <tr>
          <td class="bold">Активный?:</td>
          <td><input type="checkbox" value="A" name="state" <c:if test="${ser.state == 'A'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Консультация?:</td>
          <td><input type="checkbox" value="Y" name="consul" <c:if test="${ser.consul == 'Y'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Амбулаторное лечение?:</td>
          <td><input type="checkbox" value="Y" name="treatment" <c:if test="${ser.treatment == 'Y'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Поле диагноз?:</td>
          <td><input type="checkbox" value="Y" name="diagnoz" <c:if test="${ser.diagnoz == 'Y'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Новая форма?:</td>
          <td><input type="checkbox" value="Y" name="new_form" <c:if test="${ser.newForm == 'Y'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Пользователи:</td>
          <td>${users}</td>
        </tr>
      </table>
      <c:if test="${ser.newForm == 'Y'}">
        <div class="w-100">
        <div class="border-bottom-1 pb-10">
          <table class="w-100">
            <tr>
              <td class="text-primary bold">Настройка формы</td>
              <td class="text-right">
                <table>
                  <tr>
                    <td class="p-5 bold">Формы:</td>
                    <td>
                      <select class="form-control wpx-150" onchange="setForm(this.value)">
                        <c:forEach items="${forms}" var="f">
                          <option <c:if test="${form.id == f.id}">selected</c:if> value="${f.id}"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${f.actDate}" /></option>
                        </c:forEach>
                      </select>
                    </td>
                    <td class="wpx-40 p-5">
                      <c:if test="${form.state == 'Y'}">
                        <button class="btn btn-success btn-icon" type="button" onclick="copyForm()">
                          <span class="fa fa-copy"></span>
                        </button>
                      </c:if>
                    </td>
                  </tr>
                </table>
              </td>
              <td class="wpx-300">
                <c:if test="${form.state != 'Y'}">
                  <input type="text" class="form-control" id="new_field_name" placeholder="Новое поле">
                </c:if>
              </td>
              <td class="wpx-40 text-center">
                <c:if test="${form.state != 'Y'}">
                  <button class="btn btn-success btn-icon" title="Добавить новое поле" onclick="addField()" type="button">
                    <span class="fa fa-plus"></span>
                  </button>
                </c:if>
              </td>
            </tr>
          </table>
        </div>
        <table class="w-100 light-table">
          <c:if test="${!text_exist}">
            <thead>
              <tr>
                <c:if test="${code_exist}">
                  <td class="wpx-100">Код</td>
                </c:if>
                <td>Наименование</td>
                <c:forEach items="${cols}" var="f" varStatus="loop">
                  <td>
                    <c:if test="${fn:length(cols) == 1 || form.state == 'Y'}">
                      ${f.name}
                    </c:if>
                    <c:if test="${fn:length(cols) > 1 && form.state != 'Y'}">
                      <table class="w-100">
                        <tr>
                          <td>
                            <input type="text" class="form-control text-center bold" value="${f.name}" onchange="setColName(this.value, ${f.id})"/>
                          </td>
                          <td class="wpx-40 text-center">
                            <button class="btn btn-danger btn-icon" type="button" onclick="deleteColumn(${f.id})">
                              <span class="fa fa-remove"></span>
                            </button>
                          </td>
                        </tr>
                      </table>
                    </c:if>
                  </td>
                </c:forEach>
                <c:if test="${norma_exist}">
                  <td>Норма</td>
                </c:if>
                <c:if test="${ei_exist}">
                  <td>Ед.изм.</td>
                </c:if>
                <c:if test="${!norma_exist && form.state != 'Y' && fn:length(fields) > 0}">
                  <td class="wpx-40 text-danger">
                    <button class="btn btn-success btn-icon" type="button" onclick="addColumn()">
                      <span class="fa fa-plus"></span>
                    </button>
                  </td>
                </c:if>
                <c:if test="${form.state != 'Y'}">
                  <td class="wpx-40 text-danger">
                    <span class="fa fa-trash"></span>
                  </td>
                </c:if>
              </tr>
            </thead>
          </c:if>
          <tbody>
            <c:forEach items="${fields}" var="f" varStatus="loop">
              <c:if test="${!text_exist}">
                <tr>
                  <c:if test="${f.typeCode != 'title'}">
                    <c:if test="${code_exist}">
                      <td class="pb-2 text-center">${f.code}</td>
                    </c:if>
                    <td class="pb-2">
                      <c:if test="${form.state != 'Y'}">
                        <a href="#" onclick="fieldForm(${f.id})">${f.name}</a>
                      </c:if>
                      <c:if test="${form.state == 'Y'}">
                        ${f.name}
                      </c:if>
                    </td>
                    <c:forEach items="${f.fields}" var="a" varStatus="lp">
                      <td class="pb-2">
                        <table class="w-100">
                          <tr>
                            <c:if test="${a.typeCode == 'select'}">
                              <td>
                                <select class="form-control">
                                  <c:forEach items="${a.options}" var="op">
                                    <option>${op.optName}</option>
                                  </c:forEach>
                                </select>
                              </td>
                            </c:if>
                            <c:if test="${a.typeCode != 'select'}">
                              <td>
                                <input type="text" disabled class="form-control">
                              </td>
                            </c:if>
                            <c:if test="${(form.state != 'Y' && fn:length(cols) == 1) || (form.state != 'Y' && lp.last)}">
                              <td class="wpx-40 text-danger p-5">
                                <button class="btn btn-danger btn-icon" type="button" onclick="deleteField(${a.id})">
                                  <span class="fa fa-remove"></span>
                                </button>
                              </td>
                            </c:if>
                          </tr>
                        </table>
                      </td>
                    </c:forEach>
                    <c:if test="${norma_exist}">
                      <td class="text-center">${f.norma}</td>
                    </c:if>
                    <c:if test="${ei_exist}">
                      <td class="text-center wpx-100">${f.ei}</td>
                    </c:if>
                  </c:if>
                </tr>
              </c:if>
              <c:if test="${text_exist}">
                <tr>
                  <td class="bold">
                    <table class="w-100">
                      <tr>
                        <td><a href="#" onclick="fieldForm(${f.id})">${f.name}</a></td>
                        <td class="wpx-40">
                          <button class="btn btn-danger btn-icon" type="button" onclick="deleteField(${f.id})">
                            <span class="fa fa-remove"></span>
                          </button>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <c:if test="${f.typeCode == 'text'}">
                    <td><textarea disabled class="form-control" style="resize: none"></textarea></td>
                  </c:if>
                  <c:if test="${f.typeCode != 'text' && f.typeCode != 'select'}">
                    <td>
                      <input type="text" disabled class="form-control">
                    </td>
                  </c:if>
                  <c:if test="${f.typeCode == 'select'}">
                    <td>
                      <select class="form-control">
                        <c:forEach items="${f.options}" var="op">
                          <option>${op.optName}</option>
                        </c:forEach>
                      </select>
                    </td>
                  </c:if>
                </tr>
              </c:if>
              <c:if test="${f.typeCode == 'title'}">
                <tr>
                  <td class="text-center bold pb-2" colspan="${fn:length(cols) + 1}">
                    <table class="w-100">
                      <tr>
                        <td>
                          <c:if test="${form.state != 'Y'}">
                            <a href="#" onclick="fieldForm(${f.id})">${f.name}</a>
                          </c:if>
                          <c:if test="${form.state == 'Y'}">
                            ${f.name}
                          </c:if>
                        </td>
                        <c:if test="${form.state != 'Y'}">
                          <td class="wpx-40">
                            <button class="btn btn-danger btn-icon" type="button" onclick="deleteField(${f.id})">
                              <span class="fa fa-remove"></span>
                            </button>
                          </td>
                        </c:if>
                      </tr>
                    </table>
                  </td>
                </tr>
              </c:if>
            </c:forEach>
          </tbody>
        </table>
      </div>
      </c:if>
    </form>
  </div>
</div>

<button class="hidden" id="btn_field_view" data-toggle="modal" data-target="#field_info"></button>
<div class="modal fade" id="field_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog wpx-1400">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title text-danger"><b class="fa fa-user"></b> Реквизиты поля</h4>
      </div>
      <div id="field_view"></div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function saveAmb() {
    if (checkForm($('#bf'))) {
      $.ajax({
        url: '/core/ambv2/service/save.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res)
          if(res.success) setForm(${form.id});
        }
      });
    }
  }
  function fieldForm(id) {
    $('#field_view').load('/core/ambv2/service/field/save.s?service=${ser.id}&id=' + id, ()=> {
      getDOM('btn_field_view').click();
    });
  }
  function addField() {
    let name = $('#new_field_name').val();
    if(name.length > 0) {
      $.ajax({
        url: '/core/ambv2/service/field/add.s',
        method: 'post',
        data: 'service=${ser.id}&form=${form.id}&label=' + encodeURIComponent(name),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setForm(${form.id});
        }
      });
    } else {
      openMedMsg('Наименование не может быть пустым', false);
    }
  }
  function deleteField(id) {
    if(confirm('Вы действительно хотите удалить выбранное поле?')) {
      $.ajax({
        url: '/core/ambv2/service/field/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setForm(${form.id});
        }
      });
    }
  }
  function addColumn() {
    $.ajax({
      url: '/core/ambv2/service/field/column/add.s',
      method: 'post',
      data: 'service=${ser.id}&form=${form.id}',
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setForm(${form.id});
      }
    });
  }
  function setForm(id) {
    $('#pager').load('/core/ambv2/service/save.s?id=${ser.id}&form=' + id)
  }
  function copyForm() {
    $.ajax({
      url: '/core/ambv2/service/field/form/copy.s',
      method: 'post',
      data: 'service=${ser.id}&form=${form.id}',
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) $('#pager').load('/core/ambv2/service/save.s?id=${ser.id}');
      }
    });
  }
  function setColName(name, id) {
    $.ajax({
      url: '/core/ambv2/service/field/column/name.s',
      method: 'post',
      data: 'id=' + id + '&name=' + encodeURIComponent(name),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setForm(${form.id});
      }
    });
  }
  function deleteColumn(col) {
    if(confirm('Вы действительно хотите удалить колонку?'))
      $.ajax({
        url: '/core/ambv2/service/field/column/delete.s',
        method: 'post',
        data: 'form=${form.id}&col=' + col,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setForm(${form.id});
        }
      });
  }
</script>
