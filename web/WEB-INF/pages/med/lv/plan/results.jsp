<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function delPlan(id){
    if(confirm('Вы действительно хотите удалить?'))
      setLocation('?delPlan=Y&id='+id);
  }
  function printPlan(id){
    window.open('/kdo/print.s?id=' + id);
  }
</script>
<title>Результаты по пациенту ${fio}</title>
<body>
<f:form method="post">
  <div class="panel panel-info" style="width: 800px !important; margin: auto">
    <div class="panel-heading">
      План обследования
      <div style="float:right">
        <c:if test="${!newWindow}">
          <button class="btn btn-sm" type="button" onclick="setLocation('/lv/plan/index.s')" title="Назад в список обследования" style="margin-top: -5px"><i class="fa fa-reply"></i> Назад</button>
        </c:if>
        <c:if test="${newWindow}">
          <button class="btn btn-sm" type="button" onclick="window.close()" title="Закрыть" style="margin-top: -5px"><i class="fa fa-close"></i> Закрыть</button>
        </c:if>
      </div>
    </div>
    <div id="results" style="padding:10px; font-family:'Arial';">
      <c:forEach items="${results}" var="r">
        ${r}
      </c:forEach>
    </div>
  </div>
</f:form>
</body>
</html>