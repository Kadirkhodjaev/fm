<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Title</title>
</head>
<body>
<table style="width:100%">
  <c:forEach items="${rows}" var="c">
    <tr>
      <td>${c}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
