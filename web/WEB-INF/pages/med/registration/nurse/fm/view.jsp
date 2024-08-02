<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<script>
  function saveLv() {
    $.ajax({
      url: "/reg/lvConf.s",
      method: "post",
      data: ($('#lv').val() != '' && $('#lv').val() != undefined ? 'lv=' + $('#lv').val(): '') + '&zavlv=' + $('#zavlv').val(),
      dataType: 'json',
      success: function (data) {
        openMsg(data);
        if (data.success) {
          parent.openMainPage('/patients/list.s?curPat=Y');
        }
      }
    });
  }
  function setLvPartner(lvpartner) {
    $.ajax({
      url: "/reg/lvpartner.s",
      method: "post",
      data: 'id=${pat.id}&lvpartner=' + lvpartner,
      dataType: 'json',
      success: function (data) {
        openMsg(data);
      }
    });
  }
</script>
<div style="display: none">
  <button onclick="saveLv()" id="saveBtn"></button>
</div>
<div class="panel panel-info" style="width: 700px !important; margin: auto">
  <table class="formTable">
    <tr>
      <td class="right bold" nowrap>ФИО:</td>
      <td colspan="3"> ${pat.surname} ${pat.name} ${pat.middlename} </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Тугилган йили:</td>
      <td>${pat.birthyear}</td>
      <td class="right bold" nowrap>Жинси:</td>
      <td>${pat.sex.name}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Буйи:</td>
      <td>${pat.rost}</td>
      <td class="right bold" nowrap>Огирлиги:</td>
      <td>${pat.ves}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Иш жойи:</td>
      <td>${pat.work}</td>
      <td class="right bold" nowrap>Мансаби:</td>
      <td>${pat.post}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Фукоролик:</td>
      <td>${country}</td>
      <td class="right bold" nowrap>Вилоят:</td>
      <td>${region}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Манзили:</td>
      <td>${pat.address}</td>
      <td class="right bold" nowrap>Паспорт маълумотлари:</td>
      <td>${pat.passportInfo}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Телефон раками:</td>
      <td>${pat.tel}</td>
      <td class="right bold" nowrap>Амб. картаси раками:</td>
      <td>${pat.ambNum}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Қон гуруҳи:</td>
      <td>${pat.bloodGroup.name}</td>
      <td class="right bold" nowrap>Резус мансублиги:</td>
      <td>${pat.resus}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Бемор қайердан юборилган:</td>
      <td>${pat.orientedBy}</td>
      <td class="right bold" nowrap>Транспортда:</td>
      <td>${pat.transport}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Олиб юриш турлари:</td>
      <td>${pat.vidPer.name}</td>
      <td class="right bold" nowrap>Харорати:</td>
      <td>${pat.temp}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Метка:</td>
      <td>${pat.metka.name}</td>
      <td class="right bold" nowrap>Руйхатга олинган вакт</td>
      <td>${pat.time}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Даволовчи шифокор:
      <td>
        <c:choose>
          <c:when test="${pat.state == 'CZG' && sessionScope.ENV.roleId == 6}">
            <select id="lv" class="form-control">
              <option value=""></option>
              <c:forEach items="${lvs}" var="f">
                <option <c:if test="${lv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
              </c:forEach>
            </select>
          </c:when>
          <c:otherwise>${lv.fio}</c:otherwise>
        </c:choose>
      </td>
      <td class="right bold" nowrap>Тениаринхоз санаси:</td>
      <td>${pat.tarDate}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Булим бошлиги:
      <td colspan="3">
        <c:choose>
          <c:when test="${sessionScope.ENV.roleId == 6}">
            <select id="zavlv" class="form-control">
              <option value=""></option>
              <c:forEach items="${zavs}" var="f">
                <option <c:if test="${pat.zavlv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
              </c:forEach>
            </select>
          </c:when>
          <c:otherwise>${pat.zavlv.fio}</c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Булим:
      <td>${pat.dept.name}
      <td class="right bold" nowrap>№ Хона:</td>
      <td>${pat.room.name} - ${pat.room.roomType.name}</td>
    </tr>
    <tr>
      <td class="right bold">Дориларнинг ножуя тасири:</td>
      <td colspan="3">${pat.drugEffect}</td>
    </tr>
    <tr>
      <td class="right bold">Йулланмадаги ташхис:</td>
      <td colspan="3">${pat.diagnoz}</td>
    </tr>
    <c:if test="${sessionScope.ENV.userId == 1}">
      <tr>
        <td class="right bold" nowrap>Йуналтирган мутахасис коди:</td>
        <td colspan="3">
          <select name="lvpartner_id" class="form-control" onchange="setLvPartner(this.value)">
            <option value=""></option>
            <c:forEach items="${lvpartners}" var="lvp">
              <option <c:if test="${pat.lvpartner.id == lvp.id}">selected</c:if> value="${lvp.id}">${lvp.code}</option>
            </c:forEach>
          </select>
      </tr>
    </c:if>
  </table>
</div>
