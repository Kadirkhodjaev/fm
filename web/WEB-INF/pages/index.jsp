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
  function openPage(dom){
    $('.leftMenu li').attr("class", "");
    dom.className = "active";
    $('#mainWindow').load(dom.id);
  }
  function setPage(url){
    $('#mainWindow').load(url, function () {
      bkLib.onDomLoaded(function() {
        nicEditors.editors.push(
          new nicEditor().panelInstance(
            document.getElementById('id_c2')
          )
        );
      });
    });
  }
  function openMainPage(url, isFull) {
    $('#mainWindow').load(url);
    $('#tdLeftMenu').toggle(isFull);
  }
  $(window).bind("load resize", function(){
    var h = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 50;
    $('#content>table').height(h);
  });
  $(document).ready(function(){
    openMainPage('${openPage}', ${showMenu});
  });
  function callKeyDown(evt){
    try {
      keyDown(evt);
    }catch (e){}
  }
  function setFilter(evt, isInput){
    <c:if test="${isEnterFilter}">
    if((isInput && evt.keyCode == 13) || !isInput) {
      <c:if test="${fn:indexOf(session.curUrl, 'amb') == -1}">
        if ($('#filterInput').val() != '')
          setPage('/patients/index.s?filter=Y&filterInput=' + $('#filterInput').val());
        else
          setPage('/patients/index.s?filter=Y');
      </c:if>
      <c:if test="${fn:indexOf(session.curUrl, 'amb') != -1}">
        if ($('#filterInput').val() != '')
          setPage('${session.curUrl}?filter=Y&filterInput=' + $('#filterInput').val());
        else
          setPage('${session.curUrl}?filter=Y');
      </c:if>
    }
    </c:if>
    <c:if test="${!isEnterFilter}">
    if ($('#filterInput').val() != '')
      setPage('/patients/index.s?filter=Y&filterInput=' + $('#filterInput').val());
    else
      setPage('/patients/index.s?filter=Y');
    </c:if>
  }
  function setChangePass(){
    setPage('/admin/changePass.s');
  }
  function setFilterType(){
    document.location = '/main.s?clear=Y';
  }
  $('d').html('*').css('font-weight', 'bold').css('color', 'red');
  function showFilter(e) {
    var d = $('#detailedFilter');
    if(d.attr('id')) {
      d.remove();
      return;
    }
    d = $('<div></div>');
    d.attr('id', 'detailedFilter');
    d.css('left', $('#filterInput').offset().left - 55);
    d.css('top', $('#filterInput').offset().top + 35);
    d.html($('#detailedFilterFull').html());
    $('#wrapper').append(d);
  }
  $(document).ready(function(){
    resizeMainWindow();
    $(window).resize(function(){
      resizeMainWindow();
    });
  });
  function resizeMainWindow(){
    var bh = $(window).height() - 60;
    $('#mainWindow').css('height', bh).css('overflow-x', 'auto');
  }
  function search() {
    $.ajax({
      url:'/patients/setFilter.s',
      method:'post',
      data:$('#filterForm').serialize(),
      success: function () {
        document.location = '/main.s';
      }
    });
  }
  function searchRefresh(){
    $('input[name=birthBegin]').val('');
    $('input[name=birthEnd]').val('');
    $('input[name=regDateBegin]').val('');
    $('input[name=regDateEnd]').val('');
    $('input[name=vypDateBegin]').val('');
    $('input[name=vypDateEnd]').val('');
    $('select[name=lv_id]').val('');
    $('select[name=dept_id]').val('');
    search();
  }
  function searchAmb() {
    $.ajax({
      url:'/amb/setFilter.s',
      method:'post',
      data:$('#ambFilterForm').serialize(),
      success: function () {
        document.location = '/main.s';
      }
    });
  }
  function searchRefreshAmb(){
    $('input[name=birthBegin]').val('');
    $('input[name=birthEnd]').val('');
    $('input[name=regDateBegin]').val('');
    $('input[name=regDateEnd]').val('');
    $('select[name=group_id]').val('');
    $('select[name=state]').val('');
    search();
  }
  function openReport(id) {
    openMainPage('/rep/home.s?id=' + id, false);
    return false;
  }
</script>
<style>
  #detailedFilter {border:1px solid #ababab; position:absolute; width:500px; height:300px; border-radius:0 0 5px 5px; background:white;}
  #detailedFilter table tr td {padding:5px;}
</style>
<style>
  .banner tr td:first-child a {text-decoration: none; cursor: pointer}
  #tdLeftMenu {width: 200px; border-right: 1px solid #eee}
