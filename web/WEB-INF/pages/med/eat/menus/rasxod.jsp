<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid tr th {text-align: center;background: #e8e8e8}
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="row" style="margin:0">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading">
        Меню на <span style="font-weight:bold; color:red"><fmt:formatDate pattern="dd.MM.yyyy" value="${claim.menu.menuDate}"/></span>
        <button  class="btn btn-sm btn-default" onclick="setPage('/eats/claim.s?id=${claim.id}')" style="float:right;margin-top:-5px"><i class="fa fa-check"></i> Заявка</button>
      </div>
      <!-- .panel-heading -->
      <div class="panel-body">
        <fieldset>
          <legend>Расходы по продуктам</legend>
          <table class="table table-bordered miniGrid">
            <tr>
              <th>№</th>
              <th>Наименование</th>
              <th>Кол-во</th>
              <th>Ед. изм</th>
            </tr>
            <c:forEach items="${products}" var="r" varStatus="loop">
              <tr>
                <td class="center" style="width:40px">${loop.index + 1}</td>
                <td>${r.c2}</td>
                <td style="width:150px" class="right"><fmt:formatNumber value="${r.c3}" type = "number"/></td>
                <td style="width:150px">${r.c4}</td>
              </tr>
            </c:forEach>
          </table>
        </fieldset>
        <fieldset>
          <legend>Количество блюд</legend>
          <table class="table table-bordered miniGrid">
            <tr>
              <th>№</th>
              <th>Наименование</th>
              <th>Кол-во</th>
            </tr>
            <c:forEach items="${eats}" var="dd" varStatus="loop">
              <tr>
                <td class="center" style="width:40px">${loop.index + 1}</td>
                <td>${dd.c2}</td>
                <td style="width:150px" class="center"><fmt:formatNumber value="${dd.c3}" type = "number"/></td>
              </tr>
            </c:forEach>
          </table>
        </fieldset>
      </div>
    </div>
  </div>
</div>