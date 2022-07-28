<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    ${service.c3} - ${service.c2}
    <button  class="btn btn-sm btn-success" type="button" onclick="newProductRow()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i></button>
  </div>
  <div class="panel-body">
    <form id="addEditForm" name="addEditForm">
      <input type="hidden" name="id" value="${service.c1}"/>
      <input type="hidden" name="type" value="${service.c4}">
      <table class="table table-bordered miniGrid" id="service-norms">
        <tr>
          <th>Товар</th>
          <th style="width:250px">Расход</th>
          <th style="width:250px">Единица измерения</th>
          <th style="width:100px">Удалить</th>
        </tr>
        <tbody>
          <c:forEach items="${norms}" var="norm" varStatus="loop">
            <tr>
              <td>
                <input type="hidden" name="norm_id" value="${norm.id}">
                <select class="form-control" name="product" onchange="buildMeasureOptions(this)">
                  <c:forEach items="${products}" var="product">
                    <option <c:if test="${product.id == norm.product.id}">selected</c:if> value="${product.id}" data-cat="${product.measureType.id}">${product.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td>
                <input type="text" class="form-control right" name="rasxod" value="${norm.rasxod}">
              </td>
              <td>
                <select class="form-control" name="measure">
                  <c:forEach items="${measures}" var="measure">
                    <c:if test="${measure.cat.id == norm.measure.cat.id}">
                      <option <c:if test="${measure.id == norm.measure.id}">selected</c:if> value="${measure.id}">${measure.name}</option>
                    </c:if>
                  </c:forEach>
                </select>
              </td>
              <td class="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" type="button" title="Удалить" onclick="delExpNormRow(${norm.id}, this)"><i class="fa fa-minus"></i></button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>
    <table id="rasxod-row" class="hidden">
      <tr>
        <td>
          <input type="hidden" name="norm_id" value="0">
          <select class="form-control" name="product" onchange="buildMeasureOptions(this)">
            <c:forEach items="${products}" var="product">
              <option value="${product.id}" data-cat="${product.measureType.id}">${product.name}</option>
            </c:forEach>
          </select>
        </td>
        <td>
          <input type="text" class="form-control right" name="rasxod" value="0">
        </td>
        <td>
          <select class="form-control" name="measure">
          </select>
        </td>
        <td class="center">
          <button class="btn btn-danger btn-sm" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick="delExpNormRow(0, this)"><i class="fa fa-minus"></i></button>
        </td>
      </tr>
    </table>
    <div class="modal-footer">
      <button type="button" class="btn btn-primary" onclick="saveExpForm()">Сохранить</button>
      <button type="button" class="btn btn-default" onclick="$('#pager').load('/exp/dict/services.s');">Назад</button>
    </div>
  </div>
  <!-- /.panel-body -->
</div>
<script>
  var opts = [];
  <c:forEach items="${measures}" var="measure">
    opts.push({id:${measure.id}, name: '${measure.name}', type: '${measure.cat.id}'});
  </c:forEach>

  function saveExpForm() {
    $.ajax({
      url: '/exp/dict/service/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("Данные успешно сохранены");
          $('#pager').load('/eats/dict/eat/addEdit.s?id=' + res.id);
        } else {
          alert(res.msg);
        }
      }
    });
  }

  function newProductRow(){
    var html = $('#rasxod-row').html();
    $('#service-norms').append(html);
    checkMeasures();
  }
  function checkMeasures() {
    $('*[name=product]').each((idx, obj) => {
      buildMeasureOptions(obj);
    });
  }
  function buildMeasureOptions(dom) {
    var ops = opts.filter(obj => obj.type === dom.options[dom.selectedIndex].getAttribute("data-cat"));
    var measure = $(dom).parent().parent().find('*[name=measure]');
    measure.html('');
    ops.forEach(obj => {
      measure.append($("<option value='" + obj.id + "' data-cat='" + obj.type + "'>" + obj.name + "</option>"));
    });
  }
  function delExpNormRow(id, btn){
    if(id == 0) {
      $(btn).parent().parent().remove();
    } else {
      $.ajax({
        url: '/exp/dict/delete.s',
        method: 'post',
        data: 'code=norm&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно удалены");
            $(btn).parent().parent().remove();
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  checkMeasures();
</script>