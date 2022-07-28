<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach items="${eats}" varStatus="loop" var="eat">
  <div class="panel panel-default">
    <div class="panel-heading hand" data-toggle="collapse" data-parent="#menu_eats" href="#menu_eat_${loop.index}">
      <h4 class="panel-title">
          ${eat.c1}
        <div style="float:right; color:white; background-color:#c9302c; padding:2px 6px; border-radius: 20px">${fn:length(eat.list)}</div>
      </h4>
    </div>
    <div id="menu_eat_${loop.index}" class="panel-collapse collapse <c:if test="${loop.index == 0}">in</c:if>">
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <c:forEach items="${eat.list}" var="ee">
            <tr>
              <td class="center" style="width:60px">
                <button class="btn btn-success btn-sm" onclick="addTableEat(${ee.c1}, '${ee.c2}')" style="height:20px;padding:1px 10px">
                  <i class="fa fa-check"></i>
                </button>
              </td>
              <td>${ee.c2}</td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
  </div>
</c:forEach>