<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/suneditor/suneditor.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/jquery.mask.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/suneditor/suneditor.min.js"></script>
<div class="w-100 text-center border-bottom-1">
  <table class="w-100">
    <tr>
      <td style="width:30px" class="p-3 text-center">
        <c:if test="${!service.closed}">
          <c:if test="${!(service.result > 0)}">
            <img src="/res/imgs/red.gif" alt="">
          </c:if>
          <c:if test="${service.result > 0}">
            <img src="/res/imgs/yellow.gif" alt="">
          </c:if>
        </c:if>
        <c:if test="${service.closed}">
          <img src="/res/imgs/green.gif" alt="">
        </c:if>
      </td>
      <td class="text-left p-3" style="vertical-align:bottom">
        <h4 class="bold" style="margin-top:15px">
          ${service.service.name}
        </h4>
      </td>
      <td class="text-right p-3" style="width:250px; padding-right:10px">
        <c:if test="${sessionScope.ENV.userId == service.worker.id && !service.closed}">
          <c:if test="${service.result > 0}">
            <button class="btn btn-info btn-icon" type="button" onclick="confirmPatientService()">
              <i class="fa fa-save"></i> Подтвердить
            </button>
          </c:if>
          <button class="btn btn-success btn-icon" type="button" onclick="saveForm()">
            <i class="fa fa-save"></i> Сохранить
          </button>
        </c:if>
      </td>
    </tr>
  </table>
</div>
<form id="amb_form_${service.id}">
  <input type="hidden" name="ps_id" value="${service.id}"/>
  <table class="w-100 light-table">
  <c:if test="${!text_exist}">
    <thead>
    <tr>
      <c:if test="${code_exist}">
        <td class="wpx-100">Код</td>
      </c:if>
      <td>Наименование</td>
      <c:forEach items="${cols}" var="f" varStatus="loop">
        <td>
          ${f.name}
        </td>
      </c:forEach>
      <c:if test="${norma_exist}">
        <td>Норма</td>
      </c:if>
      <c:if test="${ei_exist}">
        <td>Ед.изм.</td>
      </c:if>
    </tr>
    </thead>
  </c:if>
  <tbody>
  <c:forEach items="${fields}" var="f" varStatus="loop">
    <c:if test="${f.typeCode != 'title' && !text_exist}">
      <tr>
        <c:if test="${code_exist}">
          <td class="pb-2 text-center">${f.code}</td>
        </c:if>
        <td class="pb-2">
          ${f.name}
        </td>
        <c:forEach items="${f.fields}" var="a" varStatus="lp">
          <td class="pb-2">
            <c:if test="${a.typeCode == 'select'}">
                <select class="form-control" name="${a.fieldName}_${service.id}">
                  <c:forEach items="${a.options}" var="op">
                    <option <c:if test="${res[a.fieldName] == op.optName}">selected</c:if> value="${op.optName}">${op.optName}</option>
                  </c:forEach>
                </select>
            </c:if>
            <c:if test="${a.typeCode == 'float_nonorm' || a.typeCode == 'float_norm'}">
              <input type="text" maxlength="10" class="form-control center money" name="${a.fieldName}" value="${res[a.fieldName]}">
            </c:if>
            <c:if test="${a.typeCode == 'input_nonorm'}">
              <input type="text" class="form-control" name="${a.fieldName}_${service.id}" value="${res[a.fieldName]}">
            </c:if>
          </td>
        </c:forEach>
        <c:if test="${norma_exist}">
          <td class="text-center">${f.norma}</td>
        </c:if>
        <c:if test="${ei_exist}">
          <td class="text-center wpx-100">${f.ei}</td>
        </c:if>
      </tr>
    </c:if>
    <c:if test="${f.typeCode == 'title'}">
      <tr>
        <td class="text-center bold pb-2" colspan="${fn:length(cols) + 1}">
          <table class="w-100">
            <tr>
              <td>
                ${f.name}
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </c:if>
    <c:if test="${f.typeCode != 'title' && text_exist}">
      <tr>
        <td>${f.name}</td>
      </tr>
      <tr>
        <td>
          <c:if test="${f.typeCode == 'text'}">
            <textarea id="f_${service.id}_${f.id}" class="form-control" name="${f.fieldName}_${service.id}">${res[f.fieldName]}</textarea>
          </c:if>
          <c:if test="${f.typeCode != 'text'}">
            <input class="form-control" name="${f.fieldName}_${service.id}" value="${res[f.fieldName]}"/>
          </c:if>
        </td>
      </tr>
    </c:if>
  </c:forEach>
  </tbody>
</table>
</form>
<script>
  let data = ${res};
  $(() => {
    $('.money').mask("# ##0.00", {reverse: true});
    /*for (let e in data) {
      try {
        document.getElementsByName(e)[0].value = data[e];
      } catch (e) {}
    }*/
  });
  let texts = {};
  <c:forEach items="${fields}" var="f" varStatus="loop">
    <c:if test="${f.typeCode == 'text'}">
      texts['${service.id}_${loop.index}'] = SUNEDITOR.create('f_${service.id}_${f.id}', {
        display: 'block',
        width: '100%',
        height: 'auto',
        popupDisplay: 'full',
        charCounter: true,
        charCounterLabel: 'Characters :',
        imageGalleryUrl: '',
        buttonList: [
        // default
        ['bold', 'underline', 'italic'],
        ['fontSize', 'formatBlock'],
        ['fontColor', 'hiliteColor'],
        ['removeFormat'],
        ['align', 'horizontalRule', 'list', 'lineHeight'],
        ],
        placeholder: '',
        templates: [],
        resizeEnable: false,
        resizingBar: false
      });
    </c:if>
  </c:forEach>
  function saveForm() {
    <c:forEach items="${fields}" var="f" varStatus="loop">
      <c:if test="${f.typeCode == 'text'}">
        getDOM('f_${service.id}_${f.id}').value = texts['${service.id}_${loop.index}'].getContents();
      </c:if>
    </c:forEach>
    $.ajax({
      url: '/ambs/work/save.s',
      method: 'post',
      data: $('#amb_form_${service.id}').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        setPage('/ambs/doctor/service.s?patient=${service.patient}&id=${service.id}');
      }
    });
  }
  function confirmPatientService() {
    if(confirm('Вы действительно хотите подтвердить услугу?'))
      $.ajax({
        url: '/ambs/work/confirm.s',
        method: 'post',
        data: 'id=${service.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          setPage('/ambs/doctor/service.s?patient=${service.patient}&id=${service.id}');
        }
      });
  }
</script>
