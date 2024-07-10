<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
    .miniGrid thead tr th {text-align: center; background: #e8e8e8}
    .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Палаты
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>Этаж</th>
          <th>Тип</th>
          <th>Палата</th>
          <th>Лимит</th>
          <th>Цена</th>
          <th>Цена (Не рез)</th>
          <th>Уход</th>
          <th>Уход (Не рез)</th>
          <th>Брон</th>
          <th>Брон (Не рез)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj">
          <tr ondblclick="editDrugDict(${obj.id})" class="hover">
            <td class="text-center">${obj.floor.name}</td>
            <td class="text-center">${obj.roomType.name}</td>
            <td class="text-center">${obj.name}</td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.koykoLimit}" onblur="saveRoom(${obj.id}, 'koykoLimit', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.price}" onblur="saveRoom(${obj.id}, 'price', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.for_price}" onblur="saveRoom(${obj.id}, 'for_price', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.extra_price}" onblur="saveRoom(${obj.id}, 'extra_price', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.for_extra_price}" onblur="saveRoom(${obj.id}, 'for_extra_price', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.bron_price}" onblur="saveRoom(${obj.id}, 'bron_price', this.value)"/>
            </td>
            <td>
              <input class="form-control w-100 text-right" type="number" value="${obj.for_bron_price}" onblur="saveRoom(${obj.id}, 'for_bron_price', this.value)"/>
            </td>

          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>

<script>
  function saveRoom(id, type, value) {
    $.ajax({
      url: '/admin/room/save.s',
      method: 'post',
      data: 'id=' + id + '&type=' + type + '&value=' + value,
      dataType: 'json',
      success: (res) => {
        openMsg(res);
      }
    });
  }
</script>
