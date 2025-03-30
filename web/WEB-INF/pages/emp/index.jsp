<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Сотрудники</td>
        <td class="wpx-100 text-right">
          <button class="btn btn-icon btn-success" data-toggle="modal" data-target="#myModal">
            <span class="fa fa-plus"></span>
            Добавить
          </button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
  </div>
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
              <td class="right bold">Клиент*:</td>
              <td>

              </td>
            </tr>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
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
