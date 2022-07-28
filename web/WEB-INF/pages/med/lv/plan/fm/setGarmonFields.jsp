<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    var vals = document.getElementsByTagName("input"), req = '';
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
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c1}">checked</c:if> id="c1" name="c1" value="1"/></td><td class="hand" onclick="setCheck(1)"> ТТГ</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c2}">checked</c:if> id="c2" name="c2" value="1"/></td><td class="hand" onclick="setCheck(2)">Т4</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c3}">checked</c:if> id="c3" name="c3" value="1"/></td><td class="hand" onclick="setCheck(3)">Т3</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c4}">checked</c:if> id="c4" name="c4" value="1"/></td><td class="hand" onclick="setCheck(4)">Анти-ТРО</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c5}">checked</c:if> id="c5" name="c5" value="1"/></td><td class="hand" onclick="setCheck(5)">АН-ТГ</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c6}">checked</c:if> id="c6" name="c6" value="1"/></td><td class="hand" onclick="setCheck(6)">ДГЭА-С</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c7}">checked</c:if> id="c7" name="c7" value="1"/></td><td class="hand" onclick="setCheck(7)">Глобулин связующие половые </td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c8}">checked</c:if> id="c8" name="c8" value="1"/></td><td class="hand" onclick="setCheck(8)">АКТГ</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c9}">checked</c:if> id="c9" name="c9" value="1"/></td><td class="hand" onclick="setCheck(9)">С-пептид</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c10}">checked</c:if> id="c10" name="c10" value="1"/></td><td class="hand" onclick="setCheck(10)">Инсулин</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c11}">checked</c:if> id="c11" name="c11" value="1"/></td><td class="hand" onclick="setCheck(11)">Пролактин</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c12}">checked</c:if> id="c12" name="c12" value="1"/></td><td class="hand" onclick="setCheck(12)">Тестестерон</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c13}">checked</c:if> id="c13" name="c13" value="1"/></td><td class="hand" onclick="setCheck(13)">Гормонроста hGH</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c14}">checked</c:if> id="c14" name="c14" value="1"/></td><td class="hand" onclick="setCheck(14)">Кальцитонин</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c15}">checked</c:if> id="c15" name="c15" value="1"/></td><td class="hand" onclick="setCheck(15)">Тиреоглобулин</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c16}">checked</c:if> id="c16" name="c16" value="1"/></td><td class="hand" onclick="setCheck(16)">Эстрадиол</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c17}">checked</c:if> id="c17" name="c17" value="1"/></td><td class="hand" onclick="setCheck(17)">Кортизол</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c18}">checked</c:if> id="c18" name="c18" value="1"/></td><td class="hand" onclick="setCheck(18)">Прогестерон</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c19}">checked</c:if> id="c19" name="c19" value="1"/></td><td class="hand" onclick="setCheck(19)">ЛГ</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c20}">checked</c:if> id="c20" name="c20" value="1"/></td><td class="hand" onclick="setCheck(20)">ФСГ</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c21}">checked</c:if> id="c21" name="c21" value="1"/></td><td class="hand" onclick="setCheck(21)">Паратгормон</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c22}">checked</c:if> id="c22" name="c22" value="1"/></td><td class="hand" onclick="setCheck(22)">АМГ</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c23}">checked</c:if> id="c23" name="c23" value="1"/></td><td class="hand" onclick="setCheck(23)">Витамин Д</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c24}">checked</c:if> id="c24" name="c24" value="1"/></td><td class="hand" onclick="setCheck(24)">Обший ПСА</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c25}">checked</c:if> id="c25" name="c25" value="1"/></td><td class="hand" onclick="setCheck(25)">Свободный ПСА</td>
                <td align="center" width="30"><input type="checkbox" <c:if test="${bio.c26}">checked</c:if> id="c26" name="c26" value="1"/></td><td class="hand" onclick="setCheck(26)">Кросс Лапс</td>
            <tr><td align="center" width="30"><input type="checkbox" <c:if test="${bio.c27}">checked</c:if> id="c27" name="c27" value="1"/></td><td  colspan="2" class="hand" onclick="setCheck(27)">Нейро-спецефическая энолаза</td>
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