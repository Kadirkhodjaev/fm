<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Пользователи → карточка пользователя --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .uc-wrap { display:grid; grid-template-columns:minmax(380px, 1fr) minmax(380px, 1fr); gap:12px; padding:12px; background:#F7F8FA; align-items:start; }
  .uc-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; padding:14px 16px; display:flex; flex-direction:column; gap:12px; }
  .uc-card + .uc-card { margin-top:12px; }
  .uc-h { display:flex; align-items:center; gap:8px; font-weight:700; font-size:14px; color:#1F2430; }
  .uc-h .fa { color:#6B7280; width:16px; text-align:center; }
  .uc-h small { font-weight:500; color:#9AA0AB; font-size:12px; }
  .uc-h .fm-spacer { flex:1; }
  .uc-2 { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
  .uc-num { text-align:right; font-variant-numeric:tabular-nums; }
  .uc-ips { display:flex; flex-wrap:wrap; gap:8px; }
  .uc-ip { display:inline-flex; align-items:center; border:1px solid #E6E8EC; border-radius:9px; background:#fff; overflow:hidden; }
  .uc-ip input { width:130px; height:30px; border:0; padding:0 8px; font-size:13px; font-family:inherit; text-align:center; outline:none; }
  .uc-ip button { height:30px; width:28px; border:0; border-left:1px solid #F0F1F4; background:none; color:#9AA0AB; cursor:pointer; }
  .uc-ip button:hover { color:#A50F22; background:#FDECEE; }
  .uc-hint { color:#9AA0AB; font-size:12px; }
  .uc-dis { opacity:.45; pointer-events:none; }
  .uc-title { cursor:default; user-select:none; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title uc-title" ondblclick="ucAuth()">
        <span class="ic"><i class="fa fa-user"></i></span>
        <div>
          <h2>${user.id == null ? 'Новый пользователь' : fn:escapeXml(user.fio)}</h2>
          <span class="fm-count"><c:choose><c:when test="${user.id == null}">карточка пользователя</c:when><c:otherwise>ID <b>${user.id}</b> · ${fn:escapeXml(user.login)}<c:if test="${!user.active}"> · отключён</c:if></c:otherwise></c:choose></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <c:if test="${user.id != null}">
        <button type="button" class="fm-btn" onclick="ucRoles()"><i class="fa fa-list"></i>Роли и отчёты</button>
      </c:if>
      <button type="button" class="fm-btn primary" id="ucSaveBtn" onclick="ucSave()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="setPage('/core/user/list.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <form id="ucForm" onsubmit="ucSave(); return false" autocomplete="off">
        <input type="hidden" name="id" value="${user.id}"/>
        <div class="uc-wrap">
          <div>
            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-user"></i>Учётная запись</div>
              <div class="fm-err" id="ucErr"></div>
              <div class="uc-2">
                <div>
                  <label class="fm-l">Логин *</label>
                  <input name="login" value="${fn:escapeXml(user.login)}" class="fm-in" type="text" autocomplete="off"/>
                </div>
                <div class="fm-state" style="align-self:end; justify-self:start">
                  <label><input type="radio" class="a" name="active" value="1" <c:if test="${user.id == null || user.active}">checked</c:if>/><span>Активный</span></label>
                  <label><input type="radio" class="p" name="active" value="0" <c:if test="${user.id != null && !user.active}">checked</c:if>/><span>Отключён</span></label>
                </div>
              </div>
              <div class="uc-2">
                <div>
                  <label class="fm-l">Пароль<c:if test="${user.id == null}"> *</c:if></label>
                  <input name="password" class="fm-in" type="password" autocomplete="new-password" placeholder="${user.id == null ? '' : 'не менять'}"/>
                </div>
                <div>
                  <label class="fm-l">Подтверждение пароля<c:if test="${user.id == null}"> *</c:if></label>
                  <input name="confirm_password" class="fm-in" type="password" autocomplete="new-password"/>
                </div>
              </div>
              <div>
                <label class="fm-l">ФИО *</label>
                <input name="fio" value="${fn:escapeXml(user.fio)}" class="fm-in" type="text" autocomplete="off"/>
              </div>
              <div class="uc-2">
                <div>
                  <label class="fm-l">Отделение</label>
                  <select name="dep" class="fm-in">
                    <option value="">Не выбрано</option>
                    <c:forEach items="${deptList}" var="dep">
                      <option value="${dep.id}" <c:if test="${dep.id == user.dept.id}">selected</c:if>>${dep.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div>
                  <label class="fm-l">Профиль</label>
                  <input name="profil" value="${fn:escapeXml(user.profil)}" class="fm-in" type="text" maxlength="64" autocomplete="off"/>
                </div>
              </div>
            </div>

            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-money"></i>Стоимость консультации</div>
              <div class="uc-2">
                <div><label class="fm-l">Резиденты</label><input name="consul_price" value="${user.consul_price}" class="fm-in uc-num" type="text" inputmode="decimal"/></div>
                <div><label class="fm-l">Нерезиденты</label><input name="for_consul_price" value="${user.for_consul_price}" class="fm-in uc-num" type="text" inputmode="decimal"/></div>
                <div><label class="fm-l">Реальная (резиденты)</label><input name="real_consul_price" value="${user.real_consul_price}" class="fm-in uc-num" type="text" inputmode="decimal"/></div>
                <div><label class="fm-l">Реальная (нерезиденты)</label><input name="for_real_consul_price" value="${user.for_real_consul_price}" class="fm-in uc-num" type="text" inputmode="decimal"/></div>
              </div>
            </div>

            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-globe"></i>IP адреса <small>вход только с этих адресов; пусто - с любого</small><span class="fm-spacer"></span>
                <button type="button" class="fm-btn" onclick="ucAddIp('')"><i class="fa fa-plus"></i>Добавить</button>
              </div>
              <div class="uc-ips" id="ucIps">
                <c:forEach items="${ips}" var="ip">
                  <span class="uc-ip"><input type="text" name="ip" maxlength="15" value="${fn:escapeXml(ip.ip)}"/><button type="button" onclick="$(this).parent().remove()" title="Убрать"><i class="fa fa-times"></i></button></span>
                </c:forEach>
              </div>
            </div>
          </div>

          <div>
            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-stethoscope"></i>Врач</div>
              <div class="fm-tgls">
                <label class="fm-tgl"><input type="checkbox" name="lv" value="1" <c:if test="${user.lv}">checked</c:if>/><span>Лечащий врач</span></label>
                <label class="fm-tgl"><input type="checkbox" name="zavlv" value="1" <c:if test="${user.zavlv}">checked</c:if>/><span>Заведующий отделом</span></label>
                <label class="fm-tgl"><input type="checkbox" name="consul" value="1" <c:if test="${user.consul}">checked</c:if>/><span>Консультация</span></label>
                <label class="fm-tgl"><input type="checkbox" name="amb_treatment" value="1" <c:if test="${user.ambTreatment}">checked</c:if>/><span>Амбулаторное лечение</span></label>
                <label class="fm-tgl"><input type="checkbox" name="docfizio" value="1" <c:if test="${user.docfizio}">checked</c:if>/><span>Врач физиотерапевт</span></label>
                <label class="fm-tgl"><input type="checkbox" name="needleDoc" value="1" <c:if test="${user.needleDoc}">checked</c:if>/><span>Врач иглотерапии</span></label>
                <label class="fm-tgl"><input type="checkbox" name="ambFizio" value="1" <c:if test="${user.ambFizio}">checked</c:if>/><span>Амб. физиотерапевт</span></label>
                <label class="fm-tgl"><input type="checkbox" name="ambAdmin" value="1" <c:if test="${user.ambAdmin}">checked</c:if>/><span>Админ амбулатории</span></label>
                <label class="fm-tgl"><input type="checkbox" name="procUser" value="1" <c:if test="${user.procUser}">checked</c:if>/><span>Процедурный пользователь</span></label>
                <label class="fm-tgl"><input type="checkbox" name="mainNurse" value="1" <c:if test="${user.mainNurse}">checked</c:if>/><span>Старшая медсестра</span></label>
              </div>
            </div>

            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-star"></i>Руководство <small>у каждой должности один пользователь: прежний снимается</small></div>
              <div class="fm-tgls">
                <label class="fm-tgl"><input type="checkbox" name="boss" value="1" <c:if test="${user.boss}">checked</c:if>/><span>Директор</span></label>
                <label class="fm-tgl"><input type="checkbox" name="glb" value="1" <c:if test="${user.glb}">checked</c:if>/><span>Главный врач</span></label>
                <label class="fm-tgl"><input type="checkbox" name="glavbuh" value="1" <c:if test="${user.glavbuh}">checked</c:if>/><span>Главный бухгалтер</span></label>
              </div>
            </div>

            <div class="uc-card">
              <div class="uc-h"><i class="fa fa-cubes"></i>Склад и аптека</div>
              <div class="fm-tgls">
                <label class="fm-tgl"><input type="checkbox" name="statExp" value="1" <c:if test="${user.statExp}">checked</c:if>/><span>Расход по стационару</span></label>
                <label class="fm-tgl"><input type="checkbox" name="drugDirection" id="ucDir" value="1" onchange="ucDir()" <c:if test="${user.drugDirection}">checked</c:if>/><span>Заявитель для аптеки</span></label>
              </div>
              <div class="fm-sec">Склады заявителя</div>
              <div class="fm-tgls" id="ucStores">
                <c:forEach items="${directions}" var="d">
                  <label class="fm-tgl"><input type="checkbox" name="storage" value="${d.c1}" <c:if test="${d.c3 > 0}">checked</c:if>/><span>${d.c2}</span></label>
                </c:forEach>
              </div>
              <div class="uc-hint" id="ucStoresHint">Склады выбираются, когда включено «Заявитель для аптеки»</div>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<div id="ucRolesBox"></div>
<script>
  (function () {
    function raw(v) { return String(v == null ? '' : v).replace(/[\s ]/g, '').replace(',', '.'); }
    function fmt(v) {
      v = raw(v);
      if (v === '' || isNaN(v)) return v;
      var p = v.split('.'), d = p[1] && /[1-9]/.test(p[1]) ? '.' + p[1].replace(/0+$/, '') : '';
      return p[0].replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + d;
    }
    var f = document.getElementById('ucForm');
    window.ucDir = function (init) {
      var on = document.getElementById('ucDir').checked;
      if (!on && init !== true) $('#ucStores input').prop('checked', false);
      $('#ucStores').toggleClass('uc-dis', !on);
      $('#ucStoresHint').toggle(!on);
    };
    window.ucAddIp = function (v) {
      var s = $('<span class="uc-ip"><input type="text" name="ip" maxlength="15"/><button type="button" title="Убрать"><i class="fa fa-times"></i></button></span>');
      s.find('input').val(v);
      s.find('button').on('click', function () { s.remove(); });
      $('#ucIps').append(s);
      s.find('input').focus();
    };
    window.ucSave = function () {
      var err = '';
      if (!$.trim(f.elements['login'].value)) err = 'Укажите логин';
      else if (!$.trim(f.elements['fio'].value)) err = 'Укажите ФИО';
      else if (!f.elements['id'].value && !f.elements['password'].value) err = 'Укажите пароль';
      else if (f.elements['password'].value !== f.elements['confirm_password'].value) err = 'Пароль и подтверждение не совпадают';
      $('#ucIps input').each(function () {
        var v = $.trim(this.value);
        if (!err && v && !/^[0-9.:]+$/.test(v)) err = 'Неверный IP адрес: ' + v;
      });
      $('.uc-num').each(function () {
        var v = raw(this.value);
        if (!err && v !== '' && (isNaN(v) || Number(v) < 0)) err = 'Неверная стоимость консультации';
      });
      if (err) { DK.err('uc', err); $('#ucErr')[0].scrollIntoView({block: 'nearest'}); return; }
      $('#ucErr').hide();
      // сервер считает флаг включённым, если параметр есть: «Отключён» не отправляется
      var data = $(f).serializeArray().filter(function (o) { return !(o.name == "active" && o.value == "0"); }).map(function (o) {
        var v = $('[name=' + o.name + ']').hasClass('uc-num') ? raw(o.value) : o.value;
        return encodeURIComponent(o.name) + '=' + encodeURIComponent(v);
      }).join('&');
      $('#ucSaveBtn').prop('disabled', true);
      $.ajax({
        url: '/core/user/save.s', method: 'post', data: data, dataType: 'json',
        success: function (res) {
          if (res.success) { openMsg(res); if (!f.elements['id'].value) setPage('/core/user/list.s'); else { f.elements['password'].value = ''; f.elements['confirm_password'].value = ''; } }
          else { DK.err('uc', res.msg); $('#ucErr')[0].scrollIntoView({block: 'nearest'}); }
        },
        complete: function () { $('#ucSaveBtn').prop('disabled', false); }
      });
    };
    window.ucRoles = function () { $('#ucRolesBox').load('/core/user/roles.s?id=' + f.elements['id'].value); };
    window.ucAuth = function () {
      if (!f.elements['id'].value) return;
      $.ajax({url: 'user_login.s', method: 'post', data: 'session_user_id=' + f.elements['id'].value, dataType: 'json', complete: function () { document.location = 'main.s'; }});
    };
    $('.uc-num').each(function () { this.value = fmt(this.value); }).on('blur', function () { this.value = fmt(this.value); });
    ucDir(true);
  })();
</script>
