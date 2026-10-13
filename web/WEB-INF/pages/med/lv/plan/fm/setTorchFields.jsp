<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.querySelectorAll("#pmGrid input"), req = '';
    for(var i=0;i<vals.length;i++)
      if(vals[i].checked)
        req += '&' + vals[i].name + '=' + vals[i].value;
    setLocation('/lv/plan/setTorchFields.s?planId=<%=request.getParameter("planId")%>&save=Y' + req);
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
      <h4 class="modal-title" id="myModalLabel">Торч инфекций</h4>
    </div>
    <div class="modal-body">
      <div class="pm-tools"><a href="#" onclick="pmAll(true); return false">Отметить все</a><a href="#" onclick="pmAll(false); return false">Снять все</a><span class="pm-cnt" id="pmCnt"></span></div>
      <div class="pm-grid" id="pmGrid">
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c1}">checked</c:if> id="c1" name="c1" value="1"/><span>Хламидия</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c2}">checked</c:if> id="c2" name="c2" value="1"/><span>Токсоплазма</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c3}">checked</c:if> id="c3" name="c3" value="1"/><span>ЦМВ</span></label>
          <label class="pm-it"><input type="checkbox" <c:if test="${bio.c4}">checked</c:if> id="c4" name="c4" value="1"/><span>ВПГ</span></label>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="pm-btn" id="closeBtn" data-dismiss="modal">Закрыть</button>
      <button type="button" onclick="doSave()" class="pm-btn primary"><i class="fa fa-check"></i> Сохранить</button>
    </div>
  </div>
</div>