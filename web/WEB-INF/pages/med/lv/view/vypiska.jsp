<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">Выписка</div>
  <div class="panel-body">
    <table style="width:100%">
      <tr>
        <td colspan="2" style="text-align:center;padding-top:10px">
          <b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}
          <b>Тугилган йили:</b> ${form.patient.birthyear}
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:center;padding-top:10px">
          <b>Касалхонага келди:</b> ${dateBegin}
          <b>Касалхонадан кетди:</b> ${dateEnd}
        </td>
      </tr>
      <tr>
        <td colspan="2"><b>КЛИНИК ТАШХИС:</b></td>
      </tr>
      <tr>
        <td colspan="2"><b>Асосий:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c1}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Хамрох:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c8}</td>
      </tr>
      <c:if test="${form.c9 != '' && form.c9 != null && form.c9 != '<br>'}">
        <tr>
          <td colspan="2"><b>Асорати:</b></td>
        </tr>
        <tr>
          <td colspan="2" align="justify">${form.c9}</td>
        </tr>
      </c:if>
      <tr>
        <td colspan="2"><b>Шикоятлар:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c2}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Анамнез:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c3}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Объектив:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c4}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Утказилган текширувлар:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c5}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Утказилган даволашлар:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c6}</td>
      </tr>
      <tr>
        <td colspan="2"><b>ЧИКАРУВ ВАКТИДАГИ ТАШХИС:</b></td>
      </tr>
      <tr>
        <td colspan="2"><b>Асосий:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c10}</td>
      </tr>
      <tr>
        <td colspan="2"><b>Хамрох:</b></td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c11}</td>
      </tr>
      <c:if test="${form.c12 != '' && form.c12 != null && form.c12 != '<br>'}">
        <tr>
          <td colspan="2"><b>Асорати:</b></td>
        </tr>
        <tr>
          <td colspan="2" align="justify">${form.c12}</td>
        </tr>
      </c:if>

      <tr>
        <td colspan="2">
          <b>Тавсия:</b>
        </td>
      </tr>
      <tr>
        <td colspan="2" align="justify">${form.c7}</td>
      </tr>
    </table>
  </div>
</div>
