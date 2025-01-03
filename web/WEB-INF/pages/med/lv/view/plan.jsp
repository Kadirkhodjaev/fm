<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script>
  function printPlan(id){
    window.open('/kdo/print.s?id=' + id);
  }
</script>
<div class="panel panel-info w-100">
  <div class="panel-heading">План обследования</div>
  <table class="formTable" style="width:100%">
    <tr>
      <td colspan="3"><b>Пациент(ка):</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
      <td colspan="2"><b>Год рождения:</b> ${pat.birthyear}</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td align="center" width="400"><b>Наименование</b></td>
      <td align="center" width="140"><b>Дата</b></td>
      <td align="center" width="140"><b>Кол-во</b></td>
      <td align="center"><b>Примечание</b></td>
      <td align="center"><b>Врач</b></td>
    </tr>
    <c:forEach items="${plans}" var="p" varStatus="loop">
      <tr>
        <td align="center">${loop.index + 1}</td>
        <td width="250"><a style="cursor: pointer" onclick="printPlan('${p.c1}')">${p.c4}</a></td>
        <td align="center" nowrap>${p.c5}</td>
        <td align="center" nowrap>${p.c14}</td>
        <td>${p.c6}</td>
        <td>${p.c9}</td>
      </tr>
    </c:forEach>
  </table>
</div>
