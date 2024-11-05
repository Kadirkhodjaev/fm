<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script>
  function printPlan(id){
    window.open('/kdo/print.s?id=' + id);
  }
</script>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
</style>
<div class="panel panel-info" style="width: 95% !important; margin: auto;">
  <div class="panel-heading">Текширувлар</div>
  <table class="formTable" style="width:100%">
    <tr>
      <td colspan="3"><b>Бемор:</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
      <td colspan="2"><b>Тугилган йили:</b> ${pat.birthyear}</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td align="center"><b>Номи</b></td>
      <td align="center"><b>Сана</b></td>
      <td align="center"><b>Маълумотлар</b></td>
    </tr>
    <c:forEach items="${plans}" var="p" varStatus="loop">
      <tr>
        <td align="center">${loop.index + 1}</td>
        <td >${p.c4}</td>
        <td align="center" nowrap>${p.c5}</td>
        <td>${p.c6}</td>
      </tr>
    </c:forEach>
    <c:forEach items="${consuls}" var="c" varStatus="loop">
      <tr>
        <td align="center">-</td>
        <td>Консультация: ${c.copied} - ${c.lvName}</td>
        <td align="center" nowrap>${c.date}</td>
        <td>&nbsp;</td>
      </tr>
    </c:forEach>
  </table>
</div>