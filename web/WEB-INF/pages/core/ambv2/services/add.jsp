<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
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
              <td class="wpx-300">
                <input type="text" class="form-control" id="new_field_name" placeholder="Новое поле">
              </td>
              <td class="wpx-40 text-center">
                <button class="btn btn-success btn-icon" title="Добавить новое поле" onclick="addField()" type="button">
                  <span class="fa fa-plus"></span>
                </button>
              </td>
            </tr>
          </table>
        </div>
        <table class="w-100 light-table">
          <thead>
            <tr>
              <td class="wpx-40">№</td>
              <td>Наименование</td>
              <td>Настройки</td>
              <td class="wpx-40 text-danger">
                <span class="fa fa-trash"></span>
              </td>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${fields}" var="f" varStatus="loop">
              <input type="hidden" name="field_id" value="${f.id}">
              <tr>
                <td class="vertical-align-middle text-center">${loop.index + 1}</td>
                <td class="p-5 wpx-300">
                  <input type="text" class="form-control" name="field_label" value="${f.fieldLabel}"/>
                </td>
                <td>
                  <table class="w-100">
                    <tr>
                      <td class="p-5 text-right wpx-100">Тип <req>*</req>:</td>
                      <td class="p-5 wpx-300">
                        <select class="form-control" name="field_type_code" onchange="setFieldType(this.value, ${f.id})">
                          <option <c:if test="${f.typeCode == 'float_norm'}">selected</c:if> value="float_norm">Цифровое поле с нормами</option>
                          <option <c:if test="${f.typeCode == 'float_nonorm'}">selected</c:if> value="float_nonorm">Цифровое поле без норм</option>
                          <option <c:if test="${f.typeCode == 'input_norm'}">selected</c:if> value="input_norm">Текствое поле</option>
                          <option <c:if test="${f.typeCode == 'input_nonorm'}">selected</c:if> value="input_nonorm">Текствое поле с нормами</option>
                          <option <c:if test="${f.typeCode == 'select'}">selected</c:if> value="select">Выбрачное поле</option>
                          <option <c:if test="${f.typeCode == 'text'}">selected</c:if> value="text">Массивный текст</option>
                        </select>
                      </td>
                      <td rowspan="3" class="vertical-align-top p-5">
                        <table class="w-100 light-table" id="form_field_select_block_${f.id}">
                          <tbody>
                            <tr>
                              <td class="p-5 wpx-100">Значение: </td>
                              <td class="p-5">
                                <input type="text" value="" class="form-control" id="new_field_option_${f.id}" placeholder="Новое значение для выбора"/>
                              </td>
                              <td class="wpx-40">
                                <button class="btn btn-success btn-icon" type="button" onclick="addFieldOption(${f.id})">
                                  <span class="fa fa-check"></span>
                                </button>
                              </td>
                            </tr>
                            <c:forEach items="${f.options}" var="op" varStatus="loop">
                              <c:if test="${op.field == f.id}">
                                <tr>
                                  <td class="text-right">${loop.index + 1}</td>
                                  <td>${op.optName}</td>
                                  <td class="wpx-40 text-center pb-2">
                                    <button class="btn btn-danger btn-icon" type="button" onclick="deleteOption(${op.id})">
                                      <span class="fa fa-trash"></span>
                                    </button>
                                  </td>
                                </tr>
                              </c:if>
                            </c:forEach>
                          </tbody>
                        </table>
                        <table class="w-100" id="all_norm_block_${f.id}">
                          <tr>
                            <td class="text-center bold" colspan="2">Диапазон нормы</td>
                          </tr>
                          <tr>
                            <td class="p-5">
                              <input type="hidden" name="field_norma_${f.id}" value="${f.normaId}"/>
                              <input type="text" maxlength="10" name="field_norma_from_${f.id}" class="form-control money text-center" placeholder="Норма с" value="${f.normaFrom}">
                            </td>
                            <td class="p-5">
                              <input type="text" maxlength="10" name="field_norma_to_${f.id}" class="form-control money text-center" placeholder="Норма по" value="${f.normaTo}">
                            </td>
                          </tr>
                        </table>
                        <table class="w-100" id="sex_norm_block_${f.id}">
                          <tr>
                            <td class="text-center bold" colspan="2">Мужчина</td>
                            <td class="text-center bold" colspan="2">Женщина</td>
                          </tr>
                          <tr>
                            <td class="text-center bold" colspan="2">Диапазон нормы</td>
                            <td class="text-center bold" colspan="2">Диапазон нормы</td>
                          </tr>
                          <tr>
                            <td class="p-5">
                              <input type="hidden" name="field_male_norma_${f.id}" value="${f.maleNormaId}"/>
                              <input type="text" maxlength="10" name="field_male_norma_from_${f.id}" class="form-control money text-center" placeholder="Норма с" value="${f.maleNormaFrom}">
                            </td>
                            <td class="p-5">
                              <input type="text" maxlength="10" name="field_male_norma_to_${f.id}" class="form-control money text-center" placeholder="Норма по" value="${f.maleNormaTo}">
                            </td>
                            <td class="p-5">
                              <input type="hidden" name="field_female_norma_${f.id}" value="${f.femaleNormaId}"/>
                              <input type="text" maxlength="10" name="field_female_norma_from_${f.id}" class="form-control money text-center" placeholder="Норма с" value="${f.femaleNormaFrom}">
                            </td>
                            <td class="p-5">
                              <input type="text" maxlength="10" name="field_female_norma_to_${f.id}" class="form-control money text-center" placeholder="Норма по" value="${f.femaleNormaTo}">
                            </td>
                          </tr>
                        </table>
                        <table class="w-100 light-table" id="year_norm_block_${f.id}">
                          <thead>
                          <tr>
                            <td colspan="4" class="pb-2">
                              Нормы по возрасту
                            </td>
                            <td class="wpx-40 text-center">
                              <button type="button" class="btn btn-success btn-icon" onclick="addNorma(${f.id}, 'year_norm')">
                                <span class="fa fa-plus"></span>
                              </button>
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">Возраст диапазон</td>
                            <td colspan="2">Норма диапазон</td>
                          </tr>
                          </thead>
                          <tbody>
                          <c:forEach items="${f.normas}" var="a">
                            <c:if test="${a.normType == 'year_norm'}">
                              <tr>
                                <td class="pb-2">
                                  <input type="hidden" name="year_norm_id_${f.id}" value="${a.id}"/>
                                  <input type="text" name="year_norm_year_from_${a.id}" maxlength="3" class="form-control human_year text-center" value="${a.yearFrom}" placeholder="С">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="year_norm_year_to_${a.id}" maxlength="3" class="form-control human_year text-center" value="${a.yearTo}" placeholder="По">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="year_norm_norm_from_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaFrom}" placeholder="С">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="year_norm_norm_to_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaTo}" placeholder="По">
                                </td>
                                <td class="pb-2 text-center">
                                  <button type="button" class="btn btn-danger btn-icon" onclick="delNorma(${a.id})">
                                    <span class="fa fa-remove"></span>
                                  </button>
                                </td>
                              </tr>
                            </c:if>
                          </c:forEach>
                          </tbody>
                        </table>
                        <table class="w-100 light-table" id="sex_year_norm_block_${f.id}">
                          <thead>
                          <tr>
                            <td colspan="5" class="pb-2">
                              Нормы по возрасту
                            </td>
                            <td class="wpx-40 text-center">
                              <button type="button" class="btn btn-success btn-icon" onclick="addNorma(${f.id}, 'sex_year_norm')">
                                <span class="fa fa-plus"></span>
                              </button>
                            </td>
                          </tr>
                          <tr>
                            <td class="wpx-100">Пол</td>
                            <td colspan="2">Возраст диапазон</td>
                            <td colspan="2">Норма диапазон</td>
                          </tr>
                          </thead>
                          <tbody>
                          <c:forEach items="${f.normas}" var="a">
                            <c:if test="${a.normType == 'sex_year_norm'}">
                              <tr>
                                <td class="pb-2">
                                  <select class="form-control" name="sex_year_norm_sex_${a.id}">
                                    <option <c:if test="${a.sex == 'male'}">selected</c:if> value="male">Мужчина</option>
                                    <option <c:if test="${a.sex == 'female'}">selected</c:if> value="female">Женшина</option>
                                  </select>
                                </td>
                                <td class="pb-2">
                                  <input type="hidden" name="sex_year_norm_id_${f.id}" value="${a.id}"/>
                                  <input type="text" name="sex_year_norm_year_from_${a.id}" maxlength="3" class="form-control human_year text-center" value="${a.yearFrom}" placeholder="С">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="sex_year_norm_year_to_${a.id}" maxlength="3" class="form-control human_year text-center" value="${a.yearTo}" placeholder="По">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="sex_year_norm_norm_from_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaFrom}" placeholder="С">
                                </td>
                                <td class="pb-2">
                                  <input type="text" name="sex_year_norm_norm_to_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaTo}" placeholder="По">
                                </td>
                                <td class="pb-2 text-center">
                                  <button type="button" class="btn btn-danger btn-icon" onclick="delNorma(${a.id})">
                                    <span class="fa fa-remove"></span>
                                  </button>
                                </td>
                              </tr>
                            </c:if>
                          </c:forEach>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr class="with_norm_field_${f.id}">
                      <td class="p-5 text-right">Тип нормы <req>*</req>:</td>
                      <td class="p-5">
                        <select class="form-control" id="field_norm_type_${f.id}" name="norm_type" onchange="setNormType(this.value, ${f.id})">
                          <option <c:if test="${f.normaType == 'all'}">selected</c:if> value="all">Общая норма для всех</option>
                          <option <c:if test="${f.normaType == 'sex_norm'}">selected</c:if> value="sex_norm">Норма отдельно от пола</option>
                          <option <c:if test="${f.normaType == 'year_norm'}">selected</c:if> value="year_norm">Норма отдельно от возраста</option>
                          <option <c:if test="${f.normaType == 'sex_year_norm'}">selected</c:if> value="sex_year_norm">Норма отдельно от возраста и от пола</option>
                        </select>
                      </td>
                    </tr>
                    <tr class="with_norm_field_${f.id}">
                      <td class="p-5 text-right">Ед. изм. :</td>
                      <td class="p-5">
                        <input type="text" maxlength="20" name="field_ei" class="form-control text-center" value="${f.ei}"/>
                      </td>
                    </tr>
                  </table>
                </td>
                <td class="vertical-align-middle text-center">
                  <button class="btn btn-danger btn-icon" type="button" onclick="deleteField(${f.id})">
                    <span class="fa fa-remove"></span>
                  </button>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
      </c:if>
    </form>
  </div>
