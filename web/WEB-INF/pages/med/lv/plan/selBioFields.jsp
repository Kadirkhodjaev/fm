<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.getElementsByTagName("input"), req = '';
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
<div class="modal-dialog" style="width: 800px">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h4 class="modal-title" id="myModalLabel">Биохимические исследовании</h4>
    </div>
    <div class="modal-body">
      <div class="table-responsive">
        <table class="miniGrid table table-striped table-bordered">
          <tbody>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c1>0}">checked</c:if>  id="c1"  name="c1"  value="1"/></td><td class="hand" onclick="setCheck(1)" >Глюкоза крови</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c2>0}">checked</c:if>  id="c2"  name="c2"  value="1"/></td><td class="hand" onclick="setCheck(2)" >Холестерин</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c3>0}">checked</c:if>  id="c3"  name="c3"  value="1"/></td><td class="hand" onclick="setCheck(3)" >β-липопротеиды</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c4>0}">checked</c:if>  id="c4"  name="c4"  value="1"/></td><td class="hand" onclick="setCheck(4)" >Общий белок</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c5>0}">checked</c:if>  id="c5"  name="c5"  value="1"/></td><td class="hand" onclick="setCheck(5)" >Мочевина</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c6>0}">checked</c:if>  id="c6"  name="c6"  value="1"/></td><td class="hand" onclick="setCheck(6)" >Остаточный азот</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c7>0}">checked</c:if>  id="c7"  name="c7"  value="1"/></td><td class="hand" onclick="setCheck(7)" >Креатинин</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c8>0}">checked</c:if>  id="c8"  name="c8"  value="1"/></td><td class="hand" onclick="setCheck(8)" >Билирубин-Общий</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c9>0}">checked</c:if>  id="c9"  name="c9"  value="1"/></td><td class="hand" onclick="setCheck(9)" >Билирубин-Прямой</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c10>0}">checked</c:if> id="c10" name="c10" value="1"/></td><td class="hand" onclick="setCheck(10)">Билирубин-Непрямой</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c11>0}">checked</c:if> id="c11" name="c11" value="1"/></td><td class="hand" onclick="setCheck(11)">Трансаминазы-АСТ</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c12>0}">checked</c:if> id="c12" name="c12" value="1"/></td><td class="hand" onclick="setCheck(12)">Трансаминазы-АЛТ</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c13>0}">checked</c:if> id="c13" name="c13" value="1"/></td><td class="hand" onclick="setCheck(13)">Амилаза крови</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c14>0}">checked</c:if> id="c14" name="c14" value="1"/></td><td class="hand" onclick="setCheck(14)">Мочевая кислота</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c15>0}">checked</c:if> id="c15" name="c15" value="1"/></td><td class="hand" onclick="setCheck(15)">Сывороточное железо</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c16>0}">checked</c:if> id="c16" name="c16" value="1"/></td><td class="hand" onclick="setCheck(16)">К- калий</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c17>0}">checked</c:if> id="c17" name="c17" value="1"/></td><td class="hand" onclick="setCheck(17)">Na- натрий</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c18>0}">checked</c:if> id="c18" name="c18" value="1"/></td><td class="hand" onclick="setCheck(18)">Са- кальций</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c19>0}">checked</c:if> id="c19" name="c19" value="1"/></td><td class="hand" onclick="setCheck(19)">Cl- хлор</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c20>0}">checked</c:if> id="c20" name="c20" value="1"/></td><td class="hand" onclick="setCheck(20)">Phos- фосфор</td></tr>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c21>0}">checked</c:if> id="c21" name="c21" value="1"/></td><td class="hand" onclick="setCheck(21)">Mg - магний</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c22>0}">checked</c:if> id="c22" name="c22" value="1"/></td><td class="hand" onclick="setCheck(22)">Диастаза мочи</td></tr>
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