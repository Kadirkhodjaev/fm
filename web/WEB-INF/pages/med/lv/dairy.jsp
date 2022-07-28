<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function setDairy(id){
    setLocation('?dairyId=' + id + '#newDairy');
  }
  function copyDairy(id){
    setLocation('?copy=Y&dairyId=' + id + '#newDairy');
  }
  function printDairy(id) {
    window.open('/lv/print.s?dairyId=' + id);
  }
</script>
<f:form commandName="dairy" method="post">
  <f:hidden path="id"/>
  <div class="panel panel-info" style="width: 1000px !important; margin: auto">
    <div class="panel-heading">
      Дневник
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>
    <%@include file="/incs/msgs/errors.jsp"%>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="7"><b>Пациент(ка):</b> ${fio} <b>Год рождения:</b>${birthyear}</td>
        </td>
      </tr>
      <c:forEach items="${dairies}" var="d">
        <tr>
          <td class="bold" style="border-top:2px solid #ababab;">Дата:</td>
          <td style="border-top:2px solid #ababab;" align="left" class="bold">${d.c2}</td>
          <td nowrap class="bold">Пульс (уд/мин):</td>
          <td align="left">${d.c3}</td>
          <td class="bold">Давление:</td>
          <td align="left" nowrap="nowrap">${d.c6} / ${d.c7}</td>
          <td align="right" style="border-top:2px solid #ababab;">
            <input type="checkbox" name="dairy" dairy="${d.c1}" title="Выбор несколько записи для печати" />
            <b title='Печать' onclick="printDairy('${d.c1}')" class="hand glyphicon glyphicon-print"></b>&nbsp;
            <b title='Редактировать' onclick="setDairy(${d.c1})" class="hand glyphicon glyphicon-edit"></b>&nbsp;
            <b title='Создать новый дневник на основании текущего' onclick="copyDairy(${d.c1})" class="hand glyphicon glyphicon-copy"></b>
          </td>
        </tr>
        <tr>
          <td colspan="7">${d.c5}</td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="7" style="border-top:2px solid #ababab; border-bottom:2px solid #ababab; padding:15px; font-size:16px" id="newDairy" class="center bold">
          <%=request.getParameter("dairyId") == null || request.getParameter("copy") != null ? "Новый дневник" : "Редактирование дневника"%>
        </td>
      </tr>
      <tr>
        <td class="bold">Дата</td>
        <td><input name="act_Date" id="act_Date" value="${act_Date}" class="form-control datepicker" type="text"/></td>
        <td class="bold" nowrap>Пульс (уд/мин)</td>
        <td><f:input path="puls" style="width:80px" class="center form-control" type="number"/></td>
        <td class="bold">Давление</td>
        <td nowrap="nowrap" colspan="2">
          <f:input path="dav1" style="width:60px; display:inline" class="center form-control" type="number" maxlength="3"/>
          /
          <f:input path="dav2" style="width:60px; display:inline" class="center form-control" type="number" maxlength="3"/>
        </td>
      </tr>
      <tr>
        <td colspan="7"><f:textarea path="text" style="width:990px" rows="8" maxlength="10000"/></td>
      </tr>
      <tr>
      </tr>
    </table>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn class="hidden">Сохранить</button>
    </div>
  </div>
</f:form>