<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<link rel="stylesheet" href="/res/jstree/theme/default/style.min.css" />
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<style>
  .jstree-default a {
    white-space:normal !important; height: auto;
  }
  .jstree-anchor {
    height: auto !important;
  }
  .jstree-default li > ins {
    vertical-align:top;
  }
  .jstree-leaf {
    height: auto;
  }
  .jstree-leaf a{
    height: auto !important;
  }
</style>
<table style="width:100%; height:100%">
  <tr>
    <td colspan="2" style="text-align:center; vertical-align: middle; font-weight:bold; font-size:20px;height:50px;">
      Международная классификация болезней
    </td>
  </tr>
  <tr>
    <td style="height:1px; vertical-align: bottom;padding:0 10px;" colspan="2">
      <div class="input-group" style="width:100%">
        <span class="input-group-addon"><span class="fa fa-th-list"></span></span>
        <input type="text" id="ricerca-enti" style="height:30px !important;" class="form-control" placeholder="Поиск по тексту" aria-describedby="search-addon">
        <span class="input-group-addon" id="search-addon"><span class="fa fa-search"></span></span>
      </div>
    </td>
  </tr>
  <tr>
    <td style="width:70%; max-width:70%; vertical-align:top; padding:0 10px; border-right:2px solid #e8e8e8">
      <div style="width:100%" id="container-albero">
        <div id="test"></div>
      </div>
    </td>
    <td style="width:30%;vertical-align:top; padding:10px">
      <div style="font-weight:bold;padding:5px;">
        Кодовые обозначение
      </div>
      <div id="node-code">

      </div>
      <div id="node-info" style="display: none;">
        <div id="node-info-label" style="font-weight:bold;padding:5px;">
          Информация:
        </div>
        <div id="node-info-text" style="text-align:justify">

        </div>
      </div>
    </td>
  </tr>
</table>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
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
          <input type="hidden" name="parent_id" id="parent_id" value="" />
          <table class="table table-bordered">
            <tr>
              <td class="bold" colspan="2">Код*:</td>
            </tr>
            <tr>
              <td colspan="2">
                <input type="text" class="form-control" name="code" value=""/>
              </td>
            </tr>
            <tr>
              <td class="bold" colspan="2">Наименование*:</td>
            </tr>
            <tr>
              <td colspan="2">
                <input type="text" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="bold" colspan="2">Описание диагноза*:</td>
            </tr>
            <tr>
              <td colspan="2">
                <textarea class="form-control" name="name" rows="20"></textarea>
              </td>
            </tr>
            <tr>
              <td class="right bold" style="width:100px">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveItem()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script src="/res/bs/jquery/jquery.min.js"></script>
<script src="/res/jstree/jstree.min.js"></script>
<script>
  let elems = ${mkb};
  var to = false;
  $('#ricerca-enti').keyup(function() {
    if (to) {
      clearTimeout(to);
    }
    to = setTimeout(function() {
      var v = $('#ricerca-enti').val();
      if(v.length > 3) {
        $('#test').jstree(true).search(v);
      }
    }, 500);
  });
  $(document).ready(function() {
    $("#test").on("changed.jstree", function(e, data) {
      try {
        $('#node-info').toggle(data.node.original.info !== undefined);
        $('#node-info-text').text(data.node.original.info == undefined ? '' : data.node.original.info);
        $('#node-code').text(data.node.original.code);
      } catch (e){}
    }).jstree({
      checkbox: {
        three_state: false
      },
      contextmenu: {
        items: function($node) {
          return {
            createItem : {
              "label" : "Добавить",
              "action" : function(obj) {
                var id = obj.reference.prevObject.selector.replace('#padre', '');
                addItem(id);
              }
            },
            renameItem : {
              "label" : "Редактировать",
              "action" : function(obj) {
                var id = obj.reference.prevObject.selector.replace('#padre', '');
                editItem(id);
              }
            },
            deleteItem : {
              "label" : "Удалить",
              "action" : function(obj) {
                var id = obj.reference.prevObject.selector.replace('#padre', '');
                delItem(id);
              }
            }
          };
        }
      },
      plugins: ['search', 'changed', 'checkbox', 'contextmenu'],
      search: {
        show_only_matches: true,
        tie_selection: false,
        undetermined: true
      },
      core: {data: elems}
    });
    $("#test").on("dblclick.jstree", function (event) {
      var node = $(event.target).closest("li");
      if (node.find('li').length == 0) {
        //opener.setMkb(node[0].innerText, node.attr('id').replace('padre', ''));
      }
    });
  });
  function addItem(id) {
    addEditForm.reset();
    document.getElementById("parent_id").value = id;
    $('*[name=state]').prop('checked', true);
    document.getElementById("modal_window").click();
  }
  function editItem(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/mkb/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(id);
          $('*[name=code]').val(res.code);
          $('*[name=name]').val(res.name);
          $('*[name=info]').val(res.info);
          $('*[name=state]').prop('checked', res.state === 'A');
        } else {
          alert(res.msg);
        }
      }
    });
  }

  function delItem(pid) {
    if(confirm('Дейтвительно хотите удалить?'))
      $.ajax({
        url: '/mkb/del.s',
        method: 'post',
        data: 'id=' + pid,
        dataType: 'json',
        success: function (res) {
          console.log(pid)
          if (res.success) {
            for(let i = 0; i < elems.length; i++) {
              if(elems[i].id === 'padre' + pid) {
                elems.splice(i, 1);
                break;
              }
            }
            $('*[name=id]').val(pid);
            $('*[name=name]').val(res.name);
            $('*[name=info]').val(res.info);
            $('*[name=state]').prop('checked', res.state == 'A');
            $('#test').jstree(true).settings.core.data = elems;
            $('#test').jstree(true).refresh();
          } else {
            alert(res.msg);
          }
        }
      });
  }
  function saveItem() {
    $.ajax({
      url: '/mkb/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/mkb/admin.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>
