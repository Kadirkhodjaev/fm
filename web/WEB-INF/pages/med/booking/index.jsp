<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .bk { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; padding:16px 20px;
    color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .bk * { box-sizing:border-box; }
  .bk-card { flex:1; min-height:0; display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }

  /* ---------- Панель ---------- */
  .bk-bar { flex:none; display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid var(--border); flex-wrap:wrap; }
  .bk-bar h3 { margin:0 6px 0 0; font-size:17px; font-weight:700; display:flex; align-items:center; gap:9px; }
  .bk-bar h3 .ic { width:32px; height:32px; border-radius:9px; background:var(--bg); color:var(--muted); display:inline-flex; align-items:center; justify-content:center; font-size:15px; }
  .bk-bar .sp { flex:1; }
  .bk-chip { display:inline-flex; align-items:center; gap:6px; height:28px; padding:0 10px; border-radius:14px; background:#F1F2F4; color:var(--muted); font-size:12.5px; font-weight:600; white-space:nowrap; }
  .bk-chip b { color:var(--text); font-variant-numeric:tabular-nums; }
  .bk-chip.soon { background:#FEF3E2; color:#B45309; }
  .bk-chip.soon b { color:#B45309; }
  .bk .in { height:36px; padding:0 10px; border:1px solid var(--border); border-radius:9px; font-size:14px; font-family:inherit; color:var(--text);
    background-color:#fff; outline:none; box-shadow:none; transition:border-color .15s, box-shadow .15s; }
  .bk .in:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .bk-search { position:relative; }
  .bk-search i { position:absolute; left:11px; top:50%; transform:translateY(-50%); color:#9AA1AC; font-size:13px; }
  .bk-search .in { width:240px; padding-left:32px; }
  .bk .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border);
    background:#fff; color:var(--text); font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .bk .ab:hover { background:var(--bg); }
  .bk .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .bk .ab.primary:hover { background:#A50F22; border-color:#A50F22; }

  /* ---------- Таблица ---------- */
  .bk-scroll { flex:1; min-height:0; overflow:auto; }
  .bk-t { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .bk-t th { position:sticky; top:0; z-index:1; padding:10px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted);
    font-size:11.5px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .bk-t td { padding:9px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .bk-t th.c, .bk-t td.c { text-align:center; }
  .bk-t tbody tr.it { cursor:pointer; }
  .bk-t tbody tr.it:hover td { background:#F7F8FA; }
  .bk-t tbody tr.soon td:first-child { box-shadow:inset 3px 0 0 #D97706; }
  .bk-t td.num { color:#9AA1AC; width:44px; }
  .bk-t td.muted { color:var(--muted); white-space:nowrap; }
  .bk-who { display:flex; align-items:center; gap:11px; min-width:220px; }
  .bk-who .fio { font-weight:600; color:var(--text); text-decoration:none; }
  .bk-who .fio:hover { text-decoration:underline; }
  .bk-av { flex:none; width:34px; height:34px; border-radius:50%; display:flex; align-items:center; justify-content:center;
    font-size:12.5px; font-weight:700; text-transform:uppercase; }
  .bk-av.a0 { background:#EAF1FE; color:#2563EB; } .bk-av.a1 { background:#E8F7EE; color:#15803D; } .bk-av.a2 { background:#FEF3E2; color:#B45309; }
  .bk-av.a3 { background:#F3EEFE; color:#7C3AED; } .bk-av.a4 { background:#E6F6FA; color:#0E7490; } .bk-av.a5 { background:#FDEDF3; color:#BE185D; }
  .bk-room { display:inline-flex; flex-direction:column; gap:2px; }
  .bk-room .d { font-weight:600; font-size:13px; }
  .bk-room .r { font-size:12.5px; color:var(--muted); }
  .bk-beds { display:inline-flex; align-items:center; justify-content:center; min-width:28px; height:24px; padding:0 8px; border-radius:12px; background:#F1F2F4; color:#4B5563; font-size:13px; font-weight:700; font-variant-numeric:tabular-nums; }
  .bk-beds.many { background:#FEF3E2; color:#B45309; }
  .bk-ux { display:block; margin-top:2px; font-size:11px; color:#9AA1AC; white-space:nowrap; }
  .bk-t .bd { display:inline-block; padding:2px 9px; border-radius:10px; font-size:12px; font-weight:600; background:#EAF1FE; color:#2563EB; }
  .bk-t .grp td { padding:8px 12px; background:#FCFCFD; border-bottom:1px solid var(--border);
    font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.3px; color:var(--muted); cursor:default; }
  .bk-t .grp.soon td { background:#FFFAF2; color:#B45309; }
  .bk-t .grp .n { margin-left:6px; font-weight:600; opacity:.75; }
  .bk-del { width:30px; height:30px; border:0; border-radius:8px; background:none; color:#9AA1AC; cursor:pointer; font-size:14px; }
  .bk-del:hover { background:#FDECEE; color:var(--brand); }
  .bk-del.bk-arch:hover { background:#F1F2F4; color:var(--text); }
  .bk-empty td { padding:48px 12px; text-align:center; color:#9AA1AC; cursor:default; }
  .bk-empty .fa { display:block; font-size:28px; margin-bottom:10px; color:#C3C7CE; }
  .bk-msg:empty { display:none; }
  .bk-msg { padding:10px 16px 0; }

  /* ---------- Модалка ---------- */
  .bk-modal .modal-dialog { width:100%; max-width:820px; }
  .bk-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .bk-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .bk-modal .modal-title { font-size:17px; font-weight:700; }
  .bk-modal .modal-title .fa { color:#6B7280; margin-right:6px; }
  .bk-modal .modal-body { padding:18px 20px 20px; }
  .bk-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; align-items:center; justify-content:flex-end; gap:8px; }
  .bk-modal .modal-footer .author { flex:1; text-align:left; font-size:12.5px; color:#9AA1AC; }
  .bk-modal .modal-footer .author:empty { display:none; }
  .bk-modal .sec { margin:0 0 8px; font-size:11.5px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:#9AA1AC; }
  .bk-modal .sec + .fg { margin-bottom:18px; }
  .bk-modal .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:12px 14px; }
  .bk-modal .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .bk-modal .fg .s2 { grid-column:span 2; } .bk-modal .fg .s3 { grid-column:span 3; } .bk-modal .fg .s6 { grid-column:span 6; }
  .bk-modal .fg label { margin:0; font-size:12.5px; font-weight:600; color:#6B7280; }
  .bk-modal .fg label i { font-style:normal; color:#D7182E; }
  .bk-modal .form-control { height:38px; border:1px solid #E6E8EC; border-radius:9px; box-shadow:none; font-size:14px; color:#1F2430; background-color:#fff; }
  .bk-modal .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .bk-modal .form-control.up { text-transform:uppercase; }
  .bk-modal .form-control.fms-cal { min-width:160px; }
  .bk-modal .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid #E6E8EC;
    background:#fff; color:#1F2430; font-size:13.5px; font-weight:600; cursor:pointer; }
  .bk-modal .ab:hover { background:#F5F6F8; }
  .bk-modal .ab.primary { background:#D7182E; border-color:#D7182E; color:#fff; }
  .bk-modal .ab.primary:hover { background:#A50F22; border-color:#A50F22; }
  @media (max-width: 700px) { .bk-modal .fg .s2, .bk-modal .fg .s3 { grid-column:span 6; } }
</style>

<div class="bk" id="bookingList">
  <div class="bk-card">
    <div class="bk-bar">
      <h3><span class="ic"><i class="fa fa-h-square"></i></span>Бронирование койки</h3>
      <c:if test="${fn:length(others) > 0}">
        <span class="bk-chip soon" title="Дата регистрации в ближайшие 5 дней"><i class="fa fa-clock-o"></i> Скоро <b>${fn:length(others)}</b></span>
      </c:if>
      <span class="bk-chip">Всего <b>${fn:length(others) + fn:length(list)}</b></span>
      <span class="sp"></span>
      <div class="bk-search">
        <i class="fa fa-search"></i>
        <input type="text" class="in" placeholder="Поиск..." id="filter_box" value="${filter == null ? '' : filter}">
      </div>
      <button type="button" class="ab" onclick="setFilter()">Найти</button>
      <button type="button" class="ab primary" onclick="addBooking()"><i class="fa fa-plus"></i> Добавить</button>
    </div>

    <div class="bk-msg"><%@include file="/incs/msgs/successError.jsp"%></div>

    <div class="bk-scroll">
      <table class="bk-t">
        <thead>
        <tr>
          <th style="width:44px">№</th>
          <th>ФИО</th>
          <th class="c" style="width:110px">Год рожд.</th>
          <th class="c" style="width:120px">Дата рег.</th>
          <th style="width:240px">Отд. / Палата</th>
          <th class="c" style="width:110px" title="Сколько коек занимает бронь, включая ухаживающего">Коек</th>
          <th>Лечащий врач</th>
          <th class="c" style="width:110px">Состояние</th>
          <th class="c" style="width:90px"></th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${fn:length(others) > 0}">
          <tr class="grp soon"><td colspan="9"><i class="fa fa-clock-o"></i> Срок приближается (+5 дней)<span class="n">${fn:length(others)}</span></td></tr>
        </c:if>
        <c:forEach items="${others}" var="obj" varStatus="loop">
          <tr class="it soon" onclick="editBooking(${obj.id})">
            <td class="num">${loop.index + 1}</td>
            <td>
              <div class="bk-who">
                <span class="bk-av a${obj.id % 6}">${fn:substring(obj.surname, 0, 1)}${fn:substring(obj.name, 0, 1)}</span>
                <a href="#" class="fio" onclick="return false">${obj.surname} ${obj.name} ${obj.middlename}</a>
              </div>
            </td>
            <td class="c muted">${obj.birthyear}</td>
            <td class="c muted"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" /></td>
            <td><span class="bk-room"><span class="d">${obj.dept.name}</span><span class="r">${obj.room.name} - ${obj.room.roomType.name}</span></span></td>
            <c:set var="bc" value="${obj.bedCount != null && obj.bedCount > 0 ? obj.bedCount : 1}"/>
            <td class="c"><span class="bk-beds<c:if test="${bc > 1 || obj.bron != null}"> many</c:if>" title="Коек: ${bc}<c:if test="${obj.bron != null}"> + 1 (${obj.bron.name})</c:if>">${bc + (obj.bron != null ? 1 : 0)}</span><c:if test="${obj.bron != null}"><span class="bk-ux">вкл. ${fn:toLowerCase(obj.bron.name)}</span></c:if></td>
            <td class="muted">${obj.lv.fio}</td>
            <td class="c"><c:if test="${obj.state == 'ENT'}"><span class="bd">Введен</span></c:if></td>
            <td class="c" style="white-space:nowrap"><button type="button" class="bk-del bk-arch" title="В архив" onclick="event.stopPropagation(); archiveBooking(${obj.id})"><i class="fa fa-archive"></i></button><button type="button" class="bk-del" title="Удалить" onclick="event.stopPropagation(); removeBooking(${obj.id})"><i class="fa fa-trash-o"></i></button></td>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(others) > 0}">
          <tr class="grp"><td colspan="9">Остальные<span class="n">${fn:length(list)}</span></td></tr>
        </c:if>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr class="it" onclick="editBooking(${obj.id})">
            <td class="num">${loop.index + 1}</td>
            <td>
              <div class="bk-who">
                <span class="bk-av a${obj.id % 6}">${fn:substring(obj.surname, 0, 1)}${fn:substring(obj.name, 0, 1)}</span>
                <a href="#" class="fio" onclick="return false">${obj.surname} ${obj.name} ${obj.middlename}</a>
              </div>
            </td>
            <td class="c muted">${obj.birthyear}</td>
            <td class="c muted"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" /></td>
            <td><span class="bk-room"><span class="d">${obj.dept.name}</span><span class="r">${obj.room.name} - ${obj.room.roomType.name}</span></span></td>
            <c:set var="bc" value="${obj.bedCount != null && obj.bedCount > 0 ? obj.bedCount : 1}"/>
            <td class="c"><span class="bk-beds<c:if test="${bc > 1 || obj.bron != null}"> many</c:if>" title="Коек: ${bc}<c:if test="${obj.bron != null}"> + 1 (${obj.bron.name})</c:if>">${bc + (obj.bron != null ? 1 : 0)}</span><c:if test="${obj.bron != null}"><span class="bk-ux">вкл. ${fn:toLowerCase(obj.bron.name)}</span></c:if></td>
            <td class="muted">${obj.lv.fio}</td>
            <td class="c"><c:if test="${obj.state == 'ENT'}"><span class="bd">Введен</span></c:if></td>
            <td class="c" style="white-space:nowrap"><button type="button" class="bk-del bk-arch" title="В архив" onclick="event.stopPropagation(); archiveBooking(${obj.id})"><i class="fa fa-archive"></i></button><button type="button" class="bk-del" title="Удалить" onclick="event.stopPropagation(); removeBooking(${obj.id})"><i class="fa fa-trash-o"></i></button></td>
          </tr>
        </c:forEach>
        <c:if test="${empty others && empty list}">
          <tr class="bk-empty"><td colspan="9"><i class="fa fa-h-square"></i>Броней нет<c:if test="${not empty filter}"> по запросу «${filter}»</c:if></td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- AddEdit Form -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade bk-modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-h-square"></i> Пациент маълумотлари</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="history" value="" />

          <div class="sec">Пациент</div>
          <div class="fg">
            <div class="f s2">
              <label>Фамилия <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="Фамилия" class="form-control up" name="surname" value="" required/>
            </div>
            <div class="f s2">
              <label>Исм <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="Исм" class="form-control up" name="name" value="" required/>
            </div>
            <div class="f s2">
              <label>Шариф</label>
              <input type="text" autocomplete="off" placeholder="Шариф" class="form-control up" name="middlename" value=""/>
            </div>
            <div class="f s2">
              <label>Тугилган йили <i>*</i></label>
              <input type="number" autocomplete="off" placeholder="xxxx" class="form-control center" name="birthyear" value="" required/>
            </div>
            <div class="f s2">
              <label>Жинси <i>*</i></label>
              <select name="sex" class="form-control" required>
                <c:forEach items="${sex}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Резидентлиги <i>*</i></label>
              <select name="country" class="form-control" required>
                <c:forEach items="${countries}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s3">
              <label>Телефон <i>*</i></label>
              <input type="text" autocomplete="off" class="form-control" name="tel" value="" required/>
            </div>
            <div class="f s3">
              <label>Паспорт маълумотлари</label>
              <input type="text" autocomplete="off" class="form-control" name="passport" value=""/>
            </div>
          </div>

          <div class="sec">Бронь</div>
          <div class="fg">
            <div class="f s2">
              <label>Дата рег <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="дд.мм.гггг" class="form-control fms-cal" id="date_begin" name="date_begin" value="" required/>
            </div>
            <div class="f s2">
              <label>Булим <i>*</i></label>
              <select name="dept" class="form-control" required>
                <c:forEach items="${depts}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>№ хона <i>*</i></label>
              <select name="room" class="form-control" required>
                <c:forEach items="${rooms}" var="ss">
                  <option value="${ss.id}">${ss.name} - ${ss.roomType.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Кол-во коек <i>*</i></label>
              <input type="number" min="1" max="20" autocomplete="off" class="form-control" name="bed_count" value="1" required/>
            </div>
            <div class="f s2">
              <label>Шифокор</label>
              <select name="lv" class="form-control">
                <option></option>
                <c:forEach items="${lvs}" var="ss">
                  <option value="${ss.id}">${ss.profil} - ${ss.fio}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label title="Бронь или ухаживающий рядом с пациентом: +1 койка">Бронь</label>
              <select name="bron" class="form-control" title="Бронь или ухаживающий рядом с пациентом: +1 койка">
                <option value="0">Нет</option>
                <c:forEach items="${watcherTypes}" var="type">
                  <option value="${type.id}">${type.name} (+1 койка)</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <span class="author" id="row_author"></span>
        <button type="button" class="ab" id="archive-btn" style="display:none" onclick="archiveBooking($('#addEditForm input[name=id]').val())"><i class="fa fa-archive"></i> В архив</button>
        <button type="button" class="ab" id="close-modal" data-dismiss="modal">Закрыть</button>
        <button type="button" class="ab primary" onclick="saveBooking()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  <c:if test="${history > 0}">
  addBooking();
  </c:if>
  function setFilter() {
    var word = document.getElementById("filter_box");
    setPage('/booking/index.s?word=' + encodeURIComponent(word.value));
  }
  function addBooking(){
    addEditForm.reset();
    $('#row_author').html('');
    $('#archive-btn').hide();
    <c:if test="${history > 0}">
    $.ajax({
      url: '/booking/get.s',
      method: 'post',
      data: 'history=${history}',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          document.getElementById("modal_window").click();
          var data = res.data;
          for (var e in data) {
            try {
              document.getElementsByName(e)[0].value = data[e];
            } catch (e) {}
          }
        } else {
          openMedMsg(res.msg, false);
        }
      }
    });
    </c:if>
    <c:if test="${history == 0}">
    document.getElementById("modal_window").click();
    </c:if>
  }
  function editBooking(id) {
    $.ajax({
      url: '/booking/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          document.getElementById("modal_window").click();
          var data = res.data;
          for (var e in data) {
            try {
              document.getElementsByName(e)[0].value = data[e];
            } catch (e) {}
          }
          $('#row_author').html(data.author ? 'Автор: ' + data.author : '');
          $('#archive-btn').toggle(data.id > 0);
        } else {
          openMedMsg(res.msg, false);
        }
      }
    });
  }
  // закрыть окно брони и только потом перезагрузить страницу (иначе остаётся тёмный фон окна)
  function closeModalThen(url) {
    var m = $('#myModal');
    var go = function () {
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open').css('padding-right', '');
      setPage(url);
    };
    if (m.hasClass('in')) m.one('hidden.bs.modal', go).modal('hide'); else go();
  }
  function archiveBooking(id) {
    if (!id) return;
    FmsConfirm('Перенести бронь в архив? Она пропадёт из списка и из расчёта коек.', function () {
    $.ajax({
      url: '/booking/archive.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          openMedMsg('Бронь перенесена в архив', true);
          closeModalThen('/booking/index.s');
        } else {
          openMedMsg(res.msg, false);
        }
      }
    });
  });
  }
  function removeBooking(id){
    FmsConfirm('Действительно хотите удалить бронь?', function () {
    $.ajax({
      url: '/booking/remove.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          openMedMsg("<ui:message code="successSave"/>", true);
          setPage('/booking/index.s');
        } else {
          openMedMsg(res.msg, false);
        }
      }
    });
  });
  }
  function saveBooking() {
    if (checkForm($('#addEditForm'))) {
      $.ajax({
        url: '/booking/save.s',
        method: 'post',
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            openMedMsg("<ui:message code="successSave"/>", true);
            closeModalThen('/booking/index.s');
          } else {
            openMedMsg(res.msg, false);
          }
        }
      });
    }
  }

  function delBooking(id) {
    FmsConfirm('Дейтвительно хотите удалить?', function () {
      $.ajax({
        url: '/drugs/dict/delete.s',
        method: 'post',
        data: 'code=category&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/drugs/dicts.s');
          } else {
            openMedMsg(res.msg, false);
          }
        }
      });
    });
  }

  (function () {
    // Enter в поиске запускает поиск
    var box = document.getElementById('filter_box');
    if (box) box.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); setFilter(); } });

    // Bootstrap-модалка забирает фокус у элементов вне себя — тогда в календаре не открываются списки месяца и года
    $('#myModal').on('shown.bs.modal', function () { $(document).off('focusin.bs.modal'); });

    // Высота по окну: если обёртка не задаёт высоту, прокручивается только таблица
    var page = document.getElementById('bookingList');
    function fit() {
      if (!page) return;
      page.style.height = '';
      var avail = window.innerHeight - page.getBoundingClientRect().top - 8;
      if (avail > 300 && page.offsetHeight > avail) page.style.height = avail + 'px';
    }
    fit(); window.addEventListener('resize', fit);
  })();
</script>
