<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<div id="copy_text">
  <c:forEach items="${list}" var="a">
    ${a}
  </c:forEach>
</div>
<button class="btn btn-icon btn-info mt-20" onclick="copyText()">Скопировать</button>
<script>
  function copyText() {
    navigator.clipboard.writeText(getDOM('copy_text').innerText);
    openMedMsg('Текст скопирован', true)
    $('#myModal').modal('hide');
  }
</script>
