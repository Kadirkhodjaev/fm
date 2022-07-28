<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  response.setContentType("application/msword;charset=windows-1251");
  response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<html>
<body>
<div>
  <table style="width:100%; display:none">
    <tr>
      <td style="padding-left:75px">
        <img src="/res/imgs/fm_logo.png" style="width:180px">
      </td>
      <td rowspan="2" style="font-size:16px !important; font-weight:bold; text-align:right;padding-top:20px">
        �� "Farxod Mada Shifo"<br/>
        ���������� ����������<br/>
        ����������� �������<br/>
        ���������� �����<br/>
        ��. ��������, 8�<br/>
        ��� ����: www.forux.uz<br/>
        email: forux@mail.ru<br/>
        ���/����: (71) 289-24-66
      </td>
    </tr>
    <tr>
      <td style="text-align:left;font-weight:bold">
        <div style="font-size:16px !important;padding-left:90px">������������� �1878</div>
        <div style="font-size:16px !important;padding-left:100px">�������� �01727</div>
      </td>
    </tr>
  </table>
  <div style="height:110px;"></div>
  <table style="margin:auto; width:100%;" cellspacing="0" cellpadding="0">
    <tr>
      <td style="padding:2px; width:200px; border:1px solid black; text-align:center; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">�.�.�.</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">${patient.surname} ${patient.name} ${patient.middlename}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">��� ��������</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">${patient.birthyear}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;">���� � �����</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;font-size:${sessionScope.fontSize + 4}px !important;"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${patient.crOn}"/></td>
    </tr>
  </table>
</div>
<c:forEach items="${services}" var="ser">
  <c:if test="${ser.state == ''}">
    <%@include file="old.jsp"%>
  </c:if>
  <c:if test="${ser.state == '777'}">
    <%@include file="777.jsp"%>
  </c:if>
  <c:if test="${ser.state == '888'}">
    <%@include file="888.jsp"%>
  </c:if>
  <c:if test="${ser.state == '1000'}">
    <%@include file="1000.jsp"%>
  </c:if>
  <c:if test="${ser.state == '1001'}">
    <%@include file="1001.jsp"%>
  </c:if>
  <c:if test="${ser.state == '1004'}">
    <%@include file="1004.jsp"%>
  </c:if>
  <c:if test="${ser.state == '1005'}">
    <%@include file="1005.jsp"%>
  </c:if>
</c:forEach>
</body>
</html>
