<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Шаблоны меню стола (загружается в окно «Шаблоны» на странице меню) --%>
<c:forEach items="${templates}" var="temp">
  <div class="md-tpl">
    <div class="md-tpl-h">
      <span style="flex:1">${fn:escapeXml(temp.name)}</span>
      <span class="fm-count">${fn:length(temp.eats)} блюд</span>
      <button type="button" class="fm-btn primary" onclick="copyTemplate(${temp.id})"><i class="fa fa-check"></i>Взять</button>
    </div>
    <div class="md-tpl-b">
      <c:forEach items="${temp.eats}" var="eat"><span>${eat.name}</span></c:forEach>
    </div>
  </div>
</c:forEach>
<c:if test="${empty templates}"><div class="fm-empty" style="display:block"><i class="fa fa-bookmark-o"></i>Шаблонов для этого стола и приёма пищи нет</div></c:if>
