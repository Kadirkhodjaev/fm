<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Справочник значений для поля-списка: грузится в окно «Значения из справочника» на странице полей формы --%>
<div class="vals-grid">
  <c:forEach items="${opts}" var="o">
    <label title="ID ${o.id}"><input type="checkbox" value="${o.id}"/> ${fn:escapeXml(o.name)}</label>
  </c:forEach>
</div>
<c:if test="${empty opts}"><div class="fm-hint">Справочник пуст</div></c:if>
