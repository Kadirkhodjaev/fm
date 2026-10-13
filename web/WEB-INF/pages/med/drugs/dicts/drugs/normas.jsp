<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Аптека → Справочники → Нормативы: нормы выдачи препаратов (для всех складов или по складам) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .nm-in { width:90px; height:28px; padding:0 8px; border:1px solid transparent; border-radius:7px; background:#F8F9FB; text-align:right; font:inherit; }
  .nm-in:hover { border-color:#E6E8EC; background:#fff; }
  .nm-in:focus { outline:none; border-color:#4B5563; background:#fff; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .nm-in.saved { border-color:#9ED9B8; background:#F1FAF5; }
  .nm-type { display:inline-block; padding:0 7px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:18px; background:#EEF1F6; color:#3C4A63; }
  .nm-type.multi { background:#F3EEFB; color:#6B3FA0; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-sliders"></i></span>
        <div>
          <h2>Нормативы</h2>
          <span class="fm-count"><b id="nmShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · значения сохраняются сразу</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="nmSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('nm', this)">Все</button>
        <button type="button" data-f="ALL" onclick="DK.seg('nm', this)">Для всех</button>
        <button type="button" data-f="MULTI" onclick="DK.seg('nm', this)">По складам</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="nmSearch" placeholder="Препарат" oninput="DK.filter('nm')" autocomplete="off"/>
      </div>
      <select class="fm-in fms-select" id="drug_id" style="width:280px">
        <option value="">Новый норматив: выберите препарат</option>
        <c:forEach items="${drugs}" var="cc">
          <option value="${cc.id}">${cc.name}</option>
        </c:forEach>
      </select>
      <button type="button" class="fm-btn primary" onclick="addNorma()"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th>Препарат</th>
          <th style="width:120px">Тип</th>
          <th style="width:110px" class="r">Норма</th>
          <th style="width:120px" class="r">Таб. в пласт.</th>
          <th style="width:110px" class="r">Мин. кол-во</th>
          <th style="width:110px" class="r">Макс. кол-во</th>
          <th style="width:90px"></th>
        </tr>
        </thead>
        <tbody id="nmRows">
        <c:forEach items="${rows}" var="r">
          <tr data-f="${r.normaType}" data-s="${r.drug.id} ${fn:escapeXml(r.drug.name)}" data-name="${fn:escapeXml(r.drug.name)}" ondblclick="nmOpen(${r.drug.id})">
            <td class="mut"><b>${r.id}</b></td>
            <td><span class="nm">${r.drug.name}</span> <span class="mut" style="color:#9AA1AC">#${r.drug.id}</span></td>
            <td><span class="nm-type ${r.normaType == 'MULTI' ? 'multi' : ''}">${r.normaType == 'MULTI' ? 'По складам' : 'Для всех'}</span></td>
            <td class="r"><c:if test="${r.normaType == 'ALL'}"><input type="number" class="nm-in" value="${r.norma}" onchange="setNormaValue(${r.id}, this, 'norma')"/></c:if></td>
            <td class="r"><input type="number" class="nm-in" value="${r.tab}" onchange="setNormaValue(${r.id}, this, 'tab')"/></td>
            <td class="r"><input type="number" class="nm-in" value="${r.proc}" onchange="setNormaValue(${r.id}, this, 'proc')"/></td>
            <td class="r"><input type="number" class="nm-in" value="${r.maxval}" onchange="setNormaValue(${r.id}, this, 'max')"/></td>
            <td class="r">
              <button type="button" class="fm-act" title="Открыть норматив" onclick="nmOpen(${r.drug.id})"><i class="fa fa-pencil"></i></button>
              <button type="button" class="fm-act danger" title="Удалить" onclick="delNorma(${r.id}, $(this).closest('tr').attr('data-name'))"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="nmEmpty" style="display:none"><i class="fa fa-sliders"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  DK.filter('nm');
  function nmOpen(drug) { $('#pager').load('/drugs/dict/drug/normas/view.s?id=' + drug); }
  function setNormaValue(id, input, type) {
    $.ajax({
      url: '/drugs/dict/drug/norma/set.s', method: 'post', dataType: 'json',
      data: 'id=' + id + '&type=' + type + '&val=' + encodeURIComponent(input.value),
      success: function (res) {
        if (res.success) { $(input).addClass('saved'); setTimeout(function () { $(input).removeClass('saved'); }, 1200); openMsg(res); }
        else errMsg(res.msg);
      }
    });
  }
  function addNorma() {
    var id = $('#drug_id').val();
    if (!id) { errMsg('Выберите препарат'); return; }
    nmOpen(id);
  }
  function delNorma(id, name) {
    FmsConfirm('Удалить норматив «' + name + '»?', function () {
    $.ajax({
      url: '/drugs/dict/drug/norma/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg('Норматив удалён', true); $('#pager').load('/drugs/dict/drug/normas.s'); }
        else errMsg(res.msg);
      }
    });
  });
  }
</script>
