<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function addRow() {
    document.location = '/view/fizio/list.s';
  }
  function removeFizio(id) {
    $.ajax({
      url:'/view/fizio/delete.s',
      data:'id='+id,
      method:'post',
      dataType:'json',
      success:function (res) {
        alert(res.msg);
        $('#fizio' + id).remove();
      }
    });
  }
  function saveFizio() {
    $.ajax({
      url:'/view/fizio/save.s',
      data:$('#fizioForm').serialize(),
      method:'post',
      dataType:'json',
      success:function (res) {
        alert(res.msg);
        document.location = '/view/fizio/index.s';
      }
    });
  }
</script>
<form id="fizioForm" method="post">
  <div class="panel panel-info" style="width: 1100px !important; margin: auto">
    <div class="panel-heading">
      Физиотерапия
      <c:if test="${sessionScope.ENV.roleId == 16}">
        <button class="btn btn-sm" type="button" onclick="window.open('/lv/plan.s?new=Y')" title="Результаты" style="margin-top: -5px; margin-left:5px; float:right"><i class="fa fa-check"></i> Результаты</button>
        <c:if test="${pat.paid != 'CLOSED'}">
          <button class="btn btn-sm" style="float:right; margin-top:-5px;" onclick="addRow()" type="button"><i class="fa fa-plus"></i> Добавить</button>
        </c:if>
        <button class="btn btn-sm btn-success" style="float:right; margin-top:-5px;margin-right:5px" onclick="saveFizio()" type="button"><i class="fa fa-check"></i> Сохранить</button>
      </c:if>
    </div>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="3"><b>Пациент(ка):</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
        <td colspan="2"><b>Год рождения:</b> ${pat.birthyear}</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center" width="250"><b>Наименование</b></td>
        <td align="center" width="100"><b>Ед.изм.</b></td>
        <td align="center" width="100"><b>Стоимость</b></td>
        <td align="center" width="250"><b>Область</b></td>
        <td align="center" width="100"><b>Кол-во</b></td>
        <td align="center"><b>Примечание</b></td>
        <td align="center" width="30">&nbsp;</td>
      </tr>
      <c:choose>
        <c:when test="${sessionScope.ENV.roleId == 16 && pat.state != 'ARCH'}">
          <c:forEach items="${fizios}" var="fizio" varStatus="loop">
            <input type="hidden" name="id" value="${fizio.id}"/>
            <tr id="fizio${fizio.id}">
              <td align="center">${loop.index + 1}</td>
              <td width="250">${fizio.kdo.name}</td>
              <c:if test="${fizio.kdo.fizei == '' || fizio.fizei == null}">
                <td width="100"><input type="number" maxlength="10" class="form-control center" name="fizei" value="${fizio.fizei}"/></td>
              </c:if>
              <c:if test="${fizio.kdo.fizei != '' && fizio.fizei != null}">
                <td width="100" align="center">${fizio.fizei}</td>
              </c:if>
              <td width="100" align="right">${fizio.price * (fizio.count == null ? 0 : fizio.count) - (fizio.paidSum != null ? fizio.paidSum : 0)}</td>
              <td width="250"><input type="text" maxlength="200" class="form-control" name="oblast" value="${fizio.oblast}"/></td>
              <td align="center" nowrap>
                <select name="count" class="form-control">
                  <c:forEach begin="0" end="20" var="i">
                    <option <c:if test="${fizio.count == i}">selected</c:if> value="${i}">${i}</option>
                  </c:forEach>
                </select>
              </td>
              <td>
                <input type="text" maxlength="200" class="form-control" name="comment" value="${fizio.comment}"/>
              </td>
              <td align="center">
                <c:if test="${fizio.paid != 'Y'}">
                  <button class="btn btn-danger btn-xs" type="button" title="Удалить" onclick="removeFizio(${fizio.id})">
                    <span class="fa fa-minus"></span>
                  </button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <c:forEach items="${fizios}" var="fizio" varStatus="loop">
            <tr id="fizio${fizio.id}">
              <td align="center">${loop.index + 1}</td>
              <td width="250">${fizio.kdo.name}</td>
              <td width="250">${fizio.oblast}</td>
              <td align="center" nowrap>${fizio.count}</td>
              <td>${fizio.comment}</td>
              <td align="center">&nbsp;</td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </table>
  </div>
</form>
