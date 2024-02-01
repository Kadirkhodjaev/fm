<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="panel panel-info wpx-1400 margin-auto">
<div class="panel-heading">
  <span class="fa fa-list"></span> Физиотерапия
  <ul class="pagination" style="float:right; margin-top:-5px">
    <li class="paginate_button" tabindex="0"><a href="#" onclick="saveFizio()"><i class="fa fa-save"></i> Сохранить</a></li>
  </ul>
</div>
<form id="fizio_form">
  <table class="w-100 table-bordered p-5">
    <tr class="text-info">
      <td class="center bold">№</td>
      <td class="center bold" style="height:48px">Наименование</td>
      <td class="center bold">Область</td>
      <c:forEach items="${dates}" var="d">
        <td style="position:relative;" class="bold">
          <div style="position: absolute; top:15px; left:-4px; -webkit-transform: rotate(270deg);">
            <fmt:formatDate pattern="dd.MM" value="${d.date}"/>
          </div>
        </td>
      </c:forEach>
      <td class="center bold">Комментария</td>
    </tr>
    <c:forEach items="${fizios}" var="fizio" varStatus="loop">
      <tr>
        <td class="center wpx-40">${loop.index + 1}</td>
        <td>
          <input type="hidden" name="id" value="${fizio.fizio.id}"/>
            ${fizio.name}
        </td>
        <td>
          <input type="text" maxlength="200" class="form-control" onkeyup="search_templates(this, ${fizio.fizio.service.id}, 'oblast')" name="oblast" value="${fizio.oblast}"/>
          <div id="oblast_filter" style="display: none; position: absolute; background:white">
            <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
          </div>
        </td>
        <c:forEach items="${fizio.dates}" var="d">
          <td onclick="setCheck(event, ${fizio.fizio.id}, '<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>')" class="hand hover" style="vertical-align: middle; text-align: center">
            <input type="hidden" name="date_${fizio.fizio.id}" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>"/>
            <input type="checkbox" <c:if test="${d.state == 'Y'}">checked</c:if> name="fizio_${fizio.fizio.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" id="fizio_${fizio.fizio.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" value="Y"/>
          </td>
        </c:forEach>
        <td>
          <input type="text" maxlength="200" class="form-control" name="comment" onkeyup="search_templates(this, ${fizio.fizio.service.id}, 'comment')" value="${fizio.comment}"/>
          <div id="comment_filter" style="display: none; position: absolute; background:white">
            <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
          </div>
        </td>
      </tr>
    </c:forEach>
  </table>
</form>
</div>
<script>
  // Физиотерапия
  let rows = [];
  function search_templates(dom, kdo, code) {
    let div = $('#' + code + '_filter'), elem = $(dom), v = elem.val().toUpperCase();
    div.width(elem.width() + 150);
    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(rows.length === 0) {
        $.ajax({
          url: '/ambs/doctor/fizio/search_templates.s',
          method: 'post',
          data: 'code=' + code + '&kdo=' + kdo + '&word=' + encodeURIComponent(v),
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              rows = res.rows;
              if(rows.length > 0) {
                buildRow(dom, rows, code);
                div.show();
              }
            } else openMsg(res);
          }
        });
      } else {
        let cls = rows.filter(obj => obj.toUpperCase().indexOf(v) !== -1);
        buildRow(dom, cls, code);
      }
    } else {
      rows = [];
    }
  }
  function buildRow(dom, cls, code) {
    let table = $('#' + code + '_filter>table>tbody');
    table.html('');
    for(let obj of cls) {
      let tr = $('<tr></tr>');
      tr.click(()=> {
        $('#' + code + '_filter').hide();
        dom.value = obj;
      });
      let fio = $('<td>' + obj + '</td>');
      tr.append(fio);
      table.append(tr);
    }
  }
  function setCheck(evt, id, d) {
    if(evt.target.tagName != 'INPUT') {
      if(!document.getElementById("fizio_" + id + "_" + d).disabled)
        document.getElementById("fizio_" + id + "_" + d).checked = !document.getElementById("fizio_" + id + "_" + d).checked;
    }
  }
  //
  function saveFizio() {
    $.ajax({
      url: '/ambs/doctor/fizio/save.s',
      method: 'post',
      data: $('#fizio_form').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
</script>
