<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Типы меню (общий шаблон простого справочника из аптеки) --%>
<c:set var="dkBase" value="/eats/dict"/>
<c:set var="dkCode" value="menuType"/>
<c:set var="dkPage" value="menuTypes"/>
<c:set var="dkTitle" value="Типы меню"/>
<c:set var="dkOne" value="тип меню"/>
<c:set var="dkIcon" value="fa-list-alt"/>
<c:set var="dkIncome" value="N"/>
<%@include file="/WEB-INF/pages/med/drugs/dicts/simple.jsp"%>
