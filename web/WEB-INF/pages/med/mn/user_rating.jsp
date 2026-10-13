<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Рейтинг по врачам: услуги специалистов за период --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-user-md"></i></span>
        <div>
          <h2>Рейтинг по врачам</h2>
          <span class="mn-sum">Амбулатория <b><fmt:formatNumber value="${total_a}" type="number"/></b> · Стационар <b><fmt:formatNumber value="${total_s}" type="number"/></b> · Итого <b><fmt:formatNumber value="${total_s + total_a}" type="number"/></b></span>
        </div>
      </div>
      <div class="mn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="mnPeriod('/mn/users.s')"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="urSearch" placeholder="Врач или услуга" oninput="urFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('urTable', 'reyting-vrachey')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="urTable">
        <thead>
        <tr>
          <th class="l">Услуга</th>
          <th style="width:150px">Кол-во</th>
          <th style="width:160px">Сумма</th>
        </tr>
        </thead>
        <c:forEach items="${rows}" var="rw">
          <tbody class="ur-g" data-s="${fn:escapeXml(rw.fio)}">
          <tr class="grp"><td colspan="3"><i class="fa fa-user-md" style="color:#9AA1AC; margin-right:6px"></i>${rw.fio}</td></tr>
          <c:forEach items="${rw.list}" var="ll">
            <tr data-s="${fn:escapeXml(ll.c2)}" style="${ll.c1 == '-1' ? 'font-weight:700' : ''}">
              <td>${ll.c2}</td>
              <td class="c"><fmt:formatNumber value="${ll.c3}" type="number"/></td>
              <td class="n"><fmt:formatNumber value="${ll.c4}" type="number"/></td>
            </tr>
          </c:forEach>
          <tr class="tot"><td colspan="2">Итого</td><td class="n"><fmt:formatNumber value="${rw.price}" type="number"/></td></tr>
          </tbody>
        </c:forEach>
      </table>
      <div class="fm-empty" id="urEmpty" style="display:none"><i class="fa fa-user-md"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  // поиск по врачу показывает всю его группу, по услуге — только совпавшие строки
  function urFilter() {
    var q = $.trim($('#urSearch').val()).toLowerCase(), any = 0;
    $('#urTable tbody.ur-g').each(function () {
      var g = $(this), byDoc = !q || String(g.attr('data-s')).toLowerCase().indexOf(q) >= 0, n = 0;
      g.find('tr[data-s]').each(function () {
        var ok = byDoc || String($(this).attr('data-s')).toLowerCase().indexOf(q) >= 0;
        $(this).toggle(ok);
        if (ok) n++;
      });
      g.toggle(n > 0);
      if (n) any++;
    });
    $('#urEmpty').toggle(!any);
  }
</script>
