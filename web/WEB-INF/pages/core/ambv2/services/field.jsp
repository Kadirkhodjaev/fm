<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/jquery.mask.js"></script>
<script src="/res/js/common.js"></script>
<div class="modal-body">
  <form id="field_settings">
    <table class="w-100 light-table">
      <thead>
        <tr>
          <td class="wpx-600">Параметры</td>
          <td>Настройки</td>
        </tr>
      </thead>
      <tr>
        <td style="border:0">
          <table class="w-100 light-table">
            <tbody>
              <tr>
                <td class="p-5 text-right">Код: </td>
                <td class="p-5 wpx-300">
                  <input type="hidden" name="id" value="${f.id}">
                  <input type="text" class="form-control" name="code" value="${f.code}"/>
                </td>
              </tr>
              <tr>
                <td class="p-5 text-right">Наименование <req>*</req>: </td>
                <td class="p-5 wpx-300">
                  <input type="text" class="form-control" name="field_label" value="${f.fieldLabel}"/>
                </td>
              </tr>
              <tr>
                <td class="p-5 text-right wpx-100">Тип <req>*</req>:</td>
                <td class="p-5 wpx-300">
                  <select class="form-control" name="field_type_code" onchange="setFieldType(this.value, false)">
                    <c:if test="${!text_exist}">
                      <option <c:if test="${f.typeCode == 'float_norm'}">selected</c:if> value="float_norm">Цифровое поле с нормами</option>
                      <option <c:if test="${f.typeCode == 'float_nonorm'}">selected</c:if> value="float_nonorm">Цифровое поле без норм</option>
                    </c:if>
                    <option <c:if test="${f.typeCode == 'input_nonorm'}">selected</c:if> value="input_nonorm">Текствое поле</option>
                    <option <c:if test="${f.typeCode == 'select'}">selected</c:if> value="select">Выбрачное поле</option>
                    <option <c:if test="${f.typeCode == 'text'}">selected</c:if> value="text">Массивный текст</option>
                    <c:if test="${!text_exist}">
                      <option <c:if test="${f.typeCode == 'title'}">selected</c:if> value="title">Заголовка</option>
                    </c:if>
                  </select>
                </td>
              </tr>
              <tr class="with_norm_field">
                <td class="p-5 text-right">Тип нормы <req>*</req>:</td>
                <td class="p-5">
                  <select class="form-control" id="field_norm_type" name="norm_type" onchange="setNormType(this.value, false)">
                    <option <c:if test="${f.normaType == 'all'}">selected</c:if> value="all">Общая норма для всех</option>
                    <option <c:if test="${f.normaType == 'sex_norm'}">selected</c:if> value="sex_norm">Норма отдельно от пола</option>
                    <option <c:if test="${f.normaType == 'year_norm'}">selected</c:if> value="year_norm">Норма отдельно от возраста</option>
                    <option <c:if test="${f.normaType == 'sex_year_norm'}">selected</c:if> value="sex_year_norm">Норма отдельно от возраста и от пола</option>
                    <option <c:if test="${f.normaType == 'cat_norm'}">selected</c:if> value="cat_norm">Норма по категориям</option>
                    <option <c:if test="${f.normaType == 'cat_sex_norm'}">selected</c:if> value="cat_sex_norm">Норма по полу и категориям</option>
                  </select>
                </td>
              </tr>
              <tr class="with_norm_field">
                <td class="p-5 text-right">Ед. изм. :</td>
                <td class="p-5">
                  <input type="text" maxlength="20" name="field_ei" class="form-control text-center" value="${f.ei}"/>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
        <td class="vertical-align-top" style="border:0">
          <div id="select_block_options">
            <table class="w-100 light-table">
              <tbody>
                <tr>
                  <td class="p-5 wpx-100">Значение: </td>
                  <td class="p-5">
                    <input type="text" value="" class="form-control" id="new_field_option" placeholder="Новое значение для выбора"/>
                  </td>
                  <td class="wpx-40">
                    <button class="btn btn-success btn-icon" type="button" onclick="addFieldOption()">
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
          </div>
          <div id="all_block">
            <table class="w-100">
              <tr>
                <td class="text-center bold" colspan="2">Диапазон нормы</td>
              </tr>
              <tr>
                <td class="p-5">
                  <input type="hidden" name="field_norma" value="${f.normaId}"/>
                  <input type="text" maxlength="10" name="field_norma_from" class="form-control money text-center" placeholder="Норма с" value="${f.normaFrom}">
                </td>
                <td class="p-5">
                  <input type="text" maxlength="10" name="field_norma_to" class="form-control money text-center" placeholder="Норма по" value="${f.normaTo}">
                </td>
              </tr>
            </table>
          </div>
          <div id="sex_norm_block">
            <table class="w-100">
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
                  <input type="hidden" name="field_male_norma" value="${f.maleNormaId}"/>
                  <input type="text" maxlength="10" name="field_male_norma_from" class="form-control money text-center" placeholder="Норма с" value="${f.maleNormaFrom}">
                </td>
                <td class="p-5">
                  <input type="text" maxlength="10" name="field_male_norma_to" class="form-control money text-center" placeholder="Норма по" value="${f.maleNormaTo}">
                </td>
                <td class="p-5">
                  <input type="hidden" name="field_female_norma" value="${f.femaleNormaId}"/>
                  <input type="text" maxlength="10" name="field_female_norma_from" class="form-control money text-center" placeholder="Норма с" value="${f.femaleNormaFrom}">
                </td>
                <td class="p-5">
                  <input type="text" maxlength="10" name="field_female_norma_to" class="form-control money text-center" placeholder="Норма по" value="${f.femaleNormaTo}">
                </td>
              </tr>
            </table>
          </div>
          <div id="year_norm_block">
            <table class="w-100 light-table">
              <thead>
              <tr>
                <td colspan="4" class="pb-2">
                  Нормы по возрасту
                </td>
                <td class="wpx-40 text-center">
                  <button type="button" class="btn btn-success btn-icon" onclick="addNorma('year_norm')">
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
                      <input type="hidden" name="year_norm_id" value="${a.id}"/>
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
          </div>
          <div id="sex_year_norm_block">
            <table class="w-100 light-table">
              <thead>
              <tr>
                <td colspan="5" class="pb-2">
                  Нормы по возрасту
                </td>
                <td class="wpx-40 text-center">
                  <button type="button" class="btn btn-success btn-icon" onclick="addNorma('sex_year_norm')">
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
                      <input type="hidden" name="sex_year_norm_id" value="${a.id}"/>
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
          </div>
          <div id="cat_norm_block">
            <table class="w-100 light-table">
              <thead>
              <tr>
                <td colspan="4" class="pb-2">
                  Нормы по категориям
                </td>
                <td class="wpx-40 text-center">
                  <button type="button" class="btn btn-success btn-icon" onclick="addNorma('cat_norm')">
                    <span class="fa fa-plus"></span>
                  </button>
                </td>
              </tr>
              <tr>
                <td>Категория</td>
                <td colspan="2">Норма диапазон</td>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${f.normas}" var="a">
                <c:if test="${a.normType == 'cat_norm'}">
                  <tr>
                    <td class="pb-2">
                      <input type="hidden" name="cat_norm_id" value="${a.id}"/>
                      <input type="text" name="cat_norm_name_${a.id}" class="form-control" value="${a.catName}" placeholder="Наименование категории">
                    </td>
                    <td class="pb-2">
                      <input type="text" name="cat_norm_norm_from_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaFrom}" placeholder="С">
                    </td>
                    <td class="pb-2">
                      <input type="text" name="cat_norm_norm_to_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaTo}" placeholder="По">
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
          </div>
          <div id="cat_sex_norm_block">
            <table class="w-100 light-table">
              <thead>
              <tr>
                <td colspan="4" class="pb-2">
                  Нормы по полу и категориям
                </td>
                <td class="wpx-40 text-center">
                  <button type="button" class="btn btn-success btn-icon" onclick="addNorma('cat_sex_norm')">
                    <span class="fa fa-plus"></span>
                  </button>
                </td>
              </tr>
              <tr>
                <td class="wpx-100">Пол</td>
                <td>Категория</td>
                <td colspan="2">Норма диапазон</td>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${f.normas}" var="a">
                <c:if test="${a.normType == 'cat_sex_norm'}">
                  <tr>
                    <td class="pb-2">
                      <select class="form-control" name="cat_sex_norm_sex_${a.id}">
                        <option <c:if test="${a.sex == 'male'}">selected</c:if> value="male">Мужчина</option>
                        <option <c:if test="${a.sex == 'female'}">selected</c:if> value="female">Женшина</option>
                      </select>
                    </td>
                    <td class="pb-2">
                      <input type="hidden" name="cat_sex_norm_id" value="${a.id}"/>
                      <input type="text" name="cat_sex_norm_name_${a.id}" class="form-control" value="${a.catName}" placeholder="Наименование категории">
                    </td>
                    <td class="pb-2">
                      <input type="text" name="cat_sex_norm_norm_from_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaFrom}" placeholder="С">
                    </td>
                    <td class="pb-2">
                      <input type="text" name="cat_sex_norm_norm_to_${a.id}" maxlength="10" class="form-control money text-center" value="${a.normaTo}" placeholder="По">
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
          </div>
        </td>
      </tr>
    </table>
  </form>
