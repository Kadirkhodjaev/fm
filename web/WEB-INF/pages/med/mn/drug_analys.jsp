<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Расчет
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">Сальдо</th>
        <th style="vertical-align: middle">Приход</th>
        <th style="vertical-align: middle">Ручной ввод</th>
        <th style="vertical-align: middle">Стационар</th>
        <th style="vertical-align: middle">Общий расход</th>
        <th style="vertical-align: middle">Остаток</th>
      </tr>
      </tr>
      <tr>
        <td class="center"><fmt:formatNumber value="${saldoCount}" type="number"/></td>
        <td class="center"><fmt:formatNumber value="${inCount}" type="number"/></td>
        <td class="center"><fmt:formatNumber value="${ssCount}" type="number"/></td>
        <td class="center"><fmt:formatNumber value="${poutCount}" type="number"/></td>
        <td class="center"><fmt:formatNumber value="${outCount}" type="number"/></td>
        <td class="center"><fmt:formatNumber value="${saldoCount + inCount + ssCount - outCount - poutCount}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Остатки по складам
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">Склад</th>
        <th style="vertical-align: middle">Остаток</th>
      </tr>
      </tr>
      <c:forEach items="${osts}" var="rw">
        <tr>
          <td>${rw.c1}</td>
          <td class="center"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td></td>
        <td class="center bold"><fmt:formatNumber value="${ostCount}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Сальдо на начала
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">Кол-во</th>
        <th style="vertical-align: middle">Стоимость</th>
        <th style="vertical-align: middle">Сумма</th>
      </tr>
      <c:forEach items="${saldos}" var="rw">
        <tr>
          <td class="center"><fmt:formatNumber value="${rw.c1}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Приход
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">Поставщик</th>
        <th style="vertical-align: middle">Дата</th>
        <th style="vertical-align: middle">Кол-во</th>
        <th style="vertical-align: middle">Стоимость</th>
        <th style="vertical-align: middle">Сумма</th>
      </tr>
      <c:forEach items="${ins}" var="rw">
        <tr>
          <td class="center">${rw.c5}</td>
          <td class="center">${rw.c4}</td>
          <td class="center"><fmt:formatNumber value="${rw.c1}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td></td>
        <td></td>
        <td class="center bold"><fmt:formatNumber value="${inCount}" type="number"/></td>
        <td></td>
        <td class="center bold"><fmt:formatNumber value="${inSum}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Ручной ввод сальдо
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">№</th>
        <th style="vertical-align: middle">Склад</th>
        <th style="vertical-align: middle">ФИО</th>
        <th style="vertical-align: middle">Дата</th>
        <th style="vertical-align: middle">Кол-во</th>
        <th style="vertical-align: middle">Кол-во учет</th>
      </tr>
      <c:forEach items="${sss}" var="rw" varStatus="loop">
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${rw.c5}</td>
          <td class="center">${rw.c1}</td>
          <td class="center">${rw.c2}</td>
          <td class="center"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td colspan="2" class="center bold"><fmt:formatNumber value="${ssCount}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Расход по пациентам
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">№</th>
        <th style="vertical-align: middle">Склад</th>
        <th style="vertical-align: middle">ФИО</th>
        <th style="vertical-align: middle">Дата</th>
        <th style="vertical-align: middle">Кол-во</th>
        <th style="vertical-align: middle">Кол-во учет</th>
      </tr>
      <c:forEach items="${pouts}" var="rw" varStatus="loop">
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${rw.c5}</td>
          <td>${rw.c1}</td>
          <td class="center">${rw.c2}</td>
          <td class="center"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td colspan="2" class="center bold"><fmt:formatNumber value="${poutCount}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Общий расход
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th style="vertical-align: middle">№</th>
        <th style="vertical-align: middle">Склад</th>
        <th style="vertical-align: middle">Категория</th>
        <th style="vertical-align: middle">Дата</th>
        <th style="vertical-align: middle">Кол-во</th>
        <th style="vertical-align: middle">Кол-во учет</th>
      </tr>
      <c:forEach items="${outs}" var="rw" varStatus="loop">
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${rw.c5}</td>
          <td class="center">${rw.c4}</td>
          <td class="center">${rw.c1}</td>
          <td class="center"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
          <td class="center"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td colspan="2" class="center bold"><fmt:formatNumber value="${outCount}" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
