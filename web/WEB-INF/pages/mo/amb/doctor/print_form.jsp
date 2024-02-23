<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<table class="w-100 table-bordered">
  <tr>
    <td class="bold text-center">ФИО</td>
    <td class="bold text-center">${patient.fio}</td>
  </tr>
  <tr>
    <td class="bold text-center">Год рождения: </td>
    <td class="bold text-center">${patient.birthyear}</td>
  </tr>
  <tr>
    <td class="bold text-center">Дата и время</td>
    <td class="bold text-center">${now}</td>
  </tr>
</table>
<c:forEach items="${services}" var="s">
  <div id="amb_print_form_${s}" style="margin-top:20px"></div>
</c:forEach>
<script>
  <c:forEach items="${services}" var="s">
    $("#amb_print_form_${s}").load('/ambs/work/print/service.s?id=${s}');
  </c:forEach>
</script>
