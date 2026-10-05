<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<script>
  function saveLv() {
    $.ajax({
      url: "/reg/lvConf.s",
      method: "post",
      data: ($('#lv').val() != '' && $('#lv').val() != undefined ? 'lv=' + $('#lv').val(): '') + '&zavlv=' + $('#zavlv').val(),
      dataType: 'json',
      success: function (data) {
        openMsg(data);
        if (data.success) {
          parent.openMainPage('/patients/list.s?curPat=Y');
        }
      }
    });
  }
  function setLvPartner(lvpartner) {
    $.ajax({
      url: "/reg/lvpartner.s",
      method: "post",
      data: 'id=${pat.id}&lvpartner=' + lvpartner,
      dataType: 'json',
      success: function (data) {
        openMsg(data);
      }
    });
  }
  function saveClient() {
    if(checkForm($('#clientForm'))) {
      $.ajax({
        url: '/clients/save.s',
        method: 'post',
        data: $('#clientForm').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.dublicate) {
            getDOM('close_client_info').click();
            $('#client_list_content').load('/clients/exists_list.s?stat_id=${pat.id}', () => {
              getDOM('btn_client_list').click();
            });
          } else {
            if (res.success) setLocation('reg.s');
          }
        }
      });
    }
  }
  function addArchClient(id) {
    $.ajax({
      url: '/patients/stat/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('input[name=arch_cl_id]').val(res.id);
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        } else
          openMsg(res);
      }
    });
  }
  function chooseClient(id) {
    $.ajax({
      url: '/clients/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          getDOM('client_list_close').click();
          $('input[name=cl_id]').val(res.id);
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_doc_seria]').val(res.doc_seria);
          $('input[name=cl_doc_num]').val(res.doc_num);
          $('input[name=cl_doc_info]').val(res.passport);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        } else {
          openMsg(res);
        }
      }
    });
  }
</script>

