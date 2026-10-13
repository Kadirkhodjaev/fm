<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Аптека → Справочники → Нормативы → норматив препарата --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<div class="hn-page">
  <div class="hn-doc" style="max-width:720px">
    <div class="hn-card">
      <div class="hn-card-h">
        <div><h3>Норматив · ${drug.name}</h3></div>
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn primary" onclick="saveNorma()"><i class="fa fa-floppy-o"></i>Сохранить</button>
        <button type="button" class="fm-btn" onclick="$('#pager').load('/drugs/dict/drug/normas.s')"><i class="fa fa-arrow-left"></i>Назад</button>
      </div>
      <form id="addEditForms" name="addEditForms" class="hn-card-b" onsubmit="saveNorma(); return false">
        <input type="hidden" name="id" id="id" value="${norma.id}"/>
        <input type="hidden" name="drug" id="drug" value="${drug.id}"/>
        <input type="hidden" name="drug_name" value="${drug.name}"/>
        <div class="fm-row" style="grid-template-columns:1fr 1fr">
          <div>
            <label class="fm-l">Тип норматива</label>
            <div class="fm-state">
              <label><input type="radio" class="a" name="type" value="ALL" onchange="setType()" <c:if test="${norma.normaType != 'MULTI'}">checked</c:if>/><span>Для всех</span></label>
              <label><input type="radio" class="a" name="type" value="MULTI" onchange="setType()" <c:if test="${norma.normaType == 'MULTI'}">checked</c:if>/><span>По складам</span></label>
            </div>
          </div>
          <div>
            <label class="fm-l">Таблеток в пластинке *</label>
            <input type="number" id="tab" class="fm-in" name="tab" value="${norma.tab}" style="text-align:right"/>
          </div>
        </div>
        <div class="ALL_TR" style="max-width:220px">
          <label class="fm-l">Норма *</label>
          <input type="number" id="norma" class="fm-in" name="norma" value="${norma.norma}" style="text-align:right"/>
        </div>
        <div class="DIRECTION_TR">
          <label class="fm-l">Норма по складам</label>
          <table class="fm-grid">
            <c:forEach items="${directions}" var="a">
              <tr>
                <td><span class="${a.norma > 0 ? 'nm' : ''}">${a.direction.name}</span><input type="hidden" name="ids" value="${a.direction.id}"/></td>
                <td style="width:140px"><input type="number" class="fm-in" name="normas" value="${a.norma}" style="text-align:right"/></td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  function setType() {
    var multi = $('[name=type]:checked').val() === 'MULTI';
    $('.DIRECTION_TR').toggle(multi);
    $('.ALL_TR').toggle(!multi);
  }
  setType();
  function saveNorma() {
    if ($('[name=type]:checked').val() === 'ALL' && (getDOM('norma').value === '' || getDOM('norma').value === '0')) {
      errMsg('Укажите норму больше нуля');
      return;
    }
    $.ajax({
      url: '/drugs/dict/drug/norma.s', method: 'post', data: $('#addEditForms').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); $('#pager').load('/drugs/dict/drug/normas.s'); }
        else errMsg(res.msg);
      }
    });
  }
</script>
