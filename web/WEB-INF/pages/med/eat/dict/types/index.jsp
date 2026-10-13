<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Категории блюд (общий шаблон простого справочника из аптеки) --%>
<c:set var="dkBase" value="/eats/dict"/>
<c:set var="dkCode" value="type"/>
<c:set var="dkPage" value="types"/>
<c:set var="dkTitle" value="Категории блюд"/>
<c:set var="dkOne" value="категория блюд"/>
<c:set var="dkIcon" value="fa-folder-o"/>
<c:set var="dkIncome" value="N"/>
<%@include file="/WEB-INF/pages/med/drugs/dicts/simple.jsp"%>
