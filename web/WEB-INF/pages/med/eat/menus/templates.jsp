<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="modal-header">
  <button type="button" id="templateModal-close" class="close" data-dismiss="modal" aria-hidden="true">×</button>
  <h4 class="modal-title" id="templateModalLabel">
    Шаблоны по ${tableName} на ${menuTypeName}
  </h4>
</div>
<div class="modal-body">
  <div class="row" style="margin:0">
    <c:forEach items="${templates}" var="temp">
      <div class="col-md-6">
        <div class="panel panel-default">
          <div class="panel-heading hand" data-toggle="collapse" href="#menu_template_${temp.id}">
            <h4 class="panel-title">
              ${temp.name}
                <button  class="btn btn-sm btn-success" title="Скопировать шаблон" onclick="copyTemplate(${temp.id})" style="float:right; height:20px;padding:1px 10px;"><i class="fa fa-check"></i></button>
            </h4>
          </div>
          <div id="menu_template_${temp.id}" class="panel-collapse collapse">
            <div class="panel-body">
              <table class="table table-bordered miniGrid">
                <c:forEach items="${temp.eats}" var="eat">
                  <tr>
                    <td>${eat.name}</td>
                  </tr>
                </c:forEach>
              </table>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>