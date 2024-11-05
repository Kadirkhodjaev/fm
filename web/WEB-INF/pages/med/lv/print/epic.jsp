<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
</style>
<div class="panel panel-info" style="width: 850px !important; margin: auto">
  <div class="panel-heading">Утказилиш эпикризи</div>
  <table class="formTable" width="95%">
    <tr>
      <td class="bold">Бемор:</td>
      <td colspan="2">${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
      <td class="bold right">Тугилган йили:</td>
      <td>${pat.birthyear}</td>
    </tr>
    <c:forEach items="${epics}" var="e">
      <tr>
        <td colspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Давр</td>
        <td rowspan="2" width="80px" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Булим</td>
        <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Хона</td>
        <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Шифокор</td>
      </tr>
      <tr>
        <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">дан</td>
        <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">гача</td>
      </tr>
      <tr>
        <td width="100px" align="center">${e.c1}</td>
        <td width="140px" align="center">${e.c2}</td>
        <td>${e.c3}</td>
        <td style="text-align: center !important;">${e.c4}</td>
        <td>${e.c5}</td>
      </tr>
    </c:forEach>
  </table>
</div>