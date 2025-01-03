<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script>
  function setNeedleCount(p, v) {
    $.ajax({
      url: '/view/needle.s',
      method: 'post',
      data: 'p=' + p + '&v=' + v,
      dataType: 'json',
      success: function (res) {
        console.log(res)
        openMsg(res);
      }
    });
  }
</script>
<div class="panel panel-info" style="width: 1100px !important; margin: auto">
  <div class="panel-heading">Иглотерапия</div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="4"><b>Пациент(ка):</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}<div style="float:right"><b>Год рождения:</b> ${pat.birthyear}</div></td>
      </tr>
      <tr>
        <td class="bold center">Наименование</td>
        <td class="bold center wpx-150">Дата</td>
        <td class="bold center wpx-150">Кол-во</td>
        <td class="bold center">Примечание</td>
      </tr>
      <c:forEach items="${plans}" var="p">
        <tr>
          <td>${p.kdo.name}</td>
          <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${p.actDate}" /></td>
          <td>
            <input type="number" onchange="setNeedleCount(${p.id}, this.value)" value="${p.counter == null ? 0 : p.counter}" class="form-control text-center">
          </td>
          <td>${p.comment}</td>
        </tr>
      </c:forEach>
    </table>
    <div class="panel-footer" style="display:none">
      <button type="submit" id="saveBtn" title="Сохранить">Сохранить</button>
    </div>
  </div>
</div>
