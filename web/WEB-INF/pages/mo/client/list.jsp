<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<table class="table table-bordered table-hover table-header" style="font-size:13px">
  <thead>
    <tr>
      <th class="text-center">№</th>
      <th class="text-center">ФИО</th>
      <th class="text-center">Дата рождения</th>
      <th class="text-center">Пол</th>
      <th class="text-center">Резиденство</th>
      <th class="text-center">Паспорт</th>
      <th class="text-center">Телефон</th>
      <th class="text-center wpx-100">Выбрать</th>
    </tr>
  </thead>
  <c:forEach items="${clients}" var="c" varStatus="loop">
    <tr>
      <td class="text-center">${loop.index + 1}</td>
      <td>${c.fio}</td>
      <td class="text-center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${c.birthdate}" /></td>
      <td class="text-center">${c.sex.name}</td>
      <td class="text-center">${c.country.name}</td>
      <td class="text-center">${c.docNum} ${c.docSeria}</td>
      <td class="text-center">${c.tel}</td>
      <td class="text-center" onclick="chooseClient(${c.id})">
        <button class="btn btn-success btn-icon">
          <i class="fa fa-check"></i>
        </button>
      </td>
    </tr>
  </c:forEach>
</table>
