<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<table class="formTable" style="width:95%; margin:auto">
  <tr>
    <td colspan="2" align=center><b>КЛИНИК ТАШХИСНИ АСОСЛАШ</b></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr><td colspan="2"><b>Сана:</b> ${obos.c8}</td></tr>
  <tr>
    <td><b>Бемор:</b> ${obos.patient.surname}&nbsp;${obos.patient.name}&nbsp;${obos.patient.middlename}</td>
    <td><b>Тугилган йили:</b> ${obos.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Шикоятлари:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${obos.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Anamnez</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${obos.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Status praesens</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${obos.c3}</td>
  </tr>
  <tr>
    <td colspan="2">Текширув ва тахлиллар</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${obos.c4}</td>
  </tr>
  <tr><td colspan="2"><b>Ташхис: Асосий</b>:</td></tr>
  <tr><td colspan="2" align="justify">${obos.c5}</td></tr>
  <tr><td colspan="2"><b>Ташхис: Хамрох</b>:</td></tr>
  <tr><td colspan="2" align="justify">${obos.c6}</td></tr>
  <tr><td colspan="2"><b>Ташхис: Асорати</b>:</td></tr>
  <tr><td colspan="2" align="justify">${obos.c7}</td></tr>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Шифокор</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>