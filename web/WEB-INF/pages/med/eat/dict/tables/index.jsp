<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Столы (общий шаблон простого справочника из аптеки) --%>
<c:set var="dkBase" value="/eats/dict"/>
<c:set var="dkCode" value="table"/>
<c:set var="dkPage" value="tables"/>
<c:set var="dkTitle" value="Столы"/>
<c:set var="dkOne" value="стол"/>
<c:set var="dkIcon" value="fa-th-large"/>
<c:set var="dkIncome" value="N"/>
<%@include file="/WEB-INF/pages/med/drugs/dicts/simple.jsp"%>
