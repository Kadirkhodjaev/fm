<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Единицы измерения (только просмотр) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-tachometer"></i></span>
        <div>
          <h2>Единицы измерения</h2>
          <span class="fm-count"><b id="emShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="emSearch" placeholder="Название или категория" oninput="DK.filter('em')" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th style="width:220px">Категория</th>
          <th>Наименование</th>
          <th style="width:130px">Состояние</th>
        </tr>
        </thead>
        <tbody id="emRows">
        <c:forEach items="${list}" var="obj">
          <tr data-s="${obj.id} ${fn:escapeXml(obj.name)} ${fn:escapeXml(obj.cat.name)}" style="cursor:default">
            <td class="mut"><b>${obj.id}</b></td>
            <td class="mut">${obj.cat.name}</td>
            <td><span class="nm">${obj.name}</span></td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="emEmpty" style="display:none"><i class="fa fa-tachometer"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>DK.filter('em');</script>
