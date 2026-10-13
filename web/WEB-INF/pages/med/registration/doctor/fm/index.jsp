<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>
<script>
  var tab = 1;
  function saveForm() {
    if (checkForm($('form[name=bf]'))) {
      $.ajax({
        url: '/reg/doctor/index.s',
        method: 'post',
        data: $('form[name=bf]').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('${sessionScope.ENV.curUrl}');
        }
      });
    }
  }
  function nursePage(){
    $('#home').load('/reg/nurse/view.s');
  }
  function printPage(){
    window.open('/lv/print.s');
  }
  function setTab(id) {
    tab = id;
    $('.ar-tab').removeClass('on').filter('[data-tab=' + id + ']').addClass('on');
    $('.ar-pane').hide().filter('[data-pane=' + id + ']').show();
    if(id === 0) nursePage();
  }
  function confPatient() {
    setPage('/patients/confirm.s?id=${patient.id}');
  }
  function setText(dom, id) {
    $('#' + id).val(dom.innerHTML);
  }
  function setMkb(text, id) {
    var dom = document.getElementById('startDiagnoz');
    $('#mkb').val(id);
    dom.value = dom.value.length > 0 ? dom.value + ', ' + text : text;
    document.getElementById("mkb_id").value = id;
    document.getElementById("mkb").value = text;
  }
  function ekg() {
    window.open('/reg/ekg.s?id=${patient.id}');
  }
  function archPatient() {
    FmsConfirm('Вы действительно хотите архивировать данные?', function () {
      $.ajax({
        url: '/reg/doctor/archive.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('/patients/index.s');
        }
      });
    });
  }
</script>

