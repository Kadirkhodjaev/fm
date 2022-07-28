<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<div class="panel panel-info" style="width: 1100px !important; margin: auto">
  <div class="panel-heading">Дневник</div>
  <table class="formTable" style="width:1000px">
    <tr>
      <td colspan="8">
        <b>Пациент(ка):</b> ${pat.surname} ${pat.name} ${pat.middlename}
        <b>Год рождения:</b> ${pat.birthyear}
      </td>
    </tr>
    <c:forEach items="${dairies}" var="d">
      <tr>
        <td style="font-weight:bold; border:1px solid #ababab;">Дата</td>
        <td align="left"  style="border:1px solid #ababab; font-weight:bold">${d.c2}</td>
        <td align="right" style="border:1px solid #ababab; font-weight: bold;">Пульс (уд/мин):</td>
        <td align="left"  style="border:1px solid #ababab; font-weight: bold">${d.c3}</td>
        <td align="right" style="border:1px solid #ababab; font-weight: bold">Температура (С):</td>
        <td align="left"  style="border:1px solid #ababab; font-weight: bold">${d.c4}</td>
        <td align="right" style="border:1px solid #ababab; font-weight: bold">Давление:</td>
        <td align="left"  style="border:1px solid #ababab; font-weight: bold">${d.c6} / ${d.c7}</td>
      </tr>
      <tr>
        <td colspan="8" style="border:1px solid #ababab;border-bottom:3px solid #ababab">${d.c5}</td>
      </tr>
    </c:forEach>
  </table>
</div>