</style>
<body style="min-width: 900px" onkeydown="callKeyDown(event)">
<div id="wrapper">
  <div class="banner">
     <table>
       <tr>
         <td style="width: 350px">
           <a href="/setRole.s?id=0">
             <img src="/res/imgs/logo_forux.jpg" style="height:40px; margin-top:2px"/>
             <!--i class="fa fa-user-md fa-3x"></i><span>${clinicName}</span-->
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
             <c:if test="${fn:length(repList) > 0}">
               <li class="dropdown">
                 <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-tasks fa-fw"></i> Отчеты <i class="fa fa-caret-down"></i></a>
                   <ul class="dropdown-menu dropdown-tasks" style="width:460px !important;">
                     <c:forEach items="${repList}" var="r" varStatus="loop">
                       <li><a href="#" onclick="openReport(${r.id});return false;">${r.id} - ${r.name}</a></li>
                       <c:if test="${fn:length(repList) - 1 > loop.index}">
                         <li class="divider"></li>
                       </c:if>
                     </c:forEach>
                   </ul>
               </li>
             </c:if>
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
        <td id="tdLeftMenu" valign="top" style="height:250px;">
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
<c:if test="${session.roleId != 13 && session.roleId != 14 && session.roleId != 15}">
  <div style="display:none" id="detailedFilterFull" class="container">
    <form id="filterForm">
      <table width="95%" class="table" style="margin:auto;">
        <tr>
          <td colspan="2"><h4>Расширенный поиск</h4></td>
        </tr>
        <tr>
          <td>Год рождения</td>
          <td align="right">
            <input type="number" name="birthBegin" class="form-control text-center" value="${sessionScope.ENV.filters['birthBegin']}" style="width:140px; display: inline; height:30px"/>
            -
            <input type="number" name="birthEnd" class="form-control text-center" value="${sessionScope.ENV.filters['birthEnd']}" style="width:140px; display: inline; height:30px">
          </td>
        </tr>
        <tr>
          <td>Дата регистрации</td>
          <td align="right">
            <input type="date" class="form-control text-center" name="regDateBegin" value="${sessionScope.ENV.filters['regDateBegin']}" style="display: inline; width: 140px; height:30px"/>
            -
            <input type="date" class="form-control text-center" name="regDateEnd" value="${sessionScope.ENV.filters['regDateEnd']}" style="display: inline; width: 140px; height:30px"/>
          </td>
        </tr>
        <tr>
          <td>Дата выписки</td>
          <td align="right">
            <input type="date" class="form-control text-center" name="vypDateBegin" value="${sessionScope.ENV.filters['vypDateBegin']}" style="display: inline; width: 140px; height:30px"/>
            -
            <input type="date" class="form-control text-center" name="vypDateEnd" value="${sessionScope.ENV.filters['vypDateEnd']}" style="display: inline; width: 140px; height:30px"/>
          </td>
        </tr>
        <tr>
          <td>Лечащий врач</td>
          <td align="right">
            <select class="form-control" name="lv_id">
              <option value=""></option>
              <c:forEach items="${lvs}" var="lv">
                <option <c:if test="${sessionScope.ENV.filters['lv_id'] == lv.id}">selected</c:if> value="${lv.id}">${lv.fio}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td>Отеделение</td>
          <td align="right">
            <select class="form-control" name="dept_id">
              <option value=""></option>
              <c:forEach items="${depts}" var="dept">
                <option <c:if test="${sessionScope.ENV.filters['dept_id'] == dept.id}">selected</c:if> value="${dept.id}">${dept.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="text-right" style="padding:10px">
            <button type="button" onclick="search()" class="btn btn-success">Поиск</button>
            <button type="button" onclick="searchRefresh()" class="btn btn-default">Очистить</button>
          </td>
        </tr>
      </table>
    </form>
  </div>
</c:if>
<c:if test="${session.roleId == 13 || session.roleId == 14 || session.roleId == 15}">
  <div style="display:none" id="detailedFilterFull" class="container">
    <form id="ambFilterForm">
      <table width="95%" class="table" style="margin:auto;">
        <tr>
          <td colspan="2"><h4>Расширенный поиск</h4></td>
        </tr>
        <tr>
          <td>Год рождения</td>
          <td align="right">
            <input type="number" name="birthBegin" class="form-control text-center" value="${sessionScope.ENV.ambFilters['birthBegin']}" style="width:140px; display: inline; height:30px"/>
            -
            <input type="number" name="birthEnd" class="form-control text-center" value="${sessionScope.ENV.ambFilters['birthEnd']}" style="width:140px; display: inline; height:30px">
          </td>
        </tr>
        <tr>
          <td>Дата регистрации</td>
          <td align="right">
            <input type="date" class="form-control text-center" name="regDateBegin" value="${sessionScope.ENV.ambFilters['regDateBegin']}" style="display: inline; width: 140px; height:30px"/>
            -
            <input type="date" class="form-control text-center" name="regDateEnd" value="${sessionScope.ENV.ambFilters['regDateEnd']}" style="display: inline; width: 140px; height:30px"/>
          </td>
        </tr>
        <tr>
          <td>Группы</td>
          <td align="right">
            <select class="form-control" name="group_id">
              <option value=""></option>
              <c:forEach items="${groups}" var="group">
                <option <c:if test="${sessionScope.ENV.ambFilters['group_id'] == group.id}">selected</c:if> value="${group.id}">${group.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td>Состояние</td>
          <td align="right">
            <select class="form-control" name="state">
              <option value=""></option>
              <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'PRN'}">selected</c:if> value="PRN">Регистрация</option>
              <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'CASH'}">selected</c:if> value="CASH">Ожидание оплаты</option>
              <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'WORK'}">selected</c:if> value="WORK">Оказания услуг</option>
              <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'DONE'}">selected</c:if> value="DONE">Услуги оказаны</option>
              <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'ARCH'}">selected</c:if> value="ARCH">Закрыта</option>

            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="text-right" style="padding:10px">
            <button type="button" onclick="searchAmb()" class="btn btn-success">Поиск</button>
            <button type="button" onclick="searchRefreshAmb()" class="btn btn-default">Очистить</button>
          </td>
        </tr>
      </table>
    </form>
  </div>
</c:if>

</body>
</html>