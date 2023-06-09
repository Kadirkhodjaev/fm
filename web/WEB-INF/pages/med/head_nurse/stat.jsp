<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<div class="row" style="margin:20px 0 0 0">
  <div class="col-md-8">
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-twitter fa-fw"></i>
        Статистика
      </div>
      <div class="panel-body">
        <div class="list-group">

        </div>
      </div>
    </div>
  </div>
  <div class="col-md-4">
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-twitter fa-fw"></i>
        Информация
      </div>
      <div class="panel-body">
        <div class="list-group">
          <div class="list-group">
            <table class="table table-bordered">
              <tr>
                <td class="bold center" style="width:140px">Дата</td>
                <td class="bold center">Отделение</td>
              </tr>
              <tr>
                <td><input type="text" autocomplete="off" class="form-control datepicker" id="date_begin" name="date_begin" value="${curDate}" required/></td>
                <td>
                  <select id="dep_id" class="form-control" style="margin-bottom:10px;">
                    <c:forEach items="${depts}" var="dep">
                      <option value="${dep.id}">${dep.name}</option>
                    </c:forEach>
                  </select>
                </td>
              </tr>
            </table>
            <a href="#" onclick="openRep(3); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех обследования на дату
            </a>
            <a href="#" onclick="openRep(4); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех обследования на завтра (НЮ)
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function openRep(idx) {
    let dep = $('#dep_id').val();
    let date = $('#date_begin').val();
    if(dep == null) {
      alert('Департамент не выбран');
      return;
    }
    window.open('/head_nurse/print.s?stat=' + idx + '&dep=' + dep + '&date=' + date);
  }
</script>
