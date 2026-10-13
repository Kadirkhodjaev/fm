<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.querySelectorAll("#pmGrid input"), req = '';
    for(var i=0;i<vals.length;i++)
      if(vals[i].checked)
        req += '&' + vals[i].name + '=' + vals[i].value;
    setLocation('/lv/plan/setGarmonFields.s?planId=<%=request.getParameter("planId")%>&save=Y' + req);
  }
  function setCheck(id){
    var d = document.getElementById("c" + id);
    d.checked = !d.checked;
  }
</script>
<%@include file="/WEB-INF/pages/med/lv/plan/pm_style.jsp"%>
<div class="modal-dialog pm" style="width: 760px">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h4 class="modal-title" id="myModalLabel">Гармон</h4>
    </div>
    <div class="modal-body">
      <div class="pm-tools"><a href="#" onclick="pmAll(true); return false">Отметить все</a><a href="#" onclick="pmAll(false); return false">Снять все</a><span class="pm-cnt" id="pmCnt"></span></div>
      <div class="pm-grid" id="pmGrid">
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c1}">checked</c:if> id="c1" name="c1" value="1"/><span>ТТГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c2}">checked</c:if> id="c2" name="c2" value="1"/><span>Т4</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c3}">checked</c:if> id="c3" name="c3" value="1"/><span>Т3</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c4}">checked</c:if> id="c4" name="c4" value="1"/><span>Анти-ТРО</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c5}">checked</c:if> id="c5" name="c5" value="1"/><span>АН-ТГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c6}">checked</c:if> id="c6" name="c6" value="1"/><span>ДГЭА-С</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c7}">checked</c:if> id="c7" name="c7" value="1"/><span>Глобулин связующие половые</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c8}">checked</c:if> id="c8" name="c8" value="1"/><span>АКТГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c9}">checked</c:if> id="c9" name="c9" value="1"/><span>С-пептид</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c10}">checked</c:if> id="c10" name="c10" value="1"/><span>Инсулин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c11}">checked</c:if> id="c11" name="c11" value="1"/><span>Пролактин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c12}">checked</c:if> id="c12" name="c12" value="1"/><span>Тестестерон</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c13}">checked</c:if> id="c13" name="c13" value="1"/><span>Гормонроста hGH</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c14}">checked</c:if> id="c14" name="c14" value="1"/><span>Кальцитонин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c15}">checked</c:if> id="c15" name="c15" value="1"/><span>Тиреоглобулин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c16}">checked</c:if> id="c16" name="c16" value="1"/><span>Эстрадиол</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c17}">checked</c:if> id="c17" name="c17" value="1"/><span>Кортизол</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c18}">checked</c:if> id="c18" name="c18" value="1"/><span>Прогестерон</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c19}">checked</c:if> id="c19" name="c19" value="1"/><span>ЛГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c20}">checked</c:if> id="c20" name="c20" value="1"/><span>ФСГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c21}">checked</c:if> id="c21" name="c21" value="1"/><span>Паратгормон</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c22}">checked</c:if> id="c22" name="c22" value="1"/><span>АМГ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c23}">checked</c:if> id="c23" name="c23" value="1"/><span>Витамин Д</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c24}">checked</c:if> id="c24" name="c24" value="1"/><span>Обший ПСА</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c25}">checked</c:if> id="c25" name="c25" value="1"/><span>Свободный ПСА</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c26}">checked</c:if> id="c26" name="c26" value="1"/><span>Кросс Лапс</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c27}">checked</c:if> id="c27" name="c27" value="1"/><span>Нейро-спецефическая энолаза</span></label>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="pm-btn" id="closeBtn" data-dismiss="modal">Закрыть</button>
      <button type="button" onclick="doSave()" class="pm-btn primary"><i class="fa fa-check"></i> Сохранить</button>
    </div>
  </div>
</div>