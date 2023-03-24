<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">lg G</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">lg M</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[0].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[0].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[1].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[2].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[2].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[3].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[4].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[4].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[5].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[6].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[6].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[7].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[8].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[8].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[9].html}</td>
  </tr>
  <tr>
    <td colspan="4" style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="font-weight:bold;padding-left:20px;">Врач</td>
          <td width="50%" style="font-weight:bold;text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
