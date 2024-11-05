<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function openUrl(dom){
    $('.leftMenu li').attr("class", "");
    dom.className = "active";
    lvContent.location = dom.id;
    var o = dom.getAttribute("ord");
    $('#saveForm').css('display', (o == 1 && ${sessionScope.ENV.roleId} === 6) || o == 2 || o == 4 || o == 5 || o == 6 || o == 7 || o == 8 || o == 9 || o == 10 || o == 11 || o == 12 ||o == 13 || o == 16 ? 'inline' : "none");
    $('#planResult').css('display', o == 10 ? 'inline' : "none");
    $('#planResultPage').css('display', o == 6 || o == 8  ? 'inline' : "none");
    $('#statCard').css('display', o == 9  ? 'inline' : "none");
    <c:if test="${p.paid != 'CLOSED'}">
      $('#planAdd').css('display', o == 10 ? 'inline' : "none");
    </c:if>
    <c:if test="${p.paid != 'CLOSED'}">
      $('#printBtn').css('display', o == 1 || o == 2 || o == 18 || o == 9 || o == 15 || o == 21 ? 'none' : 'inline');
    </c:if>
    <c:if test="${p.paid == 'CLOSED'}">
      $('#printBtn').css('display', o == 1 || o == 2 || o == 18 ? 'none' : 'inline');
    </c:if>
    if(dom.id.indexOf('view/vypiska.s') != -1 && '${p.state}' === 'ARCH') {
      $('#statCard').css('display', 'inline');
    }
    if((dom.id.indexOf('drug/index.s') != -1 || dom.id.indexOf('drugs.s') != -1) && '${p.state}' === 'ARCH') {
      $('#printBtn').css('display', 'none');
    }
  }
  function saveForm(){
    lvContent.document.getElementById("saveBtn").click();
  }
  function back(){
    openMainPage('${backUrl}', true);
  }
  function resizeFrame() {
    $('#lvContent').height($(document).height() - 110);
  }
  $(document).ready(function(){
    $(window).resize(function(){resizeFrame();});
    resizeFrame();
    openUrl(document.getElementById('${formUrl}'));
  });
  function setPrint(){
    //table
    var url = '' + lvContent.location, dairyIds = '';
    if(url.indexOf('/lv/dairy.s') > -1) {
      $('#lvContent').contents().find('input[name=dairy]:checked').each(function(){
        dairyIds += $(this).attr('dairy') + ',';
      });
      if(dairyIds.length > 0)
        dairyIds = '?dairyIds=' + dairyIds;
    }
    if(url.indexOf('drug') !== -1 && '${table}' === '') {
      alert('Питание не установлено! Установите питание перед распечаткой');
      return;
    }
    window.open('/lv/print.s' + dairyIds);
  }
  function setReg(){
    openMainPage('/reg/nurse/index.s?reg=Y', true);
  }
  function setBooking() {
    openMainPage('/booking/index.s?history=${p.id}', true);
  }
</script>
<table width="100%" height="100%">
  <td id="tdLeftMenu" valign="top" style="border-top:1px solid #eee; background: #f8f8f8">
    <ul class="leftMenu">
      <c:forEach items="${menuList}" var="m">
        <li style="padding: 5px" ord="${m.ord}" class="${m.state}" onclick="openUrl(this)" id="${m.url}">
          <i class="${m.icon}"></i> ${m.name}
        </li>
      </c:forEach>
      <li style="padding: 5px" onclick="back()"><i class="fa fa-reply fa-fw"></i> Назад</li>
    </ul>
  </td>
  <td style="background: #fff" valign="top">
    <div class="banner" style="padding:1px; height:32px; border-top: 1px solid #eee">
      <table width="100%">
        <tr>
          <td class="bold">
            <div style="font-size:20px; margin-top: -12px; color: #337ab7" title="ID: ${p.id}" >
              ИБ №${p.yearNum} - ${p.surname}&nbsp;${p.name}&nbsp;${p.middlename}-
              Статус кассы: <c:if test="${p.paid != 'CLOSED'}"><span style="font-weight:bold;top:0;left:0;color:red">Открыт</span></c:if><c:if test="${p.paid == 'CLOSED'}"><span style="font-weight:bold;top:0;left:0;color:green">Закрыт</span></c:if>
            </div>
          </td>
          <td width="500px" class="right">
            <ul class="pagination">
              <li class="paginate_button" id="statCard" tabindex="0" style="display:none; width: 100px !important;"><a href="#" onclick="window.open('lv/print.s?statcard=Y'); return false;"><i title="Стат карта" class="fa fa-file"></i> Стат карта</a></li>
              <li class="paginate_button" id="planResultPage" tabindex="0" style="display:none; width: 100px !important;"><a href="#" onclick="window.open('lv/plan.s?new=Y'); return false;"><i title="Результаты всех обследования" class="fa fa-flask"></i> Результаты</a></li>
              <li class="paginate_button" id="planResult" tabindex="0" style="display:none; width: 100px !important;"><a href="#" onclick="lvContent.location = '/lv/plan.s';return false;"><i title="Результаты всех обследования" class="fa fa-flask"></i> Результаты</a></li>
              <li class="paginate_button" id="planAdd" tabindex="0" style="display:none; width: 100px !important;"><a href="#" onclick="lvContent.location = '/lv/plan/kdos.s';return false;"><i title="Добавить новое обследование" class="fa fa-plus"></i> Добавить</a></li>
              <li class="paginate_button" id="saveForm" tabindex="0" style="display:none; width: 100px !important;"><a href="#" onclick="saveForm();return false;"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
              <li class="paginate_button" id="printBtn" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setPrint();return false;"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
              <%--<c:if test="${roleId == 3}">
                <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setReg();return false;"><i title="Печать" class="fa fa-pencil"></i> Регистрация</a></li>
              </c:if>--%>
              <c:if test="${roleId == 17}">
                <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setBooking();return false;"><i title="Бронирование" class="fa fa-pencil"></i> Бронирование</a></li>
              </c:if>
              <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="back();return false;"><i title="Назад" class="fa fa-reply"></i> Назад</a></li>
            </ul>
          </td>
        </tr>
      </table>
    </div>
    <div>
      <iframe style="width: 100%; height: 400px; border:0" id="lvContent" name="lvContent" ></iframe>
    </div>
  </td>
</table>
