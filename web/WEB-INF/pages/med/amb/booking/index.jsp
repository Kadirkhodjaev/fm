<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading" style="padding:0 20px;">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Бронирование</td>
        <td style="width:140px;padding:5px">
          <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
        </td>
        <td style="width:10px;vertical-align: middle">
          -
        </td>
        <td style="width:140px;padding:5px">
          <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
        </td>
        <td style="vertical-align: middle">
          <button onclick="setDates()" class="btn btn-success btn-icon">Поиск</button>
        </td>
        <td class="right" style="vertical-align: middle;width:100px">
          <button onclick="setPage('/amb/booking.s?id=0')" class="btn btn-success btn-icon">
            <b class="fa fa-plus"></b> Добавить
          </button>
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
          <th>Дата рождения</th>
          <th>Телефон</th>
          <th>Дата и время брона</th>
          <th class="wpx-40">#</th>
        </tr>
        <c:forEach items="${rows}" var="a" varStatus="loop">
          <tr ondblclick="setPage('/amb/booking.s?id=${a.id}')">
            <td class="center" style="width:50px">${loop.index + 1}</td>
            <td>${a.fio}</td>
            <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${a.birthday}"/></td>
            <td class="center">${a.tel}</td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${a.regDate}"/></td>
            <td class="center">
              <c:if test="${obj.state == 'ENT'}">
                <button class="btn btn-danger btn-icon" title="Удалить" onclick="delDate(${a.id})"><i class="fa fa-minus"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<script>
  function setDates(){
    let start = getDOM("period_start");
    let end = getDOM("period_end");
    setPage('/amb/bookings.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function delDate(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: '/amb/booking/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if (res.success)
            setPage('/amb/bookings.s');
        }
      });
  }
</script>
