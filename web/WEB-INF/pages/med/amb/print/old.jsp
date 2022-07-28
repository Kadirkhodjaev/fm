<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<table style="width:100%;margin-top:10px">
  <tr>
    <td style="font-weight:bold; text-align:center; font-size:${sessionScope.fontSize + 4}px !important;">${ser.service.name}</td>
  </tr>
  <c:if test="${ser.result.c1 != 'undefined' && ser.result.c1 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c1_name}</td></tr>
    <tr><td>${ser.result.c1}</td></tr>
  </c:if>
  <c:if test="${ser.result.c2 != 'undefined' && ser.result.c2 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c2_name}</td></tr>
    <tr><td>${ser.result.c2}</td></tr>
  </c:if>
  <c:if test="${ser.result.c3 != 'undefined' && ser.result.c3 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c3_name}</td></tr>
    <tr><td>${ser.result.c3}</td></tr>
  </c:if>
  <c:if test="${ser.result.c4 != 'undefined' && ser.result.c4 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c4_name}</td></tr>
    <tr><td>${ser.result.c4}</td></tr>
  </c:if>
  <c:if test="${ser.result.c5 != 'undefined' && ser.result.c5 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c5_name}</td></tr>
    <tr><td>${ser.result.c5}</td></tr>
  </c:if>
  <c:if test="${ser.result.c6 != 'undefined' && ser.result.c6 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c6_name}</td></tr>
    <tr><td>${ser.result.c6}</td></tr>
  </c:if>
  <c:if test="${ser.result.c7 != 'undefined' && ser.result.c7 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c7_name}</td></tr>
    <tr><td>${ser.result.c7}</td></tr>
  </c:if>
  <c:if test="${ser.result.c8 != 'undefined' && ser.result.c8 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c8_name}</td></tr>
    <tr><td>${ser.result.c8}</td></tr>
  </c:if>
  <c:if test="${ser.result.c9 != 'undefined' && ser.result.c9 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c9_name}</td></tr>
    <tr><td>${ser.result.c9}</td></tr>
  </c:if>
  <c:if test="${ser.result.c10 != 'undefined' && ser.result.c10 != null}">
    <tr><td style="font-weight:bold;font-size:${sessionScope.fontSize + 2}px !important;">${ser.c10_name}</td></tr>
    <tr><td>${ser.result.c10}</td></tr>
  </c:if>
  <tr>
    <td style="padding:20px 0;font-weight:bold">
      <table width="100%">
        <tr>
          <td width="50%" style="font-weight:bold;padding-left:20px;">Врач</td>
          <td width="50%" style="font-weight:bold;text-align:right;padding-right:20px;">${ser.worker.fio}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
