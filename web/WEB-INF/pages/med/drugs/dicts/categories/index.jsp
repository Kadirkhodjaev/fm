<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Аптека → Справочники → Категории препаратов --%>
<c:set var="dkCode" value="category"/>
<c:set var="dkPage" value="categories"/>
<c:set var="dkTitle" value="Категории препаратов"/>
<c:set var="dkOne" value="категория"/>
<c:set var="dkIcon" value="fa-tags"/>
<c:set var="dkIncome" value="N"/>
<%@include file="/WEB-INF/pages/med/drugs/dicts/simple.jsp"%>
