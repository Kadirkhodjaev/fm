<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Заявки по пациентам на дату <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${eat.actDate}" /></b> по типу <b>${eat.menuType.name}</b> Кол-во новых пациентов: <span class="bold">${newCount}</span>
    <button class="btn btn-xs btn-default" onclick="setPage('/head_nurse/eats.s')" style="float:right;"><i class="fa fa-arrow-left"></i> Назад</button>
    <button class="btn btn-xs btn-success" onclick="refreshPage()" style="float:right;margin-right: 5px"><i class="fa fa-refresh"></i> Обновить</button>
    <button class="btn btn-xs btn-info" onclick="printEat()" style="float:right;margin-right: 5px"><i class="fa fa-print"></i> Печать</button>
    <c:if test="${eat.state == 'ENT'}">
      <button  class="btn btn-xs btn-success" onclick="confirmEatClaim()" style="float:right;margin-right: 5px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <div class="row" style="margin:0">
      <c:forEach items="${list}" var="table">
        <div class="col-md-6">
          <div class="panel panel-default">
            <div class="panel-heading hand" data-toggle="collapse" href="#table_${table.id}">
              <h4 class="panel-title">
                ${table.name}
                <div style="float:right; color:white; background-color:green; padding:2px 6px; border-radius: 20px">${fn:length(table.patients)}</div>
                <button class="btn btn-success btn-sm" title="Обновить стол" style="height:20px;padding:1px 10px" onclick="refreshTable(${table.id})">
                  <span class="fa fa-refresh"></span>
                </button>
              </h4>
            </div>
            <div id="table_${table.id}" class="panel-collapse collapse in">
              <div class="panel-body">
                <fieldset>
                  <table class="table table-bordered miniGrid">
                    <tr>
                      <th>#</th>
                      <th>Описание</th>
                      <th style="width:40px">Удалить</th>
                    </tr>
                    <tbody>
                    <c:forEach items="${table.patients}" var="patient">
                      <tr>
                        <td align="center" title="<c:if test="${patient.dateEnd != null}">Дата выписки: ${patient.dateEnd}</c:if>">
                          <c:if test="${patient.dateEnd == null || patient.dateEnd == ''}">
                            <img src="/res/imgs/green.gif">
                          </c:if>
                          <c:if test="${patient.dateEnd != null && patient.dateEnd != ''}">
                            <img src="/res/imgs/red.gif">
                          </c:if>
                        </td>
                        <td>
                          <c:if test="${patient.ibNum == null}">
                            ${patient.fio}
                          </c:if>
                          <c:if test="${patient.ibNum != null}">
                            <a href="#" class="<c:if test="${patient.dateBegin == 'true'}">bold</c:if>" onclick="setPage('/head_nurse/eat/patient/edit.s?id=${patient.ibNum}&eat_id=${eat.id}'); return false;">${patient.fio}</a>
                          </c:if>
                        </td>
                        <td class="center">
                          <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delTableRow(${patient.id})"><i class="fa fa-minus"></i></button>
                        </td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                  <div style="float:right">
                    <button class="btn btn-sm btn-success" onclick="addTableRow(${table.id})">
                      <span class="fa fa-plus"></span> Добавить
                    </button>
                  </div>
                </fieldset>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>

<button data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="new-patient-close-btn" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Добавить строку</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="eat_id" value="${eat.id}"/>
          <input type="hidden" id="new-patient-table-id" name="table_id" value="0"/>
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Описание *:</td>
              <td>
                <input name="text" id="patient-desc" type="text" class="form-control" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Кол-во *:</td>
              <td>
                <input name="counter" id="pat-counter" type="number" class="form-control" value="1"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveEatForm()">Выполнить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  function saveEatForm() {
    if($('#patient-desc').val() == null || $('#patient-desc').val() == '' || $('#pat-counter').val() == null || $('#pat-counter').val() == '' || $('#pat-counter').val() == '0') {
      alert('Не все поля заполнены корректно! Кол-во и описание не можут быть пустыми и кол-во должно быть больше 0');
      return;
    }
    $.ajax({
      url: '/head_nurse/eat/patient/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#new-patient-close-btn').click();
          alert('Данные успешно сохранены');
          setPage('/head_nurse/eat.s?id=${eat.id}');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function addTableRow(id) {
    $('#new-patient-table-id').val(id);
    $('#modal_window').click();
  }
  function refreshPage() {
    if(confirm('Вы действительно обновить данные? Все измененные данные будут потерены!!!')) {
      $.ajax({
        url: '/head_nurse/eat/refresh.s',
        data: 'id=${eat.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/head_nurse/eat.s?id=${eat.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function confirmEatClaim() {
    if(confirm('Вы действительно хотите подтвердить Заявку?')) {
      $.ajax({
        url: '/head_nurse/eat/confirm.s',
        data: 'id=${eat.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/head_nurse/eat.s?id=${eat.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function delTableRow(id) {
    if(confirm('Вы действительно хотите удалить запись?')) {
      $.ajax({
        url: '/head_nurse/eat/patient/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/head_nurse/eat.s?id=${eat.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function refreshTable(table) {
    if(confirm('Вы действительно обновить стол? Все измененные данные по столу будут потерены!!!')) {
      $.ajax({
        url: '/head_nurse/eat/table/refresh.s',
        data: 'id=' + table + '&eat=${eat.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/head_nurse/eat.s?id=${eat.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function printEat() {
    alert('Клиникани фирменный бланкаси буйича формани берсез печатьная формани кибераман')
  }
</script>
