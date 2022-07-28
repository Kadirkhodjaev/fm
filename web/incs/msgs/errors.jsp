<%@ taglib prefix="lang" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cf" uri="http://java.sun.com/jsp/jstl/core" %>
<lang:bind path="errors.*">
  <cf:if test="${status.errors.errorCount > 0}">
    <div class="alert alert-danger alert-dismissable">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <f:errors path="*"/>
    </div>
  </cf:if>
</lang:bind>