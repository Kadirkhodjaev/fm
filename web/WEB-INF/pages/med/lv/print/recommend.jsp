<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Распечатка по пациенту ${pat.fio}</title>
</head>
<body>
  <table style="width:100%; margin:auto;border-collapse: collapse">
    <tr>
      <td style="border-bottom:1px solid black; padding:5px;text-align: right">Пациент: </td>
      <td style="border-bottom:1px solid black; padding:5px;font-weight: bold">${pat.fio}</td>
      <td style="border-bottom:1px solid black; padding:5px;text-align: right">Тугилган йили: </td>
      <td style="border-bottom:1px solid black; padding:5px;font-weight: bold">${pat.birthyear}</td>
    </tr>
    <tr>
      <td colspan="4" style="padding:20px;font-weight: bold; text-align: center">
        Тавсия
      </td>
    </tr>
    <tr>
      <td colspan="4" style="padding:5px;">
        ${doc.c7}
      </td>
    </tr>
    <tr>
      <td colspan="4" style="padding:20px"></td>
    </tr>
    <tr>
      <td colspan="2" style="padding:5px;font-weight: bold">
        Врач
      </td>
      <td colspan="2" style="padding:5px;text-align: right; font-weight: bold">
        ${lv.fio}
      </td>
    </tr>
  </table>
</body>
</html>
