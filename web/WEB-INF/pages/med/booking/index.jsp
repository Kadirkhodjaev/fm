<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-primary" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Бронирование койки
    <button  class="btn btn-sm btn-success" onclick="addBooking()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>&nbsp;</th>
          <th>№</th>
          <th>ФИО</th>
          <th>Год рождения</th>
          <th>Дата рег</th>
          <th>Отд./Пал.</th>
          <th>ФИО ЛВ</th>
          <th>Состояние</th>
          <th>Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr>
            <td>&nbsp;</td>
            <td align="center">${loop.index + 1}</td>
            <td>
              <a href="#" onclick="editBooking(${obj.id})">${obj.surname} ${obj.name} ${obj.middlename}</a>
            </td>
            <td align="center">${obj.birthyear}</td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" /></td>
            <td align="center">${obj.dept.name} /  ${obj.room.name} - ${obj.room.roomType.name}</td>
            <td align="center">${obj.lv.fio}</td>
            <td align="center">
              <c:if test="${obj.state == 'ENT'}">Введен</c:if>
            </td>
            <td align="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="removeBooking(${obj.id})"><span class="fa fa-minus"></span></button>
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
<!-- AddEdit Form -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content" style="width:900px">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Пациент маълумотлари</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">ФИШ*:</td>
              <td colspan="3">
                <div class="row">
                  <div class="col-lg-4">
                    <input type="text" autocomplete="off" placeholder="Фамилия" style="text-transform: uppercase;" class="form-control" name="surname" value="" required/>
                  </div>
                  <div class="col-lg-4">
                    <input type="text" autocomplete="off" placeholder="Исм" style="text-transform: uppercase;" class="form-control" name="name" value="" required/>
                  </div>
                  <div class="col-lg-4">
                    <input type="text" autocomplete="off" placeholder="Шариф" style="text-transform: uppercase;" class="form-control" name="middlename" value=""/>
                  </div>
                </div>

              </td>
            </tr>
            <tr>
              <td class="right bold" nowrap>Тугилган йили*:</td>
              <td>
                <input type="number" autocomplete="off" placeholder="xxxx" class="form-control center" name="birthyear" value="" required/>
              </td>
              <td class="right bold" nowrap>Жинси*:</td>
              <td>
                <select name="sex" class="form-control" required>
                  <c:forEach items="${sex}" var="ss">
                    <option value="${ss.id}">${ss.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold" nowrap>Дата рег*:</td>
              <td>
                <input type="text" autocomplete="off" class="form-control datepicker" id="date_begin" name="date_begin" value="" required/>
              </td>
              <td class="right bold" nowrap>Резидентлиги*:</td>
              <td>
                <select name="country" class="form-control" required>
                  <c:forEach items="${countries}" var="ss">
                    <option value="${ss.id}">${ss.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Булим*:</td>
              <td>
                <select name="dept" class="form-control" required>
                  <c:forEach items="${depts}" var="ss">
                    <option value="${ss.id}">${ss.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td class="right bold">№ хона*:</td>
              <td>
                <select name="room" class="form-control" required>
                  <c:forEach items="${rooms}" var="ss">
                    <option value="${ss.id}">${ss.name} - ${ss.roomType.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold" nowrap>Шифокор:</td>
              <td colspan="3">
                <select name="lv" class="form-control">
                  <option></option>
                  <c:forEach items="${lvs}" var="ss">
                    <option value="${ss.id}">${ss.profil} - ${ss.fio}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold" nowrap>Телефон*:</td>
              <td colspan="3">
                <input type="text" autocomplete="off" class="form-control" name="tel" value="" required/>
              </td>
            </tr>
            <tr>
              <td class="right bold" nowrap>Паспорт маълумотлари:</td>
              <td colspan="3">
                <input type="text" autocomplete="off" class="form-control" name="passport" value=""/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveBooking()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function addBooking(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function editBooking(id) {
    $.ajax({
      url: '/booking/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          document.getElementById("modal_window").click();
          var data = res.data;
          for (var e in data) {
            try {
              document.getElementsByName(e)[0].value = data[e];
            } catch (e) {}
          }
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function removeBooking(id){
    $.ajax({
      url: '/booking/remove.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/booking/index.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveBooking() {
    if (checkForm($('#addEditForm'))) {
      $.ajax({
        url: '/booking/save.s',
        method: 'post',
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('#close-modal').click();
            alert("<ui:message code="successSave"/>");
            setPage('/booking/index.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }

  function delBooking(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/drugs/dict/delete.s',
        method: 'post',
        data: 'code=category&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/drugs/dicts.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>