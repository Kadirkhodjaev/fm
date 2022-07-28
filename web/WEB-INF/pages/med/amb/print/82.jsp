<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;border-spacing: 0; border-collapse: collapse">
  <tr>
    <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <tr>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ïîêàçàòåëü</td>
    <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Ğåçóëüòàò</td>
  </tr>
  <tr>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ÎÏĞÅÄÅËßÅÌÛÅ ÌÈÊĞÎÎĞÃÀÍÈÇÌÈ</td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2">ÊÎËÎĞÎÌÈÒĞÈ×ÅÑÊÀß ĞÅÀÊÖÈß</td>
  </tr>
  <tr>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ÏÎËÎÆÈÒÅËÜÍÛÉ</td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ÎÒĞÈÖÀÒÅËÜÍÛÉ</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[0].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[0].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[1].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[2].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[2].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[3].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[4].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[4].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[5].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[6].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[6].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[7].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[8].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[8].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[9].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[10].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[10].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[11].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[12].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[12].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[13].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[14].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[14].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[15].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[16].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[16].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[17].html}</td>
  </tr>
  <tr>
    <td colspan="3" style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ÀÍÒÈÁÈÎÃĞÀÌÌÀ</td>
  </tr>
  <tr>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ĞÅÇÈÑÒÅÍÒÍÛÉ</td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">×ÓÂÑÒÂÈÒÅËÜÍÛÉ</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[18].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[18].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[19].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[20].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[20].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[21].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[22].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[22].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[23].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[24].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[24].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[25].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[26].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[26].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[27].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[28].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[28].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[29].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[30].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[30].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[31].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[32].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[32].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[33].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[34].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[34].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[35].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[36].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[36].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[37].html}</td>
  </tr>

  <tr>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">Ïğîòèâîãğèáêîâàÿ ÷óâñòâèòåëüíîñòü</td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2">ÊÎËÎĞÎÌÈÒĞÈ×ÅÑÊÀß ĞÅÀÊÑÈß</td>
  </tr>
  <tr>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ĞÅÇÈÑÒÅÍÒÍÛÉ</td>
    <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">×ÓÂÑÒÂÈÒÅËÜÍÛÉ</td>
  </tr>

  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[38].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[38].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[39].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[40].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[40].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[41].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[42].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[42].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[43].html}</td>
  </tr>
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${ser.fields[44].name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[44].html}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${ser.fields[45].html}</td>
  </tr>
  <tr>
    <td colspan="4" style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="font-weight:bold;padding-left:20px;">Âğà÷</td>
          <td width="50%" style="font-weight:bold;text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
