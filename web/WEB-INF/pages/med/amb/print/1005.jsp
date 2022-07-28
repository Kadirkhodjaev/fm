<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Показатель</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">ur</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">cer</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">vag</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[0].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[0].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[1].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[2].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[3].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[3].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[4].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[5].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[6].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[6].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[7].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[8].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[9].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[9].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[10].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[11].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[12].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[12].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[13].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[14].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[15].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[15].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[16].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[17].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[18].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[18].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[19].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[20].html}</td>
  </tr>
  <tr>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[21].name}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[21].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[22].html}</td>
    <td style="padding:5px;text-align:center;border:1px solid black;">${ser.fields[23].html}</td>
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
