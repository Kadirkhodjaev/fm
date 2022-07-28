<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<html>
<%
  String params = "";
  String consul = request.getParameter("consul");
  params = consul == null ? "" : "&consul=" + consul;
  String dairy = request.getParameter("dairyId");
  params += dairy == null ? "" : "&dairyId=" + dairy;
  String dairyIds = request.getParameter("dairyIds");
  params += dairyIds == null ? "" : "&dairyIds=" + dairyIds;
  String diagnoz = request.getParameter("diagnoz");
  params += diagnoz == null ? "" : "&diagnoz=" + diagnoz;
  String obos = request.getParameter("obos");
  params += obos == null ? "" : "&obos=" + obos;
%>
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
    function setFontSize(size){
      document.location = '/lv/print.s?font=' + size + '<%=params%>';
    }
    $(document).ready(function(){
      $('#printFontSize').val(${sessionScope.fontSize});
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
          <li class="paginate_button" tabindex="0"><a href="#" onclick="getPrint()"><i title="Сохранить" class="fa fa-print"></i> Печать</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="getWord()"><i title="Word" class="fa fa-wordpress"></i> Word</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="self.close()"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
        </ul>
        <div style="float:right; margin-top:10px; margin-right:2px">
          Шрифт:
          <select onchange="setFontSize(this.value)" id="printFontSize" class="form-control" style="width:50px; margin-top:-5px; float:right; height:28px">
            <option value="10">10</option>
            <option value="12">12</option>
            <option value="14">14</option>
            <option value="16">16</option>
            <option value="18">18</option>
            <option value="20">20</option>
            <option value="22">22</option>
            <option value="24">24</option>
            <option value="26">26</option>
          </select>
        </div>
      </td>
    </tr>
  </table>
</div>
<iframe style="margin-top:-10px; width: 100%; height:94% !important; position: absolute" name="frm" id="frm" src="${printPage}?print=Y"></iframe>
</body>
</html>