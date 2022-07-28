<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="row" style="margin:0">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading">
        Меню на <span style="font-weight:bold; color:red"><fmt:formatDate pattern="dd.MM.yyyy" value="${menu.menuDate}"/></span>
        <c:if test="${menu.state == 'ENT'}">
          <button  class="btn btn-sm btn-success" onclick="confirmEatMenu()" style="float:right;margin-top:-5px"><i class="fa fa-check"></i> Подтвердить</button>
        </c:if>
      </div>
      <!-- .panel-heading -->
      <div class="panel-body">
        <div class="panel-group" id="accordion">
          <c:forEach items="${menuTypes}" var="menuType" varStatus="menuLoop">
            <div class="panel panel-default">
              <div class="panel-heading hand" data-toggle="collapse" data-parent="#accordion" href="#collapse_${menuLoop.index}">
                <h4 class="panel-title">
                  ${menuType.name}
                </h4>
              </div>
              <div id="collapse_${menuLoop.index}" class="panel-collapse collapse <c:if test="${menuLoop.index == 0}">in</c:if>">
                <div class="panel-body">
                  <table class="table table-bordered miniGrid">
                    <c:forEach items="${menuType.tables}" var="table" varStatus="loop">
                      <tr>
                        <th class="bold center" style="width:50%">
                            ${table.name}
                            <span id="btns-${menuType.id}-${table.id}">
                              <button  class="btn btn-sm btn-success" title="Сохранить как шаблон" onclick="saveTableTemplate(${menuType.id}, ${table.id})" style="float:right; height:20px;padding:1px 10px;margin-left:5px"><i class="fa fa-save"></i></button>
                            </span>
                            <c:if test="${menu.state == 'ENT'}">
                              <button  class="btn btn-sm btn-default" title="Данные из шаблона" onclick="openTemplates(${menuType.id}, ${table.id})" style="float:right; height:20px;padding:1px 10px;margin-left:5px"><i class="fa fa-arrow-down"></i></button>
                            </c:if>
                            <button  class="btn btn-sm btn-info" title="Копировать меню" onclick="setCopyMenu(${table.id}, '${table.name}', '${menuType.name}', ${menuType.id})" style="float:right; height:20px;padding:1px 10px;margin-left:5px"><i class="fa fa-copy"></i></button>
                            <button  class="btn btn-sm btn-primary" title="Сформировать меню" onclick="setTableMenu(${table.id}, '${table.name}', '${menuType.name}', ${menuType.id})" style="float:right; height:20px;padding:1px 10px;"><i class="fa fa-pencil"></i></button>
                        </th>
                      </tr>
                      <tr>
                        <td>
                          <table class="table table-bordered miniGrid" style="margin-bottom:0" id="menu-table-row-${menuType.id}-${table.id}">
                          <c:forEach items="${table.eats}" var="eat" varStatus="eatLoop">
                            <tr id="menu-row-${eat.rowId}">
                              <td>${eat.name}</td>
                              <c:if test="${menu.state == 'ENT'}">
                                <td class="center" style="width:40px">
                                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" onclick="removeEatRow(${eat.rowId}, ${menuType.id}, ${table.id})" title="Удалить"><i class="fa fa-minus"></i></button>
                                </td>
                              </c:if>
                            </tr>
                          </c:forEach>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td style="border-top:2px solid #ababab; padding:5px"></td>
                      </tr>
                    </c:forEach>
                  </table>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
      <!-- .panel-body -->
    </div>
    <!-- /.panel -->
  </div>
  <!-- /.col-lg-12 -->
</div>

