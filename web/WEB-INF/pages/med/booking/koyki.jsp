<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<script>
  function setVypDate(date) {
    setPage('/booking/koyki.s?vypDate=' + date);
  }
  function setEmptyDate(date) {
    setPage('/booking/koyki.s?emptyDate=' + date);
  }
</script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<div style="padding:10px"></div>
<div class="row" style="margin: 0">
  <div class="col-lg-3">
    <div class="panel panel-info">
      <div class="panel-heading">
        <div class="row">
          <div class="col-xs-6">
            <i class="fa fa-users fa-5x"></i>
          </div>
          <div class="col-xs-6 text-right">
            <p class="announcement-heading" style="font-size:50px">${cur}</p>
          </div>
        </div>
      </div>
      <a href="#" onclick="return false;">
        <div class="panel-footer announcement-bottom">
          <div class="row">
            <div class="col-xs-12">
              Кол-во пациентов
            </div>
          </div>
        </div>
      </a>
    </div>
  </div>
  <div class="col-lg-3">
    <div class="panel panel-success">
      <div class="panel-heading">
        <div class="row">
          <div class="col-xs-6">
            <i class="fa fa-users fa-5x"></i>
          </div>
          <div class="col-xs-6 text-right">
            <p class="announcement-heading" style="font-size:50px">${vyp}</p>
          </div>
        </div>
      </div>
      <a href="#" onclick="return false;">
        <div class="panel-footer announcement-bottom" style="padding-top:5px; padding-bottom: 6px">
          <div class="row">
            <div class="col-xs-12">
              <table width="100%">
                <tr>
                  <td>Выписка</td>
                  <td style="width:125px"><input id="period_end" onchange="setVypDate(this.value)" type="text" class="form-control datepicker" value="${vypDate}"/></td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </a>
    </div>
  </div>
  <div class="col-lg-3">
    <div class="panel panel-green">
      <div class="panel-heading">
        <div class="row">
          <div class="col-xs-6">
            <i class="fa fa-users fa-5x"></i>
          </div>
          <div class="col-xs-6 text-right">
            <p class="announcement-heading" style="font-size:50px">${emptyCount}</p>
          </div>
        </div>
      </div>
      <a href="#" onclick="return false;">
        <div class="panel-footer announcement-bottom" style="padding-top:5px; padding-bottom: 6px">
          <div class="row">
            <div class="col-xs-12">
              <table width="100%">
                <tr>
                  <td>Cвободно</td>
                  <td style="width:125px"><input id="period_ends" onchange="setEmptyDate(this.value)" type="text" class="form-control datepicker" value="${emptyDate}"/></td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </a>
    </div>
  </div>
  <div class="col-lg-3">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-xs-6">
            <i class="fa fa-users fa-5x"></i>
          </div>
          <div class="col-xs-6 text-right">
            <p class="announcement-heading" style="font-size:50px">${koekCount}</p>
          </div>
        </div>
      </div>
      <a href="#" onclick="return false;">
        <div class="panel-footer announcement-bottom">
          <div class="row">
            <div class="col-xs-12">
              Свободных коек
            </div>
          </div>
        </div>
      </a>
    </div>
  </div>
</div>
<c:forEach items="${stages}" var="stage">
  <div class="panel panel-default noselect">
    <div class="panel-heading bold center" style="padding:3px">
      <span class="text-danger" style="font-size:20px">${stage.name}</span>
    </div>
    <div class="panel-body">
      <c:forEach items="${stage.rooms}" var="room" varStatus="loop">
        <c:if test="${room.next_tr == 'Y'}">
          <c:if test="${loop.index > 0}"></div></c:if>
          <div class="row">
        </c:if>
        <div class="col-lg-3" style="padding-right:5px; padding-left:5px;">
          <div class="panel panel-default">
            <div class="panel-heading center bold" style="padding: 0">
              ${room.num} - ${room.type}
              <c:if test="${room.state == 'A'}">
                <span class="fa fa-plus hand" style="float:right; margin-top:2px; margin-right:5px" onclick="addBooking(${room.id})"></span>
              </c:if>
            </div>
            <div class="panel-body" style="<c:if test="${fn:length(room.patients) > 0}">padding: 0</c:if>">
              <c:if test="${room.state == 'A'}">
                <c:if test="${fn:length(room.patients) > 0}">
                  <table style="width:100%;font-size:10px" class="table-bordered">
                    <tr>
                      <td class="center bold">&nbsp;</td>
                      <td class="center bold" nowrap>ИБ №</td>
                      <td class="center bold">ФИО</td>
                      <td class="center bold">Рег</td>
                      <td class="center bold">Выписка</td>
                    </tr>
                    <c:forEach items="${room.patients}" var="patient">
                      <tr class="hover hand">
                        <td class="center">
                          <c:if test="${patient.c2 == 'cr'}">
                            <img src="/res/imgs/green.gif">
                          </c:if>
                          <c:if test="${patient.c2 == 'bk'}">
                            <img src="/res/imgs/yellow.gif">
                          </c:if>
                          <c:if test="${patient.c2 == 'ux'}">
                            <img src="/res/imgs/red.gif">
                          </c:if>
                        </td>
                        <td class="center">
                            ${patient.ib}
                        </td>
                        <td>
                            ${patient.fio}
                        </td>
                        <td class="center">
                            ${patient.date}
                        </td>
                        <td class="center">
                            ${patient.c1}
                        </td>
                      </tr>
                    </c:forEach>
                  </table>
                </c:if>
              </c:if>
              <c:if test="${room.state != 'A'}">
                <div class="center bold" style="color:red">Палата временно не функционирует</div>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>
      </div>
    </div>
  </div>
</c:forEach>
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
  function addBooking(id){
    addEditForm.reset();
    document.getElementById("modal_window").click();
    document.getElementsByName('room')[0].value = id;
  }
  function editBooking(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/booking/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
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