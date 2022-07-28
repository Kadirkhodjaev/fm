<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<form id="clsForm" action="/lv/cls.s" method="post">
<div class="panel panel-info" style="width: 900px !important; margin: auto">
  <div class="panel-heading">Консультация</div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="4"><b>Пациент(ка):</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}<div style="float:right"><b>Год рождения:</b> ${pat.birthyear}</div></td>
      </tr>
      <c:forEach items="${consuls}" var="c">
        <tr>
          <td nowrap><b>Врач:</b> ${c.lvName}</td>
          <td nowrap colspan="2"><b>Дата: </b> ${c.date}</td>
        </tr>
        <c:if test="${c.text != '' && c.text != null}">
          <tr>
            <td colspan="3">${c.text}; ${c.req}</td>
          </tr>
        </c:if>
        <tr>
          <td colspan="3" style="border-bottom:2px solid #ababab"></td>
        </tr>
      </c:forEach>
      <c:if test="${consulFlag}">
        <script src="/res/editor/nicEdit.js" type="text/javascript"></script>
        <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
        <script>
          //bkLib.onDomLoaded(nicEditors.allTextAreas);
          function printConsul(id){
            window.open('/lv/print.s?consul=' + id);
          }
          function copyConsul(id){
            document.location = '?copy=Y&id=' + id;
          }
          function delConsul(id){
            document.location = '?del=Y&id=' + id;
          }
          $(document).ready(function(){
            parent.document.getElementById('saveForm').style.display = 'inline';
          });
        </script>
        <tr>
          <td colspan="3" align="center" style="padding:10px; font-weight: bold; color:#337ab7">Мои консультации</td>
        </tr>
        <c:forEach items="${cls}" var="d">
          <input type="hidden" name="id" value="${d.id}"/>
          <tr>
            <td><b>Врач:</b> ${d.lvName}</td>
            <td><b>Дата: </b> ${d.date}</td>
            <td align="right">
              <c:if test="${d.text != null && c.text != ''}">
                <b title='Печать' onclick="printConsul(${d.id})" class="hand glyphicon glyphicon-print"></b>&nbsp;&nbsp;
                <b title='Создать' onclick="copyConsul(${d.id})" class="hand glyphicon glyphicon-copy"></b>&nbsp;&nbsp;
                <c:if test="${d.copied == 'Y'}">
                  <b title='Удалить' onclick="delConsul(${d.id})" class="hand glyphicon glyphicon-trash"></b>
                </c:if>
              </c:if>
            </td>
          </tr>
          <tr><td colspan="3">Консультация</td></tr>
          <tr>
            <td colspan="3"><textarea name="comment" rows="8" maxlength="10000" style="width:860px !important;">${d.text}</textarea></td>
          </tr>
          <tr><td colspan="3">Рекомендация</td></tr>
          <tr>
            <td colspan="3"><textarea name="reqs" rows="8" maxlength="10000" style="width:860px !important;">${d.req}</textarea></td>
          </tr>
          <tr>
            <td colspan="3" style="border-bottom:2px solid #ababab"></td>
          </tr>
        </c:forEach>
      </c:if>
    </table>
    <c:if test="${consulFlag}">
      <div class="panel-footer" style="display:none">
        <button type="submit" id="saveBtn" title="Сохранить">Сохранить</button>
      </div>
    </c:if>
  </div>
</div>
</form>