</div>
<div class="modal-footer">
  <button class="btn btn-success btn-sm" onclick="saveField()">
    <i class="fa fa-save"></i> Сохранить
  </button>
  <button class="btn btn-danger btn-sm" id="close_field_info" data-dismiss="modal" aria-hidden="true">
    <i class="fa fa-remove"></i> Закрыть
  </button>
</div>
<script>
  function reloadPage(res) {
    if(res.success) setTimeout(()=> {
      $('#field_view').load('/core/ambv2/service/field/save.s?service=${f.service}&id=${f.id}')
    }, 1000);
  }
  $(() => {
    $('.money').mask("# ##0.00", {reverse: true});
    $('.human_year').mask("000", {reverse: true});
    setFieldType('${f.typeCode}', true);
  });
  function addFieldOption() {
    let option = $('#new_field_option').val();
    $.ajax({
      url: '/core/ambv2/service/field/option/add.s',
      method: 'post',
      data: 'service=${f.service}&field=${f.id}&name=' + encodeURIComponent(option),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        reloadPage(res);
      }
    });
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
  function setFieldType(val, init) {
    $('.with_norm_field').toggle(val.indexOf('_norm') > 0 && val.indexOf('_nonorm') === -1);
    $('#select_block_options').toggle(val === 'select');
    //
    let normType = val.indexOf('_norm') > 0 ? $('#field_norm_type').val() : '';
    setNormType(normType, init);
    if(!init) {
      $('#field_settings * input, #field_settings * select').each((idx, dom) => {
        dom.disabled = true;
      });
      $.ajax({
        url: '/core/ambv2/service/field/type/set.s',
        method: 'post',
        data: 'id=${f.id}&type=' + val,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          reloadPage(res);
        }
      });
    }
  }
  function setNormType(val, init) {
    $('#all_block').toggle(val === 'all');
    $('#sex_norm_block').toggle(val === 'sex_norm');
    $('#year_norm_block').toggle(val === 'year_norm');
    $('#sex_year_norm_block').toggle(val === 'sex_year_norm');
    $('#cat_norm_block').toggle(val === 'cat_norm');
    $('#cat_sex_norm_block').toggle(val === 'cat_sex_norm');
    if(!init) {
      $('#field_settings * input, #field_settings * select').each((idx, dom) => {
        dom.disabled = true;
      });
      $.ajax({
        url: '/core/ambv2/service/field/norm/set.s',
        method: 'post',
        data: 'id=${f.id}&norm=' + val,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          reloadPage(res);
        }
      });
    }
  }
  function addNorma(type) {
    $.ajax({
      url: '/core/ambv2/service/field/norma/add.s',
      method: 'post',
      data: 'service=${f.service}&field=${f.id}&type=' + type,
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
  function saveField() {
    $.ajax({
      url: '/core/ambv2/service/field/save.s',
      method: 'post',
      data: $('#field_settings').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        getDOM('close_field_info').click();
        setTimeout(() => {
          $('#pager').load('/core/ambv2/service/save.s?id=${f.service}&form=${form.id}')
        }, 1000);
      }
    });
  }
</script>
