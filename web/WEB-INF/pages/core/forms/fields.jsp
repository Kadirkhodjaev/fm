<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function removeElem(dom, fieldId){
    $.ajax({
      url: '/core/form/fields/removeVal.s',
      method: 'post',
      data: 'fieldId=' + fieldId + '&id=' + dom.value,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success)
          for(var i=0;i<dom.options.length;i++)
            if(dom.value == dom.options[i].value)
              dom.options[i] = null;
      }
    });
  }
  function addVal(fieldId) {
    $('#myModal').load('/core/form/fields/vals.s?fieldId=' + fieldId);
    $('#modalBtn').click();
  }
  function saveVal(id){
    $.ajax({
      url: '/core/form/fields/upd.s',
      method: 'post',
      data: 'id='+id+'&' + $('#form'+id).serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(!res.success) setLocation('/main.s');
      }
    });
  }
  function addField(){
    let dom = $('input[name=field]');
    if(dom.val().length > 0) {
      $.ajax({
        url: '/core/form/fields/add.s',
        method: 'post',
        data: 'formId=${form.id}&field=' + dom.val(),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setLocation('/main.s');
        }
      });
    }
  }
  function setFieldType(formId, val) {
    if(val == 'textarea')
       $('#form' + formId + ' * input[name=maxLength]').val('255');
    if(val == 'text')
      $('#form' + formId + ' * input[name=maxLength]').val('32');
  }
  function removeField(id) {
    $.ajax({
      url: '/core/form/removeField.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setLocation('/main.s');
      }
    });
  }
  $(document).ready(function(){
    $('#addField').focus();
  });
</script>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" style="display: none;"></div>
<button data-toggle="modal" data-target="#myModal" style="display: none" id="modalBtn"></button>
<div id="frm"></div>
<div class="panel panel-info">
  <div class="panel-heading">Список полей формы - ${form.name}</div>
  <div class="panel-body">
    <div class="table-responsive">
      <div class="table-responsive">
      </div>
        <table style="width:400px">
          <tr>
            <td>Наименование:</td>
            <td><input class="form-control" type="text" name="field" id="addField"/></td>
            <td>&nbsp;</td>
            <td><a href="#" onclick="addField()" class="btn btn-success btn-xs"><i class="fa fa-plus"></i></a></td>
          </tr>
        </table>
        <fieldset style="margin-top: 10px">
          <legend>Поля</legend>
          <c:forEach items="${fields}" var="f" varStatus="loop">
            <form id="form${f.id}">
              <fieldset style="border:1px solid #eee; padding: 5px">
                <legend style="font-size: 12px; font-weight: bold">Поле - ${f.field} (id = ${f.id}) <a class="hand" href="#" onclick="removeField(${f.id})">Удалить</a></legend>
                <div style="float:left; width:500px; margin-right:10px">
                  <table width="100%">
                    <tr>
                      <td style="width:100px" width="80">Name:</td>
                      <td colspan="5"><input type="text" name="field" class="form-control" value="${f.field}"></td>
                    </tr>
                    <tr>
                    </tr>
                    <tr>
                      <td>fieldCode:</td>
                      <td colspan="4"><input type="text" name="fieldCode" class="form-control" value="${f.fieldCode}"></td>
                      <td align=right nowrap>resFlag:&nbsp;<input type="checkbox" name="resFlag" value="Y" <c:if test="${f.resFlag == 'Y'}">checked</c:if>></td>
                    </tr>
                    <tr>
                      <td>fieldType:</td>
                      <td>
                        <select name="fieldType" class="form-control" onchange="setFieldType(${f.id}, this.value)">
                          <option value="">
                          <option <c:if test="${f.fieldType == 'text'}">selected</c:if> value="text">Text
                          <option <c:if test="${f.fieldType == 'select'}">selected</c:if> value="select">select
                          <option <c:if test="${f.fieldType == 'textarea'}">selected</c:if> value="textarea">Textarea
                        </select>
                      </td>
                      <td>cssClass:</td>
                      <td colspan="3"><input type="text" name="cssClass" class="form-control" value="${f.cssClass}"></td>
                    </tr>
                    <tr>
                      <td>defVal:</td>
                      <td colspan="5"><input type="text" name="defVal" class="form-control" value="${f.defVal}"></td>
                    </tr>
                    <tr>
                      <td>maxLength:</td>
                      <td><input type="text" name="maxLength" class="form-control" value="${f.maxLength}"></td>
                      <td>textCols:</td>
                      <td><input type="text" name="textCols" class="form-control" value="${f.textCols}"></td>
                      <td>textRows:</td>
                      <td><input type="text" name="textRows" class="form-control" value="${f.textRows}"></td>
                    </tr>
                    <tr>
                      <td>cssStyle:</td>
                      <td colspan="5"><input type="text" name="cssStyle" class="form-control" value="${f.cssStyle}"></td>
                    </tr>
                    <tr>
                      <td>Ед. изм.:</td>
                      <td colspan="5"><input type="text" name="EI" class="form-control" value="${f.EI}"></td>
                    </tr>
                    <tr>
                      <td>Норма с:</td>
                      <td colspan="5"><input type="text" name="normaFrom" class="form-control" value="${f.normaFrom}"></td>
                    </tr>
                    <tr>
                      <td>Норма по:</td>
                      <td colspan="5"><input type="text" name="normaTo" class="form-control" value="${f.normaTo}"></td>
                    </tr>
                    <tr>
                      <td>Очередность отображения:</td>
                      <td colspan="5"><input type="number" name="ord" class="form-control" value="${f.ord}"></td>
                    </tr>
                  </table>
                </div>
                <div style="float:left">
                  <table width="100%">
                    <tr>
                      <td>
                        <input type="text" id="val${f.id}" name="selVal" style="width:315px; margin-right:8px; float:left;" class="form-control"/>
                        <a href="#" style="margin-right: 4px; margin-top:-1px; float:left" onclick="saveVal(${f.id}); return false;" class="btn btn-success btn-xs"><i class="fa fa-check"></i> Save</a>
                        <a href="#" style="margin-top:-1px; float:left" onclick="addVal(${f.id}); return false;" class="btn btn-success btn-xs"><i class="fa fa-plus"></i></a>
                    </tr>
                    <tr>
                      <td>
                        <select ondblclick="removeElem(this, ${f.id})" size="${fn:length(f.opts) + 1}" style="width: 400px">
                          <c:forEach items="${f.opts}" var="v">
                            <option value="${v.id}">${v.id} - ${v.name}</option>
                          </c:forEach>
                        </select>
                      </td>
                    </tr>
                  </table>
                </div>
              </fieldset>
            </form>
          </c:forEach>
        </fieldset>
      </div>
      <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
