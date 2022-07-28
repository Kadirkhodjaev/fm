<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Шаблоны врача</title>
  <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <script src="/res/js/common.js"></script>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>
<style>
  .lv-template:hover {
    cursor:pointer;
    background:#e8e8e8;
  }
</style>
<script>
  function setTemp(dom){
    <c:if test="${!isKdo}">
      opener.setText(dom, '${id}');
      self.close();
      return;
    </c:if>
    opener.nicEditors.findEditor('${id}').setContent(dom.innerHTML);
    self.close();
  }
  function removeTemplate(id) {
    if (confirm('Удалить шаблон?')) {
      var msg = prompt('Код подтверждения');
      if (msg != null && msg.length > 0) {
        $.ajax({
          url: '/templates/delete.s',
          method: 'post',
          data: 'id=' + id + '&pas=' + encodeURIComponent(msg),
          dataType: 'json',
          success: function (res) {
            alert(res.msg);
            self.close();
          }
        });
      }
    }
  }
</script>
<body>
  <div class="panel panel-info" style="width: 1100px !important; margin: auto">
    <div class="panel-heading">
      Шаблоны
      <div style="float:right">
        <button class="btn btn-sm" type="button" id="hey" onclick="window.close()" title="Закрыть" style="margin-top: -5px"><i class="fa fa-close"></i> Закрыть</button>
      </div>
    </div>
    <div id="results" style="padding:10px; font-family:'Arial';">
      <c:forEach items="${templates}" var="r">
        <div style="font-weight:bold">
          ${r.name}
          <button class="btn btn-sm btn-danger" onclick="removeTemplate(${r.id})" style="height:20px; margin-top:-10px"><span class="fa fa-minus"></span></button>
        </div>
        <div onclick="setTemp(this)" title="Закрыть и вставить в поле" class="lv-template">${r.template}</div>
        <hr/>
      </c:forEach>
    </div>
  </div>
</body>
</html>