<style>
  .rv { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width: 980px; margin: 0 auto; padding: 16px 12px 32px; color: var(--text);
    font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .rv-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:14px; overflow:hidden; }
  .rv-card-h { display:flex; align-items:center; gap:10px; padding:12px 18px; background:#FAFBFC; border-bottom:1px solid var(--border);
    font-size:12px; font-weight:700; letter-spacing:.5px; text-transform:uppercase; color:#6B7280; }
  .rv-card-h .fa { color:var(--brand); font-size:14px; }
  .rv-card-h .sp { flex:1; }

  /* Шапка пациента */
  .rv-head { display:flex; align-items:center; gap:14px; padding:16px 18px; }
  .rv-ava { flex:none; width:46px; height:46px; border-radius:13px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:20px; }
  .rv-name { flex:1; min-width:0; }
  .rv-name h2 { margin:0 0 3px; font-size:19px; font-weight:700; text-transform:uppercase; letter-spacing:.2px; }
  .rv-name .meta { display:flex; flex-wrap:wrap; gap:6px 14px; font-size:13px; color:var(--muted); }
  .rv-name .meta b { color:var(--text); font-weight:600; }

  /* Поля "подпись — значение" */
  .rv-dl { display:grid; grid-template-columns:repeat(4, 1fr); gap:16px 20px; margin:0; padding:16px 18px; }
  .rv-dl > div { min-width:0; }
  .rv-dl dt { margin-bottom:4px; font-size:12px; font-weight:600; color:var(--muted); }
  .rv-dl dd { margin:0; font-size:14px; font-weight:500; line-height:1.4; overflow-wrap:anywhere; }
  .rv-dl dd:empty::after { content:'—'; color:#C3C7CE; font-weight:400; }
  .rv-dl .w2 { grid-column:span 2; } .rv-dl .w4 { grid-column:span 4; }
  .rv-dl .hl dd { display:inline-block; padding:2px 10px; border-radius:8px; background:var(--brand-soft); color:var(--brand-dark); font-weight:700; }
  .rv-dl .hl dd:empty { background:transparent; padding:0; }
  .rv-dl .note dd { padding:10px 12px; background:#FAFBFC; border:1px solid #F0F1F4; border-radius:10px; font-weight:400; white-space:pre-line; }
  .rv-dl .note dd:empty { padding:0; background:transparent; border:0; }

  .rv .form-control { height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; color:var(--text); }
  .rv .form-control:focus, .rv-modal .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .rv-hint { font-size:11.5px; color:#9AA1AC; margin-top:4px; }

  .rv-btn { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 12px; border-radius:9px; border:1.5px solid var(--border);
    background:#fff; color:var(--text); font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .rv-btn:hover { background:var(--bg); }
  .rv-btn.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .rv-btn.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }

  /* Модальные окна */
  .rv-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .rv-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .rv-modal .modal-title { font-size:17px; font-weight:700; color:#1F2430; }
  .rv-modal .modal-title .fa { color:#D7182E; margin-right:6px; }
  .rv-modal .modal-body { padding:20px; }
  .rv-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; justify-content:flex-end; gap:8px; }
  .rv-modal .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:14px 16px; }
  .rv-modal .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .rv-modal .fg .s2 { grid-column:span 2; } .rv-modal .fg .s3 { grid-column:span 3; } .rv-modal .fg .s6 { grid-column:span 6; }
  .rv-modal .fg label { margin:0; font-size:12.5px; font-weight:600; color:#6B7280; }
  .rv-modal .fg label req { color:#D7182E; }
  .rv-modal .form-control { height:38px; border:1.5px solid #E6E8EC; border-radius:9px; box-shadow:none; font-size:14px; }

  @media (max-width: 900px) { .rv-dl { grid-template-columns:repeat(2, 1fr); } .rv-dl .w4 { grid-column:span 2; } }
</style>

<!-- ================= Модальное окно: реквизиты клиента ================= -->
<button class="hidden" id="btn_client_view" data-toggle="modal" data-target="#client_info"></button>
<div class="modal fade rv-modal" id="client_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" style="width:880px; max-width:95vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><i class="fa fa-user"></i> Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm">
          <input type="hidden" name="cl_id"/>
          <input type="hidden" name="stat_id" value="${pat.id}"/>
          <div class="fg">
            <div class="f s2"><label>Фамилия <req>*</req></label>
              <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/></div>
            <div class="f s2"><label>Имя <req>*</req></label>
              <input name="cl_name" title="Имя" placeholder="Имя" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/></div>
            <div class="f s2"><label>Отчество</label>
              <input name="cl_middlename" title="Отчество" placeholder="Отчество" class="form-control" maxlength="64" autocomplete="off"/></div>

            <div class="f s2"><label>Дата рождения <req>*</req></label>
              <input name="cl_birthdate" type="text" class="form-control date-format" placeholder="дд.мм.гггг" maxlength="10"/></div>
            <div class="f s2"><label>Пол <req>*</req></label>
              <select name="cl_sex_id" class="form-control">
                <c:forEach items="${sex}" var="sx">
                  <option value="${sx.id}">${sx.name}</option>
                </c:forEach>
              </select></div>
            <div class="f s2"><label>Номер телефона</label>
              <input name="cl_tel" type="text" class="form-control" maxlength="400"/></div>

            <div class="f"><label>Серия паспорта</label>
              <input name="cl_doc_seria" type="text" class="form-control text-center uppercase" maxlength="2" placeholder="AA"/></div>
            <div class="f s2"><label>Номер паспорта</label>
              <input name="cl_doc_num" type="text" class="form-control" maxlength="10" placeholder="1234567"/></div>
            <div class="f s3"><label>Паспортные данные</label>
              <input name="cl_doc_info" type="text" class="form-control" maxlength="64" placeholder="Кем и когда выдан"/></div>

            <div class="f s3"><label>Резидентство <req>*</req></label>
              <select name="cl_country_id" class="form-control" onchange="$('select[name=cl_region_id]').toggle(this.value === '199').val()">
                <c:forEach items="${countries}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select></div>
            <div class="f s3"><label>Область</label>
              <select name="cl_region_id" class="form-control">
                <option value=""></option>
                <c:forEach items="${regions}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select></div>

            <div class="f s6"><label>Адрес</label>
              <input name="cl_address" type="text" class="form-control" maxlength="400"/></div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="rv-btn" id="close_client_info" data-dismiss="modal" aria-hidden="true">Закрыть</button>
        <button type="button" class="rv-btn primary" onclick="saveClient()"><i class="fa fa-save"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<!-- ================= Модальное окно: похожие клиенты ================= -->
<button class="hidden" id="btn_client_list" data-toggle="modal" data-target="#client_list"></button>
<div class="modal fade rv-modal" id="client_list" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" style="width:880px; max-width:95vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="client_list_close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><i class="fa fa-users"></i> Похожие клиенты</h4>
      </div>
      <div class="modal-body" id="client_list_content"></div>
    </div>
  </div>
</div>

<div style="display: none">
  <button onclick="saveLv()" id="saveBtn"></button>
</div>

<div class="rv">

  <!-- ================= Пациент ================= -->
  <div class="rv-card">
    <div class="rv-head">
      <div class="rv-ava"><i class="fa fa-user"></i></div>
      <div class="rv-name">
        <h2>${pat.surname} ${pat.name} ${pat.middlename}</h2>
        <div class="meta">
          <span>Тугилган сана: <b><fmt:formatDate pattern="dd.MM.yyyy" value="${pat.birthday}"/></b></span>
          <span>Жинси: <b>${pat.sex.name}</b></span>
          <c:if test="${not empty pat.tel}"><span><i class="fa fa-phone"></i> <b>${pat.tel}</b></span></c:if>
        </div>
      </div>
      <c:if test="${pat.id > 0 && pat.state == 'ARCH' && pat.client == null}">
        <button type="button" class="rv-btn primary" onclick="addArchClient(${pat.id})" title="Привязать клиента"><i class="fa fa-user-plus"></i> Привязать клиента</button>
      </c:if>
    </div>
  </div>

  <!-- ================= Личные данные ================= -->
  <div class="rv-card">
    <div class="rv-card-h"><i class="fa fa-id-card-o"></i> Личные данные</div>
    <dl class="rv-dl">
      <div><dt>Фукоролик</dt><dd>${country}</dd></div>
      <div><dt>Вилоят</dt><dd>${region}</dd></div>
      <div class="w2"><dt>Паспорт маълумотлари</dt><dd>${pat.passportInfo}</dd></div>
      <div class="w4"><dt>Манзили</dt><dd>${pat.address}</dd></div>
      <div><dt>Телефон раками</dt><dd>${pat.tel}</dd></div>
      <div><dt>Амб. картаси раками</dt><dd>${pat.ambNum}</dd></div>
      <div><dt>Иш жойи</dt><dd>${pat.work}</dd></div>
      <div><dt>Мансаби</dt><dd>${pat.post}</dd></div>
    </dl>
  </div>

  <!-- ================= Госпитализация ================= -->
  <div class="rv-card">
    <div class="rv-card-h"><i class="fa fa-bed"></i> Госпитализация</div>
    <dl class="rv-dl">
      <div><dt>Булим</dt><dd>${pat.dept.name}</dd></div>
      <div class="hl"><dt>№ Хона</dt><dd>${pat.room.name}<c:if test="${not empty pat.room.roomType.name}"> · ${pat.room.roomType.name}</c:if></dd></div>
      <div><dt>Руйхатга олинган вакт</dt><dd>${pat.time}</dd></div>
      <div><dt>Тениаринхоз санаси</dt><dd>${pat.tarDate}</dd></div>

      <div class="w2">
        <dt>Даволовчи шифокор</dt>
        <c:choose>
          <c:when test="${pat.state == 'CZG' && sessionScope.ENV.roleId == 6}">
            <dd style="overflow:visible">
              <select id="lv" class="form-control">
                <option value=""></option>
                <c:forEach items="${lvs}" var="f">
                  <option <c:if test="${lv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
                </c:forEach>
              </select>
              <div class="rv-hint">Сохраняется кнопкой «Сохранить» вверху</div>
            </dd>
          </c:when>
          <c:otherwise><dd>${lv.fio}</dd></c:otherwise>
        </c:choose>
      </div>
      <div class="w2">
        <dt>Булим бошлиги</dt>
        <c:choose>
          <c:when test="${sessionScope.ENV.roleId == 6}">
            <dd style="overflow:visible">
              <select id="zavlv" class="form-control">
                <option value=""></option>
                <c:forEach items="${zavs}" var="f">
                  <option <c:if test="${pat.zavlv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
                </c:forEach>
              </select>
            </dd>
          </c:when>
          <c:otherwise><dd>${pat.zavlv.fio}</dd></c:otherwise>
        </c:choose>
      </div>

      <div><dt>Бемор қайердан юборилган</dt><dd>${pat.orientedBy}</dd></div>
      <div><dt>Транспортда</dt><dd>${pat.transport}</dd></div>
      <div><dt>Олиб юриш турлари</dt><dd>${pat.vidPer.name}</dd></div>
      <div><dt>Метка</dt><dd>${pat.metka.name}</dd></div>

      <c:if test="${sessionScope.ENV.userId == 1}">
        <div class="w2">
          <dt>Йуналтирган мутахасис коди</dt>
          <dd style="overflow:visible">
            <select name="lvpartner_id" class="form-control" onchange="setLvPartner(this.value)">
              <option value=""></option>
              <c:forEach items="${lvpartners}" var="lvp">
                <option <c:if test="${pat.lvpartner.id == lvp.id}">selected</c:if> value="${lvp.id}">${lvp.code}</option>
              </c:forEach>
            </select>
            <div class="rv-hint">Сохраняется сразу при выборе</div>
          </dd>
        </div>
      </c:if>
    </dl>
  </div>

  <!-- ================= Медицинские данные ================= -->
  <div class="rv-card">
    <div class="rv-card-h"><i class="fa fa-heartbeat"></i> Медицинские данные</div>
    <dl class="rv-dl">
      <div><dt>Буйи</dt><dd>${pat.rost}<c:if test="${not empty pat.rost}"> см</c:if></dd></div>
      <div><dt>Огирлиги</dt><dd>${pat.ves}<c:if test="${not empty pat.ves}"> кг</c:if></dd></div>
      <div><dt>Харорати</dt><dd>${pat.temp}<c:if test="${not empty pat.temp}"> °C</c:if></dd></div>
      <div><dt>Қон гуруҳи / Резус</dt><dd>${pat.bloodGroup.name}<c:if test="${not empty pat.bloodGroup.name && not empty pat.resus}"> · </c:if>${pat.resus}</dd></div>
      <div class="w4 note"><dt>Дориларнинг ножуя тасири</dt><dd>${pat.drugEffect}</dd></div>
      <div class="w4 note"><dt>Йулланмадаги ташхис</dt><dd>${pat.diagnoz}</dd></div>
    </dl>
  </div>
</div>
