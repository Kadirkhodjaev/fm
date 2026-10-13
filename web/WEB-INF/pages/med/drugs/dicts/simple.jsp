<%@ page pageEncoding="UTF-8" %>
<%-- Простой справочник аптеки (название + состояние). Перед include: dkCode (код для /drugs/dict/*.s), dkPage (вкладка),
     dkTitle, dkOne (как называется запись), dkIcon, dkIncome = Y - флажок «Для прихода» (ед. измерения) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa ${dkIcon}"></i></span>
        <div>
          <h2>${dkTitle}</h2>
          <span class="fm-count"><b id="skShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="skSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('sk', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('sk', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('sk', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="skSearch" placeholder="Название или ID" oninput="DK.filter('sk')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="skEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <c:if test="${dkIncome == 'Y'}"><th style="width:130px" class="c">Для прихода</th></c:if>
          <th style="width:130px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="skRows">
        <c:forEach items="${list}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)}" data-name="${fn:escapeXml(obj.name)}" onclick="skEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <c:if test="${dkIncome == 'Y'}"><td class="c">${obj.incomeFlag ? '<span class="dk-yes">Да</span>' : '<span class="dk-no">—</span>'}</td></c:if>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('${dkCode}', ${obj.id}, $(this).closest('tr').attr('data-name'), '${dkPage}')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="skEmpty" style="display:none"><i class="fa ${dkIcon}"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="skModal" onclick="if (event.target === this) DK.close('sk')">
  <div class="fm-modal" style="width:460px">
    <div class="fm-modal-head">
      <h3 id="skTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('sk')"><i class="fa fa-times"></i></button>
    </div>
    <form id="skForm" onsubmit="skSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="${dkCode}"/>
        <div class="fm-err" id="skErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" maxlength="255" autocomplete="off"/>
        </div>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px">
          <div class="fm-state">
            <label><input type="radio" class="a" name="state" value="Y" checked/><span>Активный</span></label>
            <label><input type="radio" class="p" name="state" value=""/><span>Пассивный</span></label>
          </div>
          <c:if test="${dkIncome == 'Y'}">
            <label class="fm-tgl"><input type="checkbox" name="income" value="Y"/><span>Для прихода</span></label>
          </c:if>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('sk')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.base = '${empty dkBase ? "/drugs/dict" : dkBase}';
  DK.filter('sk');
  function skEdit(id) {
    var f = document.getElementById('skForm');
    f.reset();
    f.elements['id'].value = '';
    DK.open('sk', id ? 'Изменить: ${dkOne}' : 'Новая запись: ${dkOne}');
    f.elements['name'].focus();
    if (!id) return;
    DK.get('sk', '${dkCode}', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      DK.setState(f, res.state == 'A');
      if (f.elements['income']) f.elements['income'].checked = !!res.income;
    });
  }
  function skSave() {
    var f = document.getElementById('skForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('sk', 'Укажите наименование'); return; }
    DK.save('sk', f, '${dkPage}');
  }
</script>
