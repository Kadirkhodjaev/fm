<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Отчет: Талабнома</title>
</head>
<body>
<%@include file="../report.jsp"%>
<table width="100%" id="repContent">
  <tr>
    <td style="padding-left: 15px">
      <img src="/res/imgs/fm_logo.png" width="200">
    </td>
    <td style="padding-right:15px;text-align: right">
      <div style="font-weight: bold; font-size: 18px; margin-bottom: 10px">"Тасдиқлайман"</div>
      <div style="margin-bottom: 10px">Бош  шифокор: ${glv.fio}</div>
      <div>"${reg_date}" _____________</div>
    </td>
  </tr>
</table>
<table width="100%" id="repContent">
  <tr>
    <td align="center"><h4 style="font-weight: bold;">ТАЛАБНОМА № ${reg_num}</h4></td>
  </tr>
</table>
<table border="1" width="98%" style="margin:auto; margin-bottom: 40px;">
  <thead>
    <tr>
      <th style="text-align: center; padding:2px; width:40px">№</th>
      <th style="text-align: center">Дори номи</th>
      <th style="text-align: center">Улчов бирлиги</th>
      <th style="text-align: center">Талаб сони</th>
      <th style="text-align: center">Берилган сони</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach items="${rows}" varStatus="loop" var="row">
      <tr>
        <td style="text-align:center; padding:2px">${loop.index + 1}</td>
        <td style="padding:5px">${row.drug.name}</td>
        <td align="center">${row.measure.name}</td>
        <td align="center"><fmt:formatNumber value = "${row.claimCount}" type = "number"/></td>
        <td align="center"><fmt:formatNumber value = "${row.drugCount}" type = "number"/></td>
      </tr>
    </c:forEach>
  </tbody>
</table>
<table width="100%" style="margin-bottom: 20px">
  <tr>
    <td style="width:250px;padding-left: 20px" >Дорихона  бўлими  бошлиғи</td>
    <td style="border-bottom: 1px solid black;"></td>
    <td style="width:80px">бердим</td>
  </tr>
</table>
<table width="95%" style="margin:auto">
  <tr>
    <td style="border-bottom:1px solid black;width: 30%"></td>
    <td style="width:80px">хамшираси</td>
    <td style="border-bottom:1px solid black;"></td>
    <td style="width:80px">олдим</td>
  </tr>
</table>
</body>
</html>
