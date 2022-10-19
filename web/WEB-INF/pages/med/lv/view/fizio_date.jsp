<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
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
        if(res.counter > 0)
          $('#fizio' + id).remove();
        else
          document.location = '/view/fizio/index.s';
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
  function setAct(code) {
    document.location = '/view/fizio/index.s?action=' + code;
  }
  function setCheck(evt, id, d) {
    if(evt.target.tagName != 'INPUT') {
      if(!document.getElementById("fizio_" + id + "_" + d).disabled)
        document.getElementById("fizio_" + id + "_" + d).checked = !document.getElementById("fizio_" + id + "_" + d).checked;
    }
  }
</script>
<form id="fizioForm" method="post">
  <div class="panel panel-info" style="width: 100% !important; margin: auto">
    <div class="panel-heading" style="padding:4px 15px">
      <table style="margin:0;width:100%">
        <tr>
          <td style="width:70px; font-weight:bold; vertical-align: middle">Физиотерапия: </td>
          <td style="width:200px; padding-top:5px">
            <c:if test="${sessionScope.ENV.roleId == 16 && pat.paid != 'CLOSED' && fn:length(fizios) > 0}">
              <button onclick="setAct('add')" type="button" class="btn btn-success btn-xs"><b class="fa fa-plus"></b> день</button>
              <button onclick="setAct('del')" type="button" class="btn btn-danger btn-xs"><b class="fa fa-minus"></b> день</button>
            </c:if>
          </td>
          <td style="vertical-align: middle">

          </td>
          <td align="right" style="vertical-align: middle;width:300px; padding-top:5px">
            <c:if test="${sessionScope.ENV.roleId == 16}">
              <button class="btn btn-xs" type="button" onclick="window.open('/lv/plan.s?new=Y')" title="Результаты" style="margin-top: -5px; margin-left:5px; float:right"><i class="fa fa-check"></i> Результаты</button>
              <c:if test="${pat.paid != 'CLOSED'}">
                <button class="btn btn-xs" style="float:right; margin-top:-5px;" onclick="addRow()" type="button"><i class="fa fa-plus"></i> Добавить</button>
              </c:if>
              <button class="btn btn-xs btn-success" style="float:right; margin-top:-5px;margin-right:5px" onclick="saveFizio()" type="button"><i class="fa fa-check"></i> Сохранить</button>
            </c:if>
          </td>
        </tr>
      </table>
    </div>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="4"><b>Пациент(ка):</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}</td>
        <td colspan="2"><b>Год рождения:</b> ${pat.birthyear}</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center" width="250" style="height:48px"><b>Наименование</b></td>
        <td align="center" width="100"><b>Ед.изм.</b></td>
        <td align="center" width="100"><b>Стоимость</b></td>
        <td align="center" width="250"><b>Область</b></td>
        <c:if test="${fn:length(fizios) > 0}">
          <c:forEach items="${dates}" var="d">
            <td style="position:relative;"><b><div style="position: absolute; top:15px; left:3px; -webkit-transform: rotate(270deg);"><fmt:formatDate pattern="dd.MM" value="${d.date}"/></div></b></td>
          </c:forEach>
        </c:if>
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
              <c:choose>
                <c:when test="${ fizio.kdo.fizei == null || fizio.fizei == null}">
                  <td width="100"><input type="number" maxlength="10" class="form-control center" name="fizei" value="${fizio.fizei}"/></td>
                </c:when>
                <c:otherwise>
                  <td width="100" align="center"><input type="hidden" name="fizei" value="${fizio.fizei}"/>${fizio.fizei}</td>
                </c:otherwise>
              </c:choose>
              <td width="100" align="right">${fizio.price * (fizio.count == null ? 0 : fizio.count) - (fizio.paidSum != null ? fizio.paidSum : 0)}</td>
              <td width="250"><input type="text" maxlength="200" class="form-control" name="oblast" value="${fizio.oblast}"/></td>
              <c:forEach items="${ds[fizio.id]}" var="d">
                <td onclick="setCheck(event, ${fizio.id}, '<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>')" class="hand hover" style="vertical-align: middle; text-align: center">
                  <input type="hidden" name="date_${fizio.id}" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>"/>
                  <input type="checkbox" <c:if test="${d.done != 'N'}">disabled</c:if> <c:if test="${d.state == 'Y'}">checked</c:if> name="fizio_${fizio.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" id="fizio_${fizio.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" value="Y"/>
                </td>
              </c:forEach>
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
              <td align="center" nowrap>${fizio.fizei}</td>
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
