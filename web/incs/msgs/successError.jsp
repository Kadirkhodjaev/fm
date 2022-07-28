<%@ taglib prefix="lang" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cf" uri="http://java.sun.com/jsp/jstl/core" %>
<cf:if test="${messageCode != null}">
  <script>
    var i=2;
    function closeMessage(){
      setInterval(function(){
        $('div.alert').slideUp(600);
      }, 10000);
    }
    closeMessage();
  </script>
  <div class="alert alert-success alert-dismissable">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <lang:message code="${messageCode}" />
  </div>
</cf:if>
<cf:if test="${errorMsg != null}">
  <script>
    var i=2;
    function closeMessage(){
      setInterval(function(){
        $('div.alert').slideUp(600);
      }, 10000);
    }
    closeMessage();
  </script>
  <div class="alert alert-danger alert-dismissable">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <lang:message code="${errorMsg}" />
  </div>
</cf:if>