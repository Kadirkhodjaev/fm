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
      frm.location = '/kdo/obs.s?print=Y&word=Y&id=${id}';
    }
    function getPrint(){
      var divToPrint=document.getElementById('print-content');
      var newWin=window.open('HEY','Print-Window');
      newWin.document.open();
      newWin.document.write('<html><body onload="window.print()">'+divToPrint.innerHTML+'</body></html>');
      newWin.document.close();
      //setTimeout(function(){newWin.close();},100);
    }
    function setFontSize(size){
      frm.location = '/kdo/obs.s?print=Y&id=${id}&kdo=${kdoId}&font=' + size;
    }
    $(document).ready(function(){
      $('#printFontSize').val(${sessionScope.fontSize});
    });
    function iframeLoaded(iFrameID) {
      if(iFrameID) {
        iFrameID.height = "";
        iFrameID.height = iFrameID.contentWindow.document.body.scrollHeight + 5 + "px";
      }
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
<div id="print-content">
  <c:forEach items="${plans}" var="plan" varStatus="loop">
    <div id="plan${plan.c1}"></div>
  </c:forEach>
</div>
</body>
</html>
<script>
  <c:forEach items="${plans}" var="plan" varStatus="loop">
  $.ajax({
    url: '/kdo/obs.s',
    data: 'idx=${loop.index}&print=Y&id=${plan.c1}&kdo=${plan.c2}&font=${sessionScope.fontSize}',
    method: 'get',
    dataType: 'html',
    success: function (res) {
      $('#plan${plan.c1}').html(res);
    }
  });
  </c:forEach>
</script>