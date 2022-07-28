<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
  .hover-color {background: #ababab;}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <table style="width:100%">
      <tr>
        <td>Реестр препаратов</td>
        <td class="right">Категория: </td>
        <td style="width:200px">
          <select class="form-control" onchange="setPageCat(this)">
            <option value="0">Все</option>
            <c:forEach items="${categories}" var="cat">
              <option <c:if test="${ct == cat.id}">selected</c:if> value="${cat.id}">${cat.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Категория</th>
          <th>Наименование</th>
          <th>Количественный учет</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr id="link_${loop.index + 1}" ondblclick="editDrug(${obj.c1})" class="<c:if test="${link == loop.index + 1}">hover-color</c:if>">
            <td align="center">${loop.index + 1}</td>
            <td align="center">${obj.c5}</td>
            <td>${obj.c2}</td>
            <td align="center" id="res_${obj.c1}">${obj.c3}</td>
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
  <div class="modal-dialog" style="width:1000px">
    <div class="modal-content" >
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты препарата</h4>
      </div>
      <div class="modal-body" id="drug_content"></div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function editDrug(id) {
    $('#drug_content').load('/head_nurse/dicts/drug/info.s?id=' + id, () => {
      document.getElementById("modal_window").click();
    });
  }
  function setPageCat(dom) {
    setPage('/head_nurse/dicts.s?cat=' + dom.value);
  }
</script>