</div>
<script>
  $(() => {
    $('.money').mask("# ##0.00", {reverse: true});
    $('.human_year').mask("000", {reverse: true});
  });
  function reloadPage(res) {
    if(res.success) $('#pager').load('/core/ambv2/service/save.s?id=${ser.id}');
  }
  function saveAmb() {
    if (checkForm($('#bf'))) {
      $.ajax({
        url: '/core/ambv2/service/save.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res)
          reloadPage(res);
        }
      });
    }
  }
  function addField() {
    let name = $('#new_field_name').val();
    if(name.length > 0) {
      $.ajax({
        url: '/core/ambv2/service/field/add.s',
        method: 'post',
        data: 'service=${ser.id}&label=' + encodeURIComponent(name),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          reloadPage(res);
        }
      });
    } else {
      openMedMsg('Наименование не может быть пустым', false);
    }
  }
  function setFieldType(val, id) {
    $('.with_norm_field_' + id).toggle(val.indexOf('_norm') > 0);
    $('#form_field_select_block_' + id).toggle(val === 'select');
    //
    let normType = val.indexOf('_norm') > 0 ? $('#field_norm_type_' + id).val() : '';
    setNormType(normType, id);
  }
  function addFieldOption(field) {
    let option = $('#new_field_option_' + field).val();
    $.ajax({
      url: '/core/ambv2/service/field/option/add.s',
      method: 'post',
      data: 'service=${ser.id}&field=' + field + '&name=' + encodeURIComponent(option),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        reloadPage(res);
      }
    });
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
          reloadPage(res);
        }
      });
    }
  }
  function deleteOption(id) {
    if(confirm('Вы действительно хотите удалить выбранное значение?')) {
      $.ajax({
        url: '/core/ambv2/service/field/option/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          reloadPage(res);
        }
      });
    }
  }
  function setNormType(val, id) {
    $('#all_norm_block_' + id).toggle(val === 'all');
    $('#sex_norm_block_' + id).toggle(val === 'sex_norm');
    $('#year_norm_block_' + id).toggle(val === 'year_norm');
    $('#sex_year_norm_block_' + id).toggle(val === 'sex_year_norm');
  }
  function addNorma(id, type) {
    $.ajax({
      url: '/core/ambv2/service/field/norma/add.s',
      method: 'post',
      data: 'service=${ser.id}&field=' + id + '&type=' + type,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        reloadPage(res);
      }
    });
  }
  function delNorma(id) {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/core/ambv2/service/field/norma/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          reloadPage(res);
        }
      });
  }
  <c:forEach items="${fields}" var="f">
    setFieldType('${f.typeCode}', '${f.id}');
  </c:forEach>
</script>
