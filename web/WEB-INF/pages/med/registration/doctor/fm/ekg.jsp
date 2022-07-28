<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<html>
<head>
  <title>Медицинская система</title>
  <script>
    function getWord(){
      var url = '${printPage}';
      frm.location = url + (url.indexOf('?') == -1 ? '?' : '&') + 'print=Y&word=Y';
    }
    function getPrint(){
      frm.print();
    }
    $(document).ready(function(){
      <c:if test="${printPage==''}">
        alert('ЭКГ результат не готов');
        window.close();
      </c:if>
    });
  </script>
</head>
<body>
<div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px;">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; color: #337ab7">${patFio}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px; float:right">
          <li class="paginate_button" tabindex="0"><a href="#" onclick="self.close()"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
        </ul>
      </td>
    </tr>
  </table>
</div>
<iframe style="margin-top:-10px; width: 100%; height:94% !important; position: absolute" name="frm" id="frm" src="${printPage}"></iframe>
</body>
</html>