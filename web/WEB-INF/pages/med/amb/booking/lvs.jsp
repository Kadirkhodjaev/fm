<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading" style="padding:10px 20px;">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Бронирование</td>
        <td class="right" style="vertical-align: middle;width:100px">
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="table-grid">
        <tr>
          <th>№</th>
          <th>ФИО</th>
          <th>Услуга</th>
          <th>Дата рождения</th>
          <th>Телефон</th>
          <th class="wpx-200">Дата и время брона</th>
          <th class="wpx-200">Дата и время создания</th>
        </tr>
        <c:forEach items="${rows}" var="a">
          <tr>
            <td class="center" style="width:50px">${loop.index + 1}</td>
            <td>${a.fio}</td>
            <td>${services[a.id]}</td>
            <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${a.birthday}"/></td>
            <td class="center">${a.tel}</td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${a.regDate}"/></td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${a.crOn}"/></td>
          </tr>
        </c:forEach>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
