<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Печатный центр для "MedOnline"</title>
    <link href="/res/css/styles.css" rel="stylesheet">
    <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
    <script>
      function getPrint(){
        print();
      }
      function setFontSize(size){
        document.location = '/amb/print.s?font=' + size + '';
      }
      $(() => {
        $('#print-content').height($(window).height() - 50);
        $('#print-content').load('${page.url}?${params}');
      });
    </script>
  </head>
  <body>
<div class="banner no-print" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px;">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; color: #337ab7">${page.name}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px; float:right">
          <li class="paginate_button"><a href="#" onclick="getPrint();return false;"><i title="Сохранить" class="fa fa-print"></i> Печать</a></li>
          <li class="paginate_button" ><a href="#" onclick="self.close();return false;"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
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
<div id="print-content" style="overflow-y: auto"></div>
</body>
</html>

