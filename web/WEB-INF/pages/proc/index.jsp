<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<title><ui:message code="med"/></title>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>
<script>
  function exit(){
    if(window.confirm('<ui:message code="confirmExit" />'))
      document.location = 'out.s';
  }
  function setPage(url){
    $('#mainWindow').load(url);
  }
  function setChangePass(){
    setPage('/admin/changePass.s');
  }
  function openMainPage(url, isFull) {
    $('#mainWindow').load(url);
    $('#tdLeftMenu').toggle(isFull);
  }
  $(document).ready(function(){
    openMainPage('${openPage}', true);
    resizeMainWindow();
    $(window).resize(function(){
      resizeMainWindow();
    });
  });
  $(window).bind("load resize", function(){
    var h = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 50;
    $('#content>table').height(h);
  });
  function resizeMainWindow(){
    var bh = $(window).height() - 60;
    $('#mainWindow').css('height', bh).css('overflow-x', 'auto');
  }
  function openPage(dom){
    $('.leftMenu li').attr("class", "");
    dom.className = "active";
    $('#mainWindow').load(dom.id);
  }
</script>
<html>
<body>
<div class="med-msg" style="display: none">
  <table style="width:100%">
    <tr>
      <td id="med-msg-text" style="overflow: hidden"></td>
      <td style="width:35px;border-left: 1px solid #ababab;cursor: pointer" onclick="closeMedMsg()">
        <div class="close-msg" title="Закрыть">X</div>
      </td>
    </tr>
  </table>
</div>
<div id="wrapper">
  <div class="banner">
    <table>
      <tr>
        <td style="width: 350px">
          <a href="main.s">
            <img src="/res/imgs/logo_forux.jpg" style="height:40px; margin-top:2px"/>
          </a>
        </td>
        <td>&nbsp;</td>
        <td style="padding:0 20px;">
          <c:if test="${showSearch}">
            <center>
              <table style="max-width:500px">
                <tr>
                  <td style="width: 110px">&nbsp;</td>
                  <td>
                    <div class="input-group">
                      <input type="text" onkeyup="setFilter(event, true)" value="${session.filterFio}" id="filterInput" class="form-control" placeholder="Поиск..." style="border-right: 0; height:34px">
                      <span class="input-group-btn">
                          <button type="button" class="btn btn-default" title="Расширенный поиск" onclick="showFilter(event)"><i class="fa fa-plus"></i></button>
                          <button <c:if test="${session.filtered}">style="color:red"</c:if> onclick="setFilter(event, false)" class="btn btn-default" title="Поиск" type="button"><i class="fa fa-search"></i></button>
                        </span>
                    </div>
                  </td>
                </tr>
              </table>
            </center>
          </c:if>
        </td>
        <td>&nbsp;</td>
        <td style="min-width:400px;">
          <ul class="nav navbar-top-links navbar-right in">
            <li class="dropdown">
              <a class="dropdown" data-toggle="dropdown" href="#" onclick="setChangePass()">
                <i class="fa fa-user fa-fw"></i> ${sessionScope.ENV.userName}
              </a>
            </li>
            <li class="dropdown">
              <a class="dropdown" data-toggle="dropdown" href="#" onclick="exit(); return false;">
                <i class="fa fa-power-off fa-fw"></i> <ui:message code="exit"/>
              </a>
            </li>
          </ul>
        </td>
      </tr>
    </table>
  </div>
  <div id="content">
    <table style="width: 100%; margin-top: -10px">
      <tr>
        <td id="tdLeftMenu" valign="top" style="width:200px;">
          <ul class="leftMenu">
            <c:forEach items="${menuList}" var="m">
              <li class="${m.state}" onclick="openPage(this)" id="${m.url}">
                <i class="${m.icon}"></i> ${m.name}
              </li>
            </c:forEach>
          </ul>
        </td>
        <td style="background: #fff; padding:1px" valign="top">
          <div id="mainWindow" style="width: 100%;"></div>
        </td>
      </tr>
    </table>
  </div>
</div>
</body>
</html>
