<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="col-lg-12">
  <h1 class="page-header" style="color: #337ab7">Роли</h1>
</div>
<div style="clear:both"></div>
<table style="width: 100%;">
  <c:forEach items="${roles}" var="r" varStatus="loop">
    <c:if test="${loop.first || loop.index % 5 == 0}">
      <tr><td>&nbsp;</td>
    </c:if>
    <td style="width: 300px;padding:0">
      <a onclick="setLocation('/setRole.s?id=' + ${r.id}); return false;" href="#">
        <div class="col-lg-11">
          <div class="${r.color}">
            <div class="panel-heading">
              <div class="row">
                <div class="center">
                  <i class="${r.icon} fa-5x"></i>
                </div>
              </div>
            </div>
            <div class="panel-footer">
              <span class="pull-left">${r.name}</span>
              <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
              <div class="clearfix"></div>
            </div>
          </div>
        </div>
      </a>
    </td>
    <c:if test="${loop.index % 5 == 4 || loop.last}">
      <td>&nbsp;</td></tr>
    </c:if>
  </c:forEach>
</table>