<button data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1100px; height:calc(100% - 50px); overflow: hidden">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" id="close-modal" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">
          Выбор нужных блюд на <fmt:formatDate pattern="dd.MM.yyyy" value="${menu.menuDate}"/> на <span class="bold" id="menu-type-name"></span>
        </h4>
      </div>
      <div class="modal-body">
        <div class="row" style="margin:0">
          <div class="col-lg-5">
            <div class="panel panel-primary">
              <div class="panel-heading">
                Cтол: <span class="bold" id="table-name"></span>
                <button class="btn btn-sm btn-success" onclick="saveTableEats()" style="float:right;margin-top:-5px"><i class="fa fa-check"></i> Сохранить</button>
              </div>
              <!-- .panel-heading -->
              <div class="panel-body">
                <table class="table table-bordered miniGrid" id="menu-eat-list">
                </table>
              </div>
            </div>
          </div>
          <div class="col-lg-7">
            <div class="panel panel-primary">
              <div class="panel-heading">
                <input type="text" placeholder="Поиск блюд" onkeyup="filterEat(this)" class="form-control" style="font-size: 16px; width:400px" id="drug-list-filter" value="">
              </div>
              <div class="panel-body" style="height:400px; overflow:auto;">
                <div class="panel-group" id="menu_eats">
                  <c:forEach items="${eats}" varStatus="loop" var="eat">
                    <div class="panel panel-default">
                      <div class="panel-heading hand" data-toggle="collapse" data-parent="#menu_eats" href="#menu_eat_${loop.index}">
                        <h4 class="panel-title">
                          ${eat.c1}
                          <div style="float:right; color:white; background-color:#c9302c; padding:2px 6px; border-radius: 20px">${fn:length(eat.list)}</div>
                        </h4>
                      </div>
                      <div id="menu_eat_${loop.index}" class="panel-collapse collapse <c:if test="${loop.index == 0}">in</c:if>">
                        <div class="panel-body">
                          <table class="table table-bordered miniGrid">
                            <c:forEach items="${eat.list}" var="ee">
                             <tr>
                               <td class="center" style="width:60px">
                                 <button class="btn btn-success btn-sm" onclick="addTableEat(${ee.c1}, '${ee.c2}')" style="height:20px;padding:1px 10px">
                                   <i class="fa fa-check"></i>
                                 </button>
                               </td>
                               <td>${ee.c2}</td>
                             </tr>
                            </c:forEach>
                          </table>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<button data-toggle="modal" data-target="#templateSaveModal" id="templateSaveModal_window" class="hidden"></button>
<div class="modal fade" id="templateSaveModal" tabindex="-1" role="dialog" aria-labelledby="templateSaveModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" id="templateSaveModal-close" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="templateSaveModalLabel">
          Выбирите название для шаблона
        </h4>
      </div>
      <div class="modal-body">
        <div class="row" style="margin:0">
          <div class="form-group">
            <label class="control-label hidden" for="template-name-input">Обязательное поле</label>
            <input type="text" class="form-control" id="template-name-input" style="padding:10px 6px;font-size: 14px" value="" placeholder="Название шаблона"/>
          </div>
        </div>
        <div class="row" style="margin:0">
          <table class="table table-bordered">
            <c:forEach items="${tables}" var="tb">
              <tr>
                <td>${tb.name}</td>
              </tr>
            </c:forEach>
          </table>
        </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="sendTableTemplate()">Сохранить</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<button data-toggle="modal" data-target="#copyEatModal" id="copyEatModal_window" class="hidden"></button>
<div class="modal fade" id="copyEatModal" tabindex="-1" role="dialog" aria-labelledby="copyEatModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" id="copyEatModal-close" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="copyEatModalLabel">
          Столы для копирования
        </h4>
      </div>
      <div class="modal-body">
        <div class="row" style="margin:0">
          <table class="table table-bordered" style="cursor: pointer">
            <c:forEach items="${tables}" var="tb">
              <tr id="copy-eat-${tb.id}" class="copy-eat">
                <td style="width:30px; text-align: center;"><input type="checkbox" name="table_id" value="${tb.id}"> </td>
                <td>${tb.name}</td>
              </tr>
            </c:forEach>
          </table>
        </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="copyEatSave()">Сохранить</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<button data-toggle="modal" data-target="#templateModal" id="templateModal_window" class="hidden"></button>
