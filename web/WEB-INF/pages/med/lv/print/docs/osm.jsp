<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<table class="formTable" style="width:95%; margin:auto">
  <tr><td colspan="2" align="center"><b>БЎЛИМДАГИ КЎРИК</b></td></tr>
  <tr><td colspan="2"><br/></td></tr>
  <tr><td colspan="2"><b>Сана:</b> ${form.c7}</td></tr>
  <tr>
    <td><b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Тугилган йили:</b> ${form.patient.birthyear}</td>
  </tr>
  <c:if test="${form.c1 != ''}">
    <tr><td colspan="2"><b>Шикоятлари:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c1}</td></tr>
  </c:if>
  <c:if test="${form.c2 != '' && form.c2 != '<br>' && form.c2 != null}">
    <tr><td colspan="2"><b>Anamnesis morbi:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c2}</td></tr>
  </c:if>
  <c:if test="${form.c8 != '' && form.c8 != '<br>' && form.c8 != null}">
    <tr><td colspan="2"><b>Anamnesis vitae:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c8}</td></tr>
  </c:if>
  <c:if test="${form.c3 != '' && form.c3 != '<br>' && form.c3 != null}">
    <tr><td colspan="2"><b>Status praesens:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c3}</td></tr>
  </c:if>
  <c:if test="${form.c9 != '' && form.c9 != '<br>' && form.c9 != null}">
    <tr><td colspan="2"><b>Нафас олиш системаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c9}</td></tr>
  </c:if>
  <c:if test="${form.c10 != '' && form.c10 != '<br>' && form.c10 != null}">
    <tr><td colspan="2"><b>Қон айланиш системаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c10}</td></tr>
  </c:if>
  <c:if test="${form.c11 != '' && form.c11 != '<br>' && form.c11 != null}">
    <tr><td colspan="2"><b>Хазм қилиш cистемаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c11}</td></tr>
  </c:if>
  <c:if test="${form.c12 != '' && form.c12 != '<br>' && form.c12 != null}">
    <tr><td colspan="2"><b>Сийдик-таносил системаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c12}</td></tr>
  </c:if>
  <c:if test="${form.c13 != '' && form.c13 != '<br>' && form.c13 != null}">
    <tr><td colspan="2"><b>Нерв системаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c13}</td></tr>
  </c:if>
  <c:if test="${form.c14 != '' && form.c14 != '<br>' && form.c14 != null}">
    <tr><td colspan="2"><b>Эндокрин системаси:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c14}</td></tr>
  </c:if>
  <c:if test="${form.c15 != '' && form.c15 != '<br>' && form.c15 != null}">
    <tr><td colspan="2"><b>Қалқонсимон без:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c15}</td></tr>
  </c:if>
  <c:if test="${form.c16 != '' && form.c16 != '<br>' && form.c16 != null}">
    <tr><td colspan="2"><b>Меьда ости бези:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c16}</td></tr>
  </c:if>
  <c:if test="${form.c3 != '' && form.c3 != '<br>' && form.c3 != null}">
    <tr><td colspan="2"><b>Руйхатга олиниш вактидаги беморнинг холати:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c3}</td></tr>
  </c:if>
  <c:if test="${form.c4 != '' && form.c4 != '<br>' && form.c4 != null}">
    <tr><td colspan="2"><b>Стационардавогача булган текширувлар:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c4}</td></tr>
  </c:if>
  <c:if test="${form.c5 != '' && form.c5 != '<br>' && form.c5 != null}">
    <tr><td colspan="2"><b>Тахминий ташхис: Асосий</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c5}</td></tr>
  </c:if>
  <c:if test="${form.c18 != '' && form.c18 != '<br>' && form.c18 != null}">
    <tr><td colspan="2"><b>Тахминий ташхис: Хамрох</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c18}</td></tr>
  </c:if>
  <c:if test="${form.c19 != '' && form.c19 != '<br>' && form.c19 != null}">
    <tr><td colspan="2"><b>Тахминий ташхис: Асорати</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c19}</td></tr>
  </c:if>
  <c:if test="${form.c6 != '' && form.c6 != '<br>' && form.c6 != null}">
    <tr><td colspan="2"><b>Даволашни асослаш:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c6}</td></tr>
  </c:if>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Шифокор</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>