<style>
  .ar { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width: 1100px; margin: 0 auto; padding: 16px 20px 40px; color: var(--text);
    font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ar-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:16px; }
  .ar-card-b { padding:18px; }

  /* Кнопки */
  .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px;
    border:1.5px solid var(--border); background:#fff; color:var(--text); font-size:13.5px; font-weight:600;
    white-space:nowrap; cursor:pointer; text-decoration:none !important; transition:background .12s,border-color .12s,color .12s; }
  .ab:hover { background:var(--bg); color:var(--text); }
  .ab .fa { color:var(--muted); }
  .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ab.primary .fa { color:#fff; }
  .ab.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .ab.danger:hover { background:var(--brand-soft); border-color:#F5C2C8; color:var(--brand); }
  .ab.danger:hover .fa { color:var(--brand); }

  /* Шапка пациента */
  .ar-head { display:flex; align-items:center; flex-wrap:wrap; gap:14px; padding:16px 18px; }
  .ar-avatar { flex:none; width:48px; height:48px; border-radius:14px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:20px; }
  .ar-title { flex:1 1 320px; min-width:0; }
  .ar-title h2 { margin:0 0 4px; font-size:20px; font-weight:700; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .ar-meta { display:flex; align-items:center; gap:10px; font-size:13px; color:var(--muted); white-space:nowrap; flex-wrap:wrap; }
  .ar-actions { margin-left:auto; display:flex; align-items:center; gap:8px; flex-wrap:wrap; justify-content:flex-end; }

  .st { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:999px; font-size:12px; font-weight:600; white-space:nowrap; }
  .st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .st-new  { background:#EAF1FE; color:#2563EB; }
  .st-amb  { background:#FEF3E2; color:#B45309; }
  .st-grn  { background:#E8F7EE; color:#15803D; }
  .st-gry  { background:#F1F2F4; color:#6B7280; }

  /* Вкладки */
  .ar-tabs { display:flex; gap:4px; padding:4px; margin:0 0 16px; background:#EEF0F3; border-radius:12px; width:max-content; max-width:100%; overflow-x:auto; }
  .ar-tab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 16px; border:0; border-radius:9px; background:transparent;
    color:var(--muted); font-size:13.5px; font-weight:600; white-space:nowrap; cursor:pointer; }
  .ar-tab:hover { color:var(--text); }
  .ar-tab.on { background:#fff; color:var(--text); box-shadow:0 1px 3px rgba(20,25,40,.10); }
  .ar-tab.on .fa { color:var(--brand); }
  #home .rv { padding:0; max-width:none; }
  /* кнопка шаблонов текста (выпадающий список bootstrap) в общем стиле */
  .fg .dropdown-toggle.btn { height:24px; padding:0 9px; border:1px solid var(--border); border-radius:7px; background:#fff; color:var(--muted); font-size:12px; font-weight:600; box-shadow:none; }
  .fg .dropdown-toggle.btn:hover { background:var(--bg); color:var(--text); }
  .fg .dropdown-menu { border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 30px rgba(20,25,40,.14); padding:4px; }
  .fg .dropdown-menu > li > a { border-radius:7px; padding:6px 10px; white-space:normal; }

  /* Сетка полей */
  .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:14px 16px; }
  .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .fg .s2 { grid-column:span 2; } .fg .s3 { grid-column:span 3; } .fg .s4 { grid-column:span 4; } .fg .s6 { grid-column:span 6; }
  .fg label { margin:0; font-size:12.5px; font-weight:600; color:var(--muted); }
  .fg label req { color:var(--brand); }
  .fg .lbl { display:flex; align-items:center; gap:4px; min-height:22px; }
  .fg .lbl label { flex:1; }
  .fg .lbl .btn-xs { height:26px; padding:0 9px; border:1.5px solid var(--border); border-radius:7px; color:var(--muted); font-size:12px; font-weight:600; box-shadow:none; }
  .fg .lbl .btn-xs:hover, .fg .lbl .open .btn-xs { background:var(--bg); color:var(--text); }
  .fg .lbl .dropdown-menu { border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 30px rgba(20,25,40,.14); padding:4px; }
  .fg .lbl .dropdown-menu > li > a { padding:7px 12px; border-radius:7px; font-size:13px; }
  .fg .q { font-size:13px; font-weight:500; color:var(--text); line-height:1.45; }
  .ar .form-control { height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; color:var(--text); }
  .ar .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .fg textarea.form-control { height:auto; min-height:76px; resize:vertical; padding-top:8px; font-family:inherit; }
  .ar-sec-t { grid-column:span 6; margin:6px 0 -2px; padding-top:14px; border-top:1px dashed var(--border);
    font-size:12px; font-weight:700; letter-spacing:.4px; text-transform:uppercase; color:#9AA1AC; }
  .ar-sec-t:first-child { margin-top:0; padding-top:0; border-top:0; }
  .ar-note { grid-column:span 6; padding:10px 12px; background:#FAFBFC; border:1px solid #F0F1F4; border-radius:10px; font-size:13px; color:var(--muted); line-height:1.45; }
  .ar-chk { display:flex; align-items:center; gap:10px; height:38px; padding:0 12px; border:1.5px solid var(--border); border-radius:9px; cursor:pointer;
    font-size:14px; font-weight:500 !important; color:var(--text) !important; }
  .ar-chk input { width:16px; height:16px; margin:0; accent-color:var(--brand); cursor:pointer; }

  @media (max-width: 900px) {
    .fg { grid-template-columns:repeat(2, 1fr); }
    .fg .s2, .fg .s3, .fg .s4, .fg .s6, .ar-sec-t, .ar-note { grid-column:span 2; }
  }
</style>

<div class="ar">

  <!-- ================= Шапка ================= -->
  <div class="ar-card">
    <div class="ar-head">
      <div class="ar-avatar"><i class="fa fa-user-md"></i></div>
      <div class="ar-title">
        <h2 title="ID ${patient.id}">${fio}</h2>
        <div class="ar-meta">
          <c:choose>
            <c:when test="${patient.state == 'PRD'}"><span class="st st-new">Приемное отделение</span></c:when>
            <c:when test="${patient.state == 'LV'}"><span class="st st-grn">Текущий пациент</span></c:when>
            <c:when test="${patient.state == 'CZG'}"><span class="st st-amb">Отправлен на утверждение</span></c:when>
            <c:when test="${patient.state == 'ZGV'}"><span class="st st-grn">Подтвержден</span></c:when>
            <c:when test="${patient.state == 'ARCH'}"><span class="st st-gry">Закрыта</span></c:when>
            <c:otherwise><span class="st st-gry">${patient.state}</span></c:otherwise>
          </c:choose>
          <span>ID ${patient.id}</span>
          <c:if test="${not empty patient.yearNum}"><span>№ ИБ ${patient.yearNum}</span></c:if>
          <c:if test="${not empty date_Begin}"><span>Поступил ${date_Begin}</span></c:if>
        </div>
      </div>
      <div class="ar-actions">
        <a href="#" class="ab" onclick="printPage(); return false;"><i class="fa fa-print"></i> Печать</a>
        <c:if test="${date_Begin == '' && patient.state == 'PRD'}">
          <a href="#" class="ab" onclick="ekg(); return false;"><i class="fa fa-line-chart"></i> ЭКГ</a>
        </c:if>
        <c:if test="${patient.state == 'PRD' || patient.state == 'LV'}">
          <a href="#" class="ab danger" onclick="archPatient(); return false;"><i class="fa fa-archive"></i> Архивация</a>
        </c:if>
        <c:if test="${date_Begin != '' && patient.state == 'PRD'}">
          <a href="#" class="ab" onclick="confPatient(); return false;"><i class="fa fa-check"></i> Подтвердить</a>
        </c:if>
        <a href="#" class="ab primary" onclick="saveForm(); return false;"><i class="fa fa-floppy-o"></i> Сохранить</a>
      </div>
    </div>
  </div>

  <!-- ================= Вкладки ================= -->
  <div class="ar-tabs">
    <button type="button" class="ar-tab" data-tab="0" onclick="setTab(0)"><i class="fa fa-user"></i> Регистрационные данные</button>
    <button type="button" class="ar-tab on" data-tab="1" onclick="setTab(1)"><i class="fa fa-stethoscope"></i> Основные данные</button>
    <button type="button" class="ar-tab" data-tab="2" onclick="setTab(2)"><i class="fa fa-list-alt"></i> Дополнительные данные</button>
  </div>

  <%@include file="/incs/msgs/successError.jsp"%>

  <!-- Регистрационные данные (страница медсестры, только просмотр) -->
  <div class="ar-pane" data-pane="0" id="home" style="display:none"></div>

  <f:form commandName="patient" action='/reg/doctor/index.s' method="post" name='bf' target="frm">
    <f:hidden path="id"/>
    <f:hidden path="surname"/>
    <f:hidden path="name"/>

    <!-- ================= Основные данные ================= -->
    <div class="ar-pane ar-card" data-pane="1">
      <div class="ar-card-b">
        <%@include file="/incs/msgs/errors.jsp"%>
        <div class="fg">
          <div class="ar-sec-t">Поступление</div>

          <div class="f s2"><label>Дата поступления <req>*</req></label>
            <input name="date_Begin" id="date_Begin" type="text" class="form-control datepicker" value="${date_Begin}"/></div>
          <div class="f s2"><label>Номер истории болезни <req>*</req></label>
            <f:input cssClass="form-control" maxlength="8" type="number" path="yearNum"/></div>
          <c:if test="${bioCount == 0}">
            <div class="f s2"><label>Анализ</label>
              <label class="ar-chk"><input name="glikoFlag" value="Y" type="checkbox"/> Отправить на «Гликогемоглобин»</label></div>
          </c:if>

          <div class="ar-sec-t">Диагноз</div>

          <div class="f s6">
            <div class="lbl">
              <label for="startDiagnoz">Диагноз при поступлении</label>
              <f:input type="hidden" path="mkb"/>
              <div class="btn-group">
                <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="#" onclick="fmsTpl.pick('pp_startDiagnoz', 'startDiagnoz'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                  <li><a href="#" onclick="fmsTpl.save('pp_startDiagnoz', 'startDiagnoz'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                </ul>
              </div>
            </div>
            <f:textarea path="startDiagnoz" cssClass="form-control" maxlength="4000"/>
          </div>
          <div class="f s3">
            <div class="lbl">
              <label for="sopustDBolez">Сопутствующие болезни</label>
              <div class="btn-group">
                <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="#" onclick="fmsTpl.pick('pp_sopustDBolez', 'sopustDBolez'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                  <li><a href="#" onclick="fmsTpl.save('pp_sopustDBolez', 'sopustDBolez'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                </ul>
              </div>
            </div>
            <f:textarea path="sopustDBolez" cssClass="form-control" maxlength="4000"/>
          </div>
          <div class="f s3">
            <div class="lbl">
              <label for="oslojn">Осложнение</label>
              <div class="btn-group">
                <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="#" onclick="fmsTpl.pick('pp_oslojn', 'oslojn'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                  <li><a href="#" onclick="fmsTpl.save('pp_oslojn', 'oslojn'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                </ul>
              </div>
            </div>
            <f:textarea path="oslojn" cssClass="form-control" maxlength="4000"/>
          </div>

          <div class="ar-sec-t">Схема сбора эпидемиологического анамнеза</div>

          <div class="f s6"><label for="no1" class="q">Имел(а) ли контакт с инфекционными больными (брюшным тифом, паратифами, др. сальмонеллёзами, дизентерией, прочими ОКИ,
              вирусными гепатитами, туберкулёзом, венерическими заболеваниями) по месту жительства или прописки, работы, учёбы на
              протяжении максимального срока инкубации для каждого заболевания?</label>
            <f:input path="no1" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/></div>
          <div class="f s6"><label for="no2" class="q">Выезжал(а) ли за пределы населённого пункта за неделю – 2 месяца до настоящего заболевания? Место пребывания и дата возвращения (с какого по какое время)</label>
            <f:input path="no2" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/></div>
          <div class="f s6"><label for="no3" class="q">Какие инфекционные заболевания перенёс(ла)?</label>
            <f:input path="no3" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/></div>
          <div class="f s6"><label for="no4" class="q">Находился(лась) ли на стационарном лечении, получал(а) ли гемотрансфузии (кровь и её компоненты), подвергался(лась) ли оперативным и массивным вмешательствам за последние 6 месяцев?</label>
            <f:input path="no4" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/></div>
        </div>
      </div>
    </div>

    <!-- ================= Дополнительные данные ================= -->
    <div class="ar-pane ar-card" data-pane="2" style="display:none">
      <div class="ar-card-b">
        <div class="fg">
          <div class="ar-sec-t">Жалобы и анамнез</div>

          <div class="f s3">
            <div class="lbl">
              <label for="jaloby">Жалобы</label>
              <div class="btn-group">
                <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="#" onclick="fmsTpl.pick('pp_jaloby', 'jaloby'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                  <li><a href="#" onclick="fmsTpl.save('pp_jaloby', 'jaloby'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                </ul>
              </div>
            </div>
            <f:textarea path="jaloby" rows="5" class="form-control" maxlength="1500"/>
          </div>
          <div class="f s3">
            <div class="lbl">
              <label for="anamnez">Анамнез</label>
              <div class="btn-group">
                <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="#" onclick="fmsTpl.pick('pp_anamnez', 'anamnez'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                  <li><a href="#" onclick="fmsTpl.save('pp_anamnez', 'anamnez'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                </ul>
              </div>
            </div>
            <f:textarea path="anamnez" rows="5" class="form-control" maxlength="1500"/>
          </div>

          <div class="ar-sec-t">Status praesens</div>

          <div class="f s2"><label>Общее состояние</label><f:input path="c1" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Сознание</label><f:input path="c2" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Положение</label><f:input path="c3" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="f s2"><label>Телосложение</label><f:input path="c4" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s4"><label>Кожные покровы</label><f:input path="c36" class="form-control" maxlength="200"/></div>

          <div class="f s2"><label>Клетчатка</label><f:input path="c5" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Костно-мышечная система</label><f:input path="c6" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Суставы</label><f:input path="c7" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="f s2"><label>Лимфатические узлы</label><f:input path="c8" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Аускультация лёгких</label><f:input path="c12" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Число дыхания</label><f:input path="c10" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="ar-sec-t">Сердечно-сосудистая система</div>

          <div class="f s3"><label>Аускультация сердца</label><f:input path="c17" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s3"><label>На аорте</label><f:input path="c18" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s6"><label>Шумы в сердце</label><f:input path="c37" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Пульс: частота</label><f:input path="c20" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Пульс: ритм</label><f:input path="c21" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Артериальное давление</label><f:input path="c25" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="ar-sec-t">Пищеварение и мочевыделение</div>

          <div class="f s2"><label>Язык</label><f:input path="c26" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Живот</label><f:input path="c27" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Печень</label><f:input path="c28" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="f s2"><label>Селезёнка</label><f:input path="c29" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Стул</label><f:input path="c30" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s2"><label>Мочеиспускание</label><f:input path="c31" class="form-control" maxlength="200" autocomplete="on"/></div>

          <div class="f s3"><label>Симптом Пастернацкого</label><f:input path="c33" class="form-control" maxlength="200" autocomplete="on"/></div>
          <div class="f s3"><label>Периферические отёки</label><f:input path="c34" class="form-control" maxlength="200" autocomplete="on"/></div>
        </div>
      </div>
    </div>
  </f:form>
</div>
