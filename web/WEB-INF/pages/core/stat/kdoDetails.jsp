<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addAmb() {
    setPage('/admin/addAmb.s');
  }
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список стационарных услуг
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>ID</th>
          <th>Группировка</th>
          <th>Наименование</th>
          <th>Стоимость</th>
          <th>Стоимость (Иностранцы)</th>
          <th>Реальная стоимость</th>
          <th>Реальная стоимость (Иностранцы)</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td style="vertical-align: middle" class="center">${loop.index + 1}</td>
            <td style="vertical-align: middle">${s.kdo.name}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="editDict(${s.id}, '${s.name}', '${s.price}', '${s.for_price}', '${s.real_price}', '${s.for_real_price}');return false;">${s.name}</a>
            </td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.real_price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.for_real_price}" type = "number"/></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты услуги</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td id="kdoName"></td>
            </tr>
            <tr>
              <td class="right bold">Цена (Резиденты)*:</td>
              <td>
                <input type="text" id="kdo-price" class="form-control right" name="price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Цена (Не резиденты)*:</td>
              <td>
                <input type="text" id="kdo-for-price" class="form-control right" name="for_price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Реальная стоимость*:</td>
              <td>
                <input type="text" id="kdo-real-price" class="form-control right" name="real_price" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Реальная стоимость (Иностранцы)*:</td>
              <td>
                <input type="text" id="kdo-for-real-price" class="form-control right" name="for_real_price" value=""/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveStatKdo()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function saveStatKdo() {
    if($('#kdo-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/core/stat/details.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert("<ui:message code="successSave"/>");
          setPage('/core/stat/details.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function editDict(id, name, price, for_price, real_price, for_real_price) {
    document.getElementById("modal_window").click();
    $('*[name=id]').val(id);
    $('#kdoName').html(name);
    $('*[name=price]').val(price);
    $('*[name=for_price]').val(for_price);
    $('*[name=real_price]').val(real_price);
    $('*[name=for_real_price]').val(for_real_price);
  }
</script>
