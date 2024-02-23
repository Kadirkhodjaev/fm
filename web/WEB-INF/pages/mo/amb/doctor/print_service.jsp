<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<table class="w-100 light-table">
  <c:if test="${!text_exist}">
    <thead>
    <tr>
      <c:if test="${code_exist}">
        <td class="wpx-100">Код</td>
      </c:if>
      <td>Наименование</td>
      <c:forEach items="${cols}" var="f" varStatus="loop">
        <td>${f.name}</td>
      </c:forEach>
      <c:if test="${norma_exist}">
        <td>Норма</td>
      </c:if>
      <c:if test="${ei_exist}">
        <td>Ед.изм.</td>
      </c:if>
    </tr>
    </thead>
  </c:if>
  <tbody>
  <c:forEach items="${fields}" var="f" varStatus="loop">
    <c:if test="${f.typeCode != 'title' && !text_exist}">
      <tr>
        <c:if test="${code_exist}">
          <td class="pb-2 text-center">${f.code}</td>
        </c:if>
        <td class="pb-2">${f.name}</td>
        <c:forEach items="${f.fields}" var="a" varStatus="lp">
          <td class="pb-2 text-center">${res[a.fieldName]}</td>
        </c:forEach>
        <c:if test="${norma_exist}">
          <td class="text-center">${f.norma}</td>
        </c:if>
        <c:if test="${ei_exist}">
          <td class="text-center wpx-100">${f.ei}</td>
        </c:if>
      </tr>
    </c:if>
    <c:if test="${f.typeCode == 'title'}">
      <tr>
        <td class="text-center bold pb-2" colspan="${fn:length(cols) + 1}">${f.name}</td>
      </tr>
    </c:if>
    <c:if test="${f.typeCode != 'title' && text_exist}">
      <tr>
        <td class="bold">${f.name}:</td>
      </tr>
      <tr>
        <td>${res[f.fieldName]}</td>
      </tr>
    </c:if>
  </c:forEach>
  </tbody>
</table>
