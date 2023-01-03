<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Ввод начального сальдо
    <c:if test="${false}">
      <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
      <button  class="btn btn-sm btn-success" onclick="addDrugDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Цена за единицу</th>
          <th>Кол-во</th>
          <th>Расход</th>
          <th>Остаток</th>
          <c:if test="${false}">
            <th style="width:40px">Удалить</th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr>
            <td align="center">${loop.index + 1}</td>
            <td>
              <a href="#" onclick="editDrugDict(${obj.id});return false">${obj.drug.name}</a>
            </td>
            <td align="right"><fmt:formatNumber value="${obj.price}" type="number"/></td>
            <td align="center"><fmt:formatNumber value="${obj.drugCount}" type="number"/></td>
            <td align="center"><fmt:formatNumber value="${obj.rasxod}" type="number"/></td>
            <td align="center"><fmt:formatNumber value="${obj.drugCount - obj.rasxod}" type="number"/></td>
            <c:if test="${false}">
              <td class="center">
                <c:if test="${obj.rasxod == 0}">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${obj.id})"><i class="fa fa-minus"></i></button>
                </c:if>
              </td>
            </c:if>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты кетогорий</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="category" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <select name="drug" class="form-control" >
                  <c:forEach items="${drugs}" var="cc">
                    <option value="${cc.id}">${cc.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td width="10">
                <span data-toggle="modal" data-target="#newModal" class="fa fa-plus hand" title="Добавить новое наименование в реестр" style="position:relative; top:3px"></span>
              </td>
            </tr>
            <tr>
              <td class="right bold">Количество*:</td>
              <td class="left" colspan="2">
                <input class="form-control right" type="number" name="count" value="0"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Цена*:</td>
              <td class="left" colspan="2">
                <input class="form-control right" type="number" name="price" value="0"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveDrugForm()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="newModal" tabindex="-1" role="dialog" aria-labelledby="newModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="newModalLabel">Реквизиты препарата</h4>
      </div>
      <div class="modal-body">
        <form id="new-drug-form">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="drug" />
          <input type="hidden" name="state" value="Y" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Кетегория*:</td>
              <td>
                <select class="form-control" name="category">
                  <c:forEach items="${categories}" var="category">
                    <option value="${category.id}">${category.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="drug-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveDrugFormNew()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-new-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>
<script>
  function addDrugDict(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function editDrugDict(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/drugs/dict/get.s',
      method: 'post',
      data: 'code=saldo&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=drug]').val(res.drug);
          $('*[name=count]').val(res.count);
          $('*[name=price]').val(res.price);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    $.ajax({
      url: '/drugs/saldo/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setLocation("main.s");
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function delDrugRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/drugs/saldo/delete.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/drugs/sklad.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function saveDrugFormNew() {
    if($('#drug-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/drugs/dict/save.s',
      method: 'post',
      data: $('#new-drug-form').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('select[name=drug]').each(function (elem, dom) {
            var options = dom.options;
            dom.options[options.length] = new Option(res.name, res.id);
            $(this).val(res.id);
            $(this).trigger('liszt:updated');
            document.getElementById("close-new-modal").click();
          });
          document.getElementById('new-drug-form').reset();
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>
