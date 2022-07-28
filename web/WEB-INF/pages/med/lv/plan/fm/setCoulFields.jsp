<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.getElementsByTagName("input"), req = '';
    for(var i=0;i<vals.length;i++)
      if(vals[i].checked)
        req += '&' + vals[i].name + '=' + vals[i].value;
    setLocation('/lv/plan/setCoulFields.s?planId=<%=request.getParameter("planId")%>&save=Y' + req);
  }
  function setCheck(id){
    var d = document.getElementById("c" + id);
    d.checked = !d.checked;
  }
</script>
<div class="modal-dialog" style="width: 800px">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h4 class="modal-title" id="myModalLabel">Гармон</h4>
    </div>
    <div class="modal-body">
      <div class="table-responsive">
        <table class="miniGrid table table-striped table-bordered">
          <tbody>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c4}">checked</c:if> id="c4" name="c4" value="1"/></td><td class="hand" onclick="setCheck(4)">ПТИ</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c1}">checked</c:if> id="c1" name="c1" value="1"/></td><td class="hand" onclick="setCheck(1)">Фибриноген</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c2}">checked</c:if> id="c2" name="c2" value="1"/></td><td class="hand" onclick="setCheck(2)">Тромбин вакти</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c3}">checked</c:if> id="c3" name="c3" value="1"/></td><td class="hand" onclick="setCheck(3)">А.Ч.Т.В. (сек)</td>
          </tbody>
        </table>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-default" id="closeBtn" data-dismiss="modal">Закрыть</button>
      <button type="button" onclick="doSave()" class="btn btn-primary">Сохранить</button>
    </div>
  </div>
</div>