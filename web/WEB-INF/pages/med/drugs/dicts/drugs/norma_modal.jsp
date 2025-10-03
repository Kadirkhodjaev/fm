<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal-dialog" style="width:500px">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h4 class="modal-title" id="myModalLabelNorma">Разделение заявки</h4>
    </div>
    <div class="modal-body">
      <form id="addEditNormaForms" name="addEditNormaForms">
        <input type="hidden" name="id" id="id" value="${norma.id}"/>
        <input type="hidden" name="drug" id="drug" value="${drug.id}"/>
        <input type="hidden" name="out_row" id="drug" value="${outRow.id}"/>
        <table class="table table-bordered">
          <tr>
            <td class="right bold">Препарат:</td>
            <td>
              <input class="form-control" readonly name="drug_name" value="${drug.name}"/>
            </td>
          </tr>
          <tr>
            <td class="right bold">Тип норматива:</td>
            <td>
              <select class="form-control" name="type" id="norma_type" onchange="setType()">
                <option value="ALL" <c:if test="${norma.normaType == 'ALL'}">selected</c:if>> Для всех</option>
                <option value="MULTI" <c:if test="${norma.normaType == 'MULTI'}">selected</c:if>>По складам</option>
              </select>
            </td>
          </tr>
          <c:forEach items="${directions}" var="a">
            <tr class="DIRECTION_TR">
              <td class="<c:if test="${a.norma > 0}">bold</c:if>">${a.direction.name}<input type="hidden" name="ids"
                                                                                            value="${a.direction.id}"/>
              </td>
              <td class="text-center">
                <input type="number" class="form-control right" name="normas" value="${a.norma}"/>
              </td>
            </tr>
          </c:forEach>
          <tr class="ALL_TR">
            <td class="right bold">Норма *:</td>
            <td>
              <input type="number" id="norma" class="form-control right" name="norma" value="${norma.norma}"/>
            </td>
          </tr>
        </table>
      </form>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-primary" onclick="saveNorma()">Сохранить</button>
      <button type="button" class="btn btn-default" id="close_modal_norma" data-dismiss="modal">Закрыть</button>
    </div>
  </div>
</div>
<script>
  $(function() {
    setType();
  })
  function setType() {
    let type = getDOM('norma_type');
    $('.DIRECTION_TR').toggle(type.value !== "ALL");
    $('.ALL_TR').toggle(type.value === "ALL");
  }
  function saveNorma() {
    if(getDOM('norma_type').value === 'ALL' && (getDOM('norma').value === '' || getDOM('norma').value === '0')) {
      openMedMsg('Нельзя сохранить пустое значение для нормы', false);
      return;
    }
    $.ajax({
      url: '/drugs/out/row/norma.s',
      method: 'post',
      data: $('#addEditNormaForms').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        getDOM("close_modal_norma").click();
        setTimeout(function () {
          if(res.empty_flag === 'Y')
            setPage('/drugs/out.s');
          else
            setPage('/drugs/out/save.s?id=${outRow.doc.id}');
        }, 500);
      }
    });
  }
</script>
