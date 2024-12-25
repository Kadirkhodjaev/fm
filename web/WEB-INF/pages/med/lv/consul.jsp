<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  //bkLib.onDomLoaded(nicEditors.allTextAreas);
  function setInnerConsul(dom){
    if(dom.checked) {
      document.getElementById('consulText').style.display = 'none';
      document.getElementById('lvId').style.display = 'inline';
      document.getElementById('lvName').style.display = 'none';
    } else {
      document.getElementById('lvId').style.display = 'none';
      document.getElementById('lvName').style.display = 'inline';
      document.getElementById('consulText').style.display = 'inline';
    }
  }
  function delConsul(id){
    if(confirm('Вы действительно хотите удалить запись?'))
      setLocation('/lv/consul.s?del=Y&id=' + id);
  }
  function setRow(id) {
    setLocation('/lv/consul.s?edit=Y&id=' + id);
  }
</script>
<form action="/lv/consul.s" method="post">
  <div class="panel panel-info" style="width: 1000px !important; margin: auto">
    <div class="panel-heading">
      Консультация
    </div>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable" style="width:100%">
        <tr>
          <td colspan="3"><b>Пациент(ка):</b> ${patient.surname}&nbsp;${patient.name}&nbsp;${patient.middlename}</td>
          <td colspan="5"><b>Год рождения:</b> ${patient.birthyear}</td>
        </tr>
        <c:forEach items="${consuls}" var="c">
          <tr>
            <td colspan="8" style="border-bottom:2px solid #ababab"></td>
          </tr>
          <tr>
            <td colspan="2" nowrap>
              <b>Врач:</b>
              <c:if test="${c.state == 'OUT'}">
                <a href="#" onclick="setRow('${c.id}')">${c.lvName}</a>
              </c:if>
              <c:if test="${c.state != 'OUT'}">
                ${c.lvName}
              </c:if>
            </td>
            <td nowrap colspan="3">
              <b>Дата консультации:</b> ${c.date}
            </td>
            <td class="right">
              <c:if test="${c.state != 'DONE'}">
                <button type="button" onclick="delConsul('${c.id}')" title="Удалить консультацию" class="btn btn-danger btn-xs"><i class="fa fa-minus"></i></button>
              </c:if>
            </td>
          </tr>
          <tr>
            <td colspan="2" class="bold">Комментария врача:</td>
            <td colspan="6">
              ${c.comment}
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <span class="bold">Дата и время создания:</span> <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${c.crOn}"/>
            </td>
            <td colspan="5">
              <span class="bold">Дата и время результата:</span> <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${c.saveDate}"/>
            </td>
          </tr>
          <c:if test="${c.state == 'DONE'}">
            <tr>
              <td colspan="8" class="bold">Консультация: </td>
            </tr>
            <tr>
              <td colspan="8">${c.text}; ${c.req}</td>
            </tr>
          </c:if>
        </c:forEach>
        <tr>
          <td colspan="8" class="bold center" style="padding: 10px; font-size: 16px; border-top:2px solid #ababab; color:#337ab7">Новая консультация</td>
        </tr>
        <tr>
          <input type="hidden" name="id" value="${id}"/>
          <td class="bold">Консультация врача клиники ${shortClinicName}: </td>
          <td class="center" width="60"><input value="Y" type="checkbox" id="innerDoc" name="innerDoc" onclick="setInnerConsul(this)"/></td>
          <td class="bold" width="250" colspan="2">
            Врач:
            <input type="text" style="width:220px; display: inline;" class="form-control" name="lvName" id="lvName" value="${lvName}"/>
            <select class="form-control" style="width:220px; display: none;" id='lvId' name='lvId'>
              <c:forEach items="${lvs}" var="d">
                <option value="${d.id}" <c:if test="${d.id == epic.lvId}">selected</c:if>>${d.profil} - ${d.fio}</option>
              </c:forEach>
            </select>
          </td>
          <td class="bold right">Дата: </td>
          <td width="140"><input type="text" id="conDate" name="conDate" class="form-control datepicker" value="${conDate}"/></td>
        </tr>
        <tr>
          <td colspan="8">Комментария:</td>
        </tr>
        <tr>
          <td colspan="8"><div id="comment"><input class="form-control" name="comment" maxlength="500" value="${comment}"></div></td>
        </tr>
        <tr>
          <td colspan="8"><div id="consulText"><textarea name="conText" rows="8" maxlength="10000" style="width:960px">${conText}</textarea></div></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="submit" class="hidden">Сохранить</button>
    </div>
  </div>
</form>
