<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function setFizio(){
    $.ajax({
      url:'/lv/fizio/set.s',
      dataType:'json',
      success:function (res) {
        alert(res.msg);
        document.location = '/lv/fizio/index.s';
      }
    });
  }
</script>
<div class="panel panel-info" style="width: 100% !important; margin: auto">
  <%@include file="/incs/msgs/successError.jsp"%>
  <div class="panel-heading">
    Физиотерапия
    <cf:if test="${pat.state != 'ARCH'}">
      :
      <cf:if test="${pat.fizio && pat.paid != 'CLOSED'}">
        <span style="color:green;font-weight: bold">Назначено</span>
        <c:if test="${fn:length(fizios) == 0}">
          <button class="btn btn-sm btn-danger" style="float:right; margin-top:-5px" onclick="setFizio()" type="button">
            <i class="fa fa-send-o"></i> Отменить
          </button>
        </c:if>
      </cf:if>
      <cf:if test="${!pat.fizio && pat.paid != 'CLOSED'}">
        <span style="color:red">Не назначено</span>
        <button class="btn btn-sm btn-success" style="float:right; margin-top:-5px" onclick="setFizio()" type="button">
          <i class="fa fa-check-square-o"></i> Назначить
        </button>
      </cf:if>
    </cf:if>
  </div>
  <table class="formTable" style="width:100%">
    <tr>
      <td>&nbsp;</td>
      <td align="center"><b>Наименование</b></td>
      <td align="center"><b>Облать</b></td>
      <c:forEach items="${dates}" var="d">
        <td class="center" style="width:55px"><b><fmt:formatDate pattern="dd.MM" value="${d.date}"/></b></td>
      </c:forEach>
      <%--<td align="center" width="100"><b>Кол-во</b></td>--%>
      <td align="center"><b>Примечание</b></td>
      <td align="center" width="30">&nbsp;</td>
    </tr>
    <c:forEach items="${fizios}" var="fizio" varStatus="loop">
      <tr id="fizio${fizio.id}">
        <td align="center">${loop.index + 1}</td>
        <td>${fizio.kdo.name}</td>
        <td>${fizio.oblast}</td>
        <c:forEach items="${ds[fizio.id]}" var="d">
          <td style="vertical-align: middle; text-align: center">
            <c:if test="${d.state == 'Y'}"><b class="text-success fa fa-plus"></b></c:if>
          </td>
        </c:forEach>
        <td>${fizio.comment}</td>
        <td align="center">&nbsp;</td>
      </tr>
    </c:forEach>
  </table>
</div>
