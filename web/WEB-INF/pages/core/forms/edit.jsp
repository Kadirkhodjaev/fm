<%@ page pageEncoding="UTF-8" %>
<%-- Окно создания и изменения формы (Forms). Подключается через include в index.jsp и fields.jsp.
     После сохранения вызывает fmSaved(id, isNew), которую определяет страница. --%>
<div class="fm-overlay fm-admin" id="fmEditWin" onclick="if(event.target == this) fmEditClose()">
  <form class="fm-modal" id="fmEditForm" onsubmit="fmEditSave(); return false;" autocomplete="off">
    <input type="hidden" name="id" id="fe_id"/>
    <div class="fm-modal-head">
      <h3 id="fe_title">Новая форма</h3>
      <button type="button" class="fm-x" onclick="fmEditClose()"><i class="fa fa-times"></i></button>
    </div>
    <div class="fm-modal-body">
      <div>
        <label class="fm-l" for="fe_name">Наименование</label>
        <input class="fm-in" name="name" id="fe_name" maxlength="512"/>
      </div>
      <div class="fm-row" style="grid-template-columns:1fr 1fr">
        <div>
          <label class="fm-l" for="fe_type">Тип</label>
          <select class="fm-in" name="type" id="fe_type">
            <option value="1">Обычная</option>
            <option value="0">Редактируемая</option>
          </select>
        </div>
        <div>
          <label class="fm-l" for="fe_jsp">Свой шаблон (JSP)</label>
          <input class="fm-in" name="jsp" id="fe_jsp" maxlength="64" placeholder="пусто - стандартный"/>
        </div>
      </div>
      <div>
        <label class="fm-chk"><input type="checkbox" name="amb" value="Y" id="fe_amb"/> Амбулаторная форма</label>
      </div>
      <div>
        <div class="fm-sec" style="margin-bottom:8px">Колонки в форме ввода и печати</div>
        <label class="fm-chk"><input type="checkbox" name="norma_flag" value="Y" id="fe_norma"/> Норма</label>
        <label class="fm-chk"><input type="checkbox" name="ei_flag" value="Y" id="fe_ei"/> Ед. изм.</label>
        <label class="fm-chk"><input type="checkbox" name="code_flag" value="Y" id="fe_code"/> Код</label>
        <div class="fm-hint" style="margin-top:6px">Коды задаются у каждого поля формы.</div>
      </div>
      <div>
        <div class="fm-sec" style="margin-bottom:8px">Дополнительно</div>
        <div class="fm-row" style="grid-template-columns:1fr">
          <div>
            <label class="fm-l" for="fe_result">Таблица результата (result)</label>
            <input class="fm-in" name="result" id="fe_result" maxlength="64" placeholder="обычно пусто"/>
          </div>
          <label class="fm-chk"><input type="checkbox" name="shapka" value="Y" id="fe_shapka" onchange="$('#fe_shapka_box').toggle(this.checked)"/> Шапка в печатной форме</label>
          <div class="fm-row" id="fe_shapka_box" style="grid-template-columns:1fr 1fr; display:none">
            <div>
              <label class="fm-l" for="fe_shapka_left">Шапка слева</label>
              <textarea class="fm-in" name="shapka_left" id="fe_shapka_left" rows="3"></textarea>
            </div>
            <div>
              <label class="fm-l" for="fe_shapka_right">Шапка справа</label>
              <textarea class="fm-in" name="shapka_right" id="fe_shapka_right" rows="3"></textarea>
            </div>
          </div>
        </div>
      </div>
      <div class="fm-err" id="fe_err"></div>
    </div>
    <div class="fm-modal-foot">
      <span class="fm-hint" id="fe_idlabel"></span>
      <span class="fm-spacer" style="flex:1"></span>
      <button type="button" class="fm-btn" onclick="fmEditClose()">Отмена</button>
      <button type="submit" class="fm-btn primary" id="fe_save"><i class="fa fa-floppy-o"></i>Сохранить</button>
    </div>
  </form>
</div>
<script>
  function fmEdit(id) {
    var f = document.getElementById('fmEditForm');
    f.reset();
    $('#fe_err').hide();
    $('#fe_id').val(id || '');
    $('#fe_title').text(id ? 'Изменить форму' : 'Новая форма');
    $('#fe_idlabel').text(id ? 'ID ' + id : '');
    $('#fe_shapka_box').hide();
    $('#fe_type option.extra').remove();
    if (!id) {
      // новая форма: по умолчанию Норма и Ед. изм. включены, как у старых форм
      $('#fe_norma, #fe_ei').prop('checked', true);
      $('#fmEditWin').addClass('open');
      $('#fe_name').focus();
      return;
    }
    $.ajax({
      url: '/core/form/get.s', method: 'post', dataType: 'json', data: {id: id},
      success: function (d) {
        if (!d.success) { errMsg(d.msg); return; }
        $('#fe_name').val(d.form_name);
        if (!$('#fe_type option[value="' + d.type + '"]').length)
          $('#fe_type').append($('<option class="extra"/>').val(d.type).text('Тип ' + d.type));
        $('#fe_type').val(String(d.type));
        $('#fe_jsp').val(d.jsp);
        $('#fe_result').val(d.result);
        $('#fe_amb').prop('checked', d.amb == 'Y');
        // пустой флаг у старых форм означает «показывать» для нормы и ед. изм.
        $('#fe_norma').prop('checked', d.norma_flag != 'N');
        $('#fe_ei').prop('checked', d.ei_flag != 'N');
        $('#fe_code').prop('checked', d.code_flag == 'Y');
        $('#fe_shapka').prop('checked', d.shapka === true || d.shapka == 'true');
        $('#fe_shapka_left').val(d.shapka_left);
        $('#fe_shapka_right').val(d.shapka_right);
        $('#fe_shapka_box').toggle($('#fe_shapka').is(':checked'));
        $('#fmEditWin').addClass('open');
        $('#fe_name').focus();
      }
    });
  }
  function fmEditClose() {
    $('#fmEditWin').removeClass('open');
  }
  function fmEditSave() {
    if (!$.trim($('#fe_name').val())) {
      $('#fe_err').text('Введите наименование формы').show();
      $('#fe_name').focus();
      return;
    }
    var isNew = !$('#fe_id').val();
    $('#fe_save').prop('disabled', true);
    $.ajax({
      url: '/core/form/save.s', method: 'post', dataType: 'json', data: $('#fmEditForm').serialize(),
      success: function (res) {
        if (!res.success) { $('#fe_err').text(res.msg == 'EMPTY_NAME' ? 'Введите наименование формы' : res.msg).show(); return; }
        fmEditClose();
        openMedMsg('Форма сохранена', true);
        fmSaved(res.id, isNew);
      },
      complete: function () { $('#fe_save').prop('disabled', false); }
    });
  }
  $(document).off('keydown.fmedit').on('keydown.fmedit', function (e) { if (e.keyCode == 27) { fmEditClose(); if (window.fmValsClose) fmValsClose(); } });
</script>
