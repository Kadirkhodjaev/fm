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
    function getPrint(){
      frm.print();
    }
  </script>
</head>
<body>
<div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px;">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; color: #337ab7">${patFio}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px; float:right">
          <li class="paginate_button" tabindex="0"><a href="#" onclick="getPrint();return false;"><i title="Сохранить" class="fa fa-print"></i> Печать</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="self.close();return false;"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
        </ul>
      </td>
    </tr>
  </table>
</div>
<div id="print-content"></div>
</body>
</html>