<div class="modal fade" id="templateModal" tabindex="-1" role="dialog" aria-labelledby="templateModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1100px; height:700px; overflow: hidden">
    <div class="modal-content" id="templates-content">
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  var eatRows = [];
  <c:forEach items="${menuTypes}" var="menuType">
    <c:forEach items="${menuType.tables}" var="table" varStatus="loop">
      var jsonRows = ${table.eatJson};
      eatRows.push({id: '${menuType.id}_${table.id}', data: jsonRows});
      if(jsonRows.length > 0)
        $('#btns-${menuType.id}-${table.id}').show();
      else
        $('#btns-${menuType.id}-${table.id}').hide();
    </c:forEach>
  </c:forEach>
  var tableEats = [], menuTypeId = 0, tableId = 0;

  function setTableMenu(id, name, menuType, typeId) {
    tableEats = eatRows.filter(obj => obj.id === typeId + '_' + id)[0].data;;
    $('#menu-type-name').html(menuType);
    $('#table-name').html(name);
    menuTypeId = typeId;
    tableId = id;
    buildMenuRows();
    $('#modal_window').click();
  }

  function setCopyMenu(id, name, menuType, typeId) {
    $('.copy-eat').show();
    $("#copy-eat-" + id).hide();
    tableId = id;
    menuTypeId = typeId;
    $('#copyEatModal_window').click();
  }
  function copyEatSave() {
    var form = $('<form id="table_form_saver"></form>');
    var menu = $('<input name="menu" value="${menu.id}"/>');
    var menuType = $('<input name="menu_type" value="' + menuTypeId + '"/>');
    var table = $('<input name="table" value="' + tableId + '"/>');
    form.append(menu).append(menuType).append(table);
    $('.copy-eat').each((idx, obj) => {
      var elem = $(obj).find('input');
      if($(elem).is(':checked')) {
        var input = $('<input name="id" value="' + elem.val() + '"/>');
        form.append(input);
      }
    });
    $.ajax({
      url: '/eats/menu/copy/eat.s',
      method: 'post',
      data: form.serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          $('#copyEatModal').click();
          for(var rr of res.ids) {
            updateTypeTableRow(menuTypeId, rr);
          }
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function removeTableEat(id) {
    tableEats = tableEats.filter(obj => obj.id !== id);
    buildMenuRows();
  }
  function addTableEat(id, name) {
    var flt = tableEats.filter(obj => obj.id === id);
    if(flt.length > 0) {
      if(!confirm('Выбранное питание уже существует в меню. Вы действительно хотите добавить еще раз?')) {
        return;
      }
    }
    tableEats.push({id: id, name: name});
    buildMenuRows();
  }
  function buildMenuRows() {
    $('#menu-eat-list').html('');
    tableEats.forEach(obj => {
      var tr = $('<tr class="menu-eat-list-' + obj.id + '"></tr>');
      var td1 = $('<td>' + obj.name + '</td>');
      var td2 = $('<td class="center" style="width:40px"></td>');
      var rBtn = $('<button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить"><i class="fa fa-minus"></i></button>');
      rBtn.click(function(){
        removeTableEat(obj.id);
      });
      td2.append(rBtn);
      tr.append(td1).append(td2);
      $('#menu-eat-list').append(tr);
    });
  }
  function saveTableEats(){
    var form = $('<form id="table_form_saver"></form>');
    var menu = $('<input name="menu" value="${menu.id}"/>');
    var menuType = $('<input name="menu_type" value="' + menuTypeId + '"/>');
    var table = $('<input name="table" value="' + tableId + '"/>');
    form.append(menu).append(menuType).append(table);
    tableEats.forEach((obj) => {
      var input = $('<input name="id" value="' + obj.id + '"/>');
      form.append(input);
    });
    $.ajax({
      url: '/eats/menu/table/save.s',
      method: 'post',
      data: form.serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          $('#close-modal').click();
          updateTypeTableRow(menuTypeId, tableId);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function updateTypeTableRow(mtId, tbId) {
    $.ajax({
      url: '/eats/menu/table/eats/get.s',
      method: 'post',
      data: 'menu=${menu.id}&table=' + tbId + '&menuType=' + mtId,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          buildMenuTableRow(mtId, tbId, res.list);
          if(res.list.length > 0)
            $('#btns-' + mtId + '-' + tbId).show();
          else
            $('#btns-' + mtId + '-' + tbId).hide();
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function removeEatRow(id, mtId, tbId) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/eats/menu/table/row/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            updateTypeTableRow(mtId, tbId);
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function buildMenuTableRow(mtId, tbId, rows) {
    $('#menu-table-row-' + mtId + '-' + tbId).html('');
    eatRows.forEach((obj, idx) => {
      if(obj.id === mtId +'_' + tbId) {
        eatRows[idx].data = rows;
      }
    });
    rows.forEach(obj => {
      var tr = $('<tr id="menu-row-' + obj.row_id + '"></tr>');
      var td1 = $('<td>' + obj.name + '</td>');
      var td2 = $('<td class="center" style="width:40px"></td>');
      var btn = $('<button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить"><i class="fa fa-minus"></i></button>');
      btn.click(function(){
        removeEatRow(obj.row_id, mtId, tbId);
      });
      td2.append(btn);
      tr.append(td1).append(td2);
      $('#menu-table-row-' + mtId + '-' + tbId).append(tr);
    });
  }
  function filterEat(dom) {
    if(dom.value.length === 0 || dom.value.length > 2) {
      $('#menu_eats').html('');
      $.ajax({
        url: '/eats/eat/filter.s',
        method: 'post',
        data: 'filter=' + dom.value,
        dataType: 'html',
        success: function (res) {
          $('#menu_eats').append($(res));
        }
      });
    }
  }
  function saveTableTemplate(mtId, tbId) {
    menuTypeId = mtId;
    tableId = tbId;
    $('#template-name-input').parent().removeClass('has-error');
    $('#template-name-input').parent().find('label').addClass('hidden');
    $('#templateSaveModal_window').click();
  }
  function sendTableTemplate() {
    if($('#template-name-input').val().length == 0) {
      $('#template-name-input').parent().addClass('has-error');
      $('#template-name-input').parent().find('label').removeClass('hidden');
      return;
    }
    var ids = '';
    var rs = eatRows.filter(obj => obj.id === menuTypeId +'_' + tableId);
    rs[0].data.forEach(obj => {
      ids += 'id=' + obj.id + '&';
    });
    $.ajax({
      url: '/eats/template/save.s',
      method: 'post',
      data: 'menu_type=' + menuTypeId + '&table=' + tableId + '&' + ids + 'name=' + encodeURIComponent($('#template-name-input').val()),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          $('#templateSaveModal-close').click();
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function openTemplates(mt, tbId) {
    $('#templates-content').html('');
    $.ajax({
      url: '/eats/templates.s',
      data: 'type=' + mt + '&table=' + tbId,
      method: 'post',
      dataType: 'html',
      success: function (res) {
        $('#templates-content').append($(res));
        $('#templateModal_window').click();
      }
    });
  }
  function copyTemplate(tempId){
    if(confirm('Вы действительно хотите выбрать данный шаблон?')) {
      $.ajax({
        url: '/eats/template/set.s',
        data: 'menu=${menu.id}&id=' + tempId,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            $('#templateModal-close').click();
            updateTypeTableRow(res.mtId, res.tbId);
          } else
            alert(res.msg);
        }
      });
    }
  }
  function confirmEatMenu() {
    if(confirm('Вы действительно хотите подтвердить Меню. После подтверждения нельзя изменить данные?')) {
      $.ajax({
        url: '/eats/menu/confirm.s',
        data: 'id=${menu.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/eats/menu.s');
          } else
            alert(res.msg);
        }
      });
    }
  }
</script>