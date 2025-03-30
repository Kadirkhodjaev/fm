<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  $(document).ready(function(){
    $('d').html('*').css('font-weight', 'bold').css('color', 'red');
    <c:if test="${authErr}">
      parent.location = '/login.s';
    </c:if>
  });
  function setSubmit() {
    var form = document.querySelector("form");
    var elems = form.elements;
    for (var i=0;i<elems.length;i++){
      if ((elems[i].tagName == 'INPUT' || elems[i].tagName == 'SELECT') && elems[i].getAttribute("field_requeired") != null) {
        if (elems[i].getAttribute("field_requeired") == 'true' && elems[i].value == '') {
          alert("Есть не заполненные поля!");
          return;
        }
      }
    }
    form.submit();
  }
</script>
<form action="/rep/run.s" method="post" id="repParams" target="_blank">
  <input type="hidden" name="repId" value="${id}"/>
  <div class="panel panel-default" style="margin:auto; width:600px; border:1px solid #ababab">
    <div class="panel-heading bold">
      ${report.name}
      <ul class="pagination" style="float:right;margin-top:-4px">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><button type="button" onclick="setSubmit()" class="btn btn-sm btn-success"><i title="Сформировать отчет" class="fa fa-outdent"></i> Сформировать</button></li>
      </ul>
    </div>
    <div class="clearfix"></div>
    <div style="text-align: center">
      <table width="100%">
        <c:forEach items="${params}" var="p">
          <tr>
            <td class="text-right" style="padding:5px" nowrap>
                ${p.c2}<c:if test="${p.c7}"><d></d></c:if> :
            </td>
            <td style="padding:5px">
              <c:if test="${p.c3 == 'input'}">
                <c:if test="${p.c5 == 'text'}">
                  <input class="form-control" name="${p.c6}" field_requeired="${p.c7}"/>
                </c:if>
                <c:if test="${p.c5 == 'single'}">
                  <input name="${p.c6}" id="${p.c6}" type="text" class="form-control datepicker" field_requeired="${p.c7}"/>
                </c:if>
                <c:if test="${p.c5 == 'range'}">
                  <div style="float: left; padding: 5px 10px 0 10px">от</div>
                  <div style="float:left">
                    <input name="${p.c6}_start" id="${p.c6}_start" value="${sysdate}" type="text" class="form-control datepicker" field_requeired="${p.c7}"/>
                  </div>
                  <div style="float:left;padding: 5px 10px 0 10px">до</div>
                  <div style="float:left">
                    <input name="${p.c6}_end" id="${p.c6}_end" value="${sysdate}" type="text" class="form-control datepicker" field_requeired="${p.c7}"/>
                  </div>
                </c:if>
              </c:if>
              <c:if test="${p.c3 == 'select'}">
                <select class="form-control chzn-select" name="${p.c6}" field_requeired="${p.c7}">
                  ${p.c4}
                </select>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</form>
<script>
  $(function(){
    $(".chzn-select").chosen();
  });
</script>
