<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Аптека → Справочники → Производители --%>
<c:set var="dkCode" value="manufacturer"/>
<c:set var="dkPage" value="manufacturers"/>
<c:set var="dkTitle" value="Производители"/>
<c:set var="dkOne" value="производитель"/>
<c:set var="dkIcon" value="fa-building-o"/>
<c:set var="dkIncome" value="N"/>
<%@include file="/WEB-INF/pages/med/drugs/dicts/simple.jsp"%>
