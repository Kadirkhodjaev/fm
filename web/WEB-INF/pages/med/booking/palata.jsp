<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row" style="margin:0">
  <div class="col-lg-12">
    <!-- /.panel-heading -->
    <table class="table table-bordered" width="100%">
      <tr style="font-weight:bold;background:#f1f1f1">
        <td style="text-align:center;padding:5px;" width="110">Этаж</td>
        <td style="text-align:center;padding:5px;">Палата</td>
        <td style="text-align:center;padding:5px;" width="150">Кол-во пациентов</td>
        <td style="text-align:center;padding:5px;" width="60">Доступ</td>
        <td style="text-align:center;padding:5px;" width="60">Убрать</td>
      </tr>
      <c:forEach items="${rooms}" var="room">
        <tr class="hover">
          <td align="center">${room.stage}</td>
          <td>${room.num} - ${room.type}</td>
          <c:if test="${room.state == 'A'}">
            <td align="center" style="color:<c:if test="${room.next_tr >= room.limit}">red;font-weight:bold</c:if>">${room.next_tr}</td>
            <td align="center">
              <c:if test="${room.next_tr == room.limit && room.access == 'N'}">
                <button onclick="setAccess(${room.id})" class="btn btn-success btn-sm" style="height:20px;padding:0 10px"><span class="fa fa-check"></span></button>
              </c:if>
            </td>
            <td align="center">
              <c:if test="${room.access == 'Y'}">
                <button onclick="getAccess(${room.id})" class="btn btn-danger btn-sm" style="height:20px;padding:0 10px"><span class="fa fa-times"></span></button>
              </c:if>
            </td>
          </c:if>
          <c:if test="${room.state != 'A'}">
            <td align="center" colspan="3" style="font-weight:bold; color:red">Палата временно не функционирует</td>
          </c:if>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<script>
  function setAccess(id) {
    if(confirm('Дейтвительно хотите открыть доступ?')) {
      $.ajax({
        url: '/booking/palata.s',
        method: 'post',
        data: 'code=set&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/booking/palata.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function getAccess(id) {
    if(confirm('Дейтвительно хотите убрать доступ?')) {
      $.ajax({
        url: '/booking/palata.s',
        method: 'post',
        data: 'code=get&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/booking/palata.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>