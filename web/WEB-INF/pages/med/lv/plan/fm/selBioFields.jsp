<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.querySelectorAll("#pmGrid input"), req = '';
    for(var i=0;i<vals.length;i++)
      if(vals[i].checked)
        req += '&' + vals[i].name + '=' + vals[i].value;
    setLocation('/lv/plan/selBioFields.s?planId=<%=request.getParameter("planId")%>&save=Y' + req);
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
      <h4 class="modal-title" id="myModalLabel">Биохимические исследовании</h4>
    </div>
    <div class="modal-body">
      <div class="pm-tools"><a href="#" onclick="pmAll(true); return false">Отметить все</a><a href="#" onclick="pmAll(false); return false">Снять все</a><span class="pm-cnt" id="pmCnt"></span></div>
      <div class="pm-grid" id="pmGrid">
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c1>0}">checked</c:if>  id="c1"  name="c1"  value="1"/><span>Умумий оксил</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c2>0}">checked</c:if>  id="c2"  name="c2"  value="1"/><span>Холестерин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c3>0}">checked</c:if>  id="c3"  name="c3"  value="1"/><span>Глюкоза</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c4>0}">checked</c:if>  id="c4"  name="c4"  value="1"/><span>Мочевина</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c5>0}">checked</c:if> id="c5" name="c5" value="1"/><span>Креатинин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c6>0}">checked</c:if> id="c6" name="c6" value="1"/><span>Билирубин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c7>0}">checked</c:if>  id="c7"  name="c7"  value="1"/><span>АЛТ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c8>0}">checked</c:if>  id="c8"  name="c8"  value="1"/><span>АСТ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c9>0 }">checked</c:if>  id="c9"  name="c9"  value="1"/><span>Альфа амилаза</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c10>0}">checked</c:if>  id="c10" name="c10" value="1"/><span>Кальций</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c11>0}">checked</c:if> id="c11" name="c11" value="1"/><span>Сийдик кислотаси</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c12>0}">checked</c:if> id="c12" name="c12" value="1"/><span>K – калий</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c13>0}">checked</c:if> id="c13" name="c13" value="1"/><span>Na – натрий</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c14>0}">checked</c:if> id="c14" name="c14" value="1"/><span>Fe – темир</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c15>0}">checked</c:if> id="c15" name="c15" value="1"/><span>Mg – магний</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c16>0}">checked</c:if> id="c16" name="c16" value="1"/><span>Ишкорий фасфотаза</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c17>0}">checked</c:if> id="c17" name="c17" value="1"/><span>ГГТ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c18>0}">checked</c:if> id="c18" name="c18" value="1"/><span>Гликирланган гемоглобин</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c19>0}">checked</c:if> id="c19" name="c19" value="1"/><span>РФ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c20>0}">checked</c:if> id="c20" name="c20" value="1"/><span>АСЛО</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c21>0}">checked</c:if> id="c21" name="c21" value="1"/><span>СРБ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c22>0}">checked</c:if> id="c22" name="c22" value="1"/><span>RW</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c23>0}">checked</c:if> id="c23" name="c23" value="1"/><span>Hbs Ag</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c24>0}">checked</c:if> id="c24" name="c24" value="1"/><span>Гепатит «С» ВГС</span></label>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="pm-btn" id="closeBtn" data-dismiss="modal">Закрыть</button>
      <button type="button" onclick="doSave()" class="pm-btn primary"><i class="fa fa-check"></i> Сохранить</button>
    </div>
  </div>
</div>