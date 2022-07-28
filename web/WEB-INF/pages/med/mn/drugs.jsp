<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/mn/drugstore.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Аптека (Основной склад)
  </div>
  <table class="table table-bordered">
    <tr>
      <td style="width:100px; font-weight:bold; padding:10px; text-align:right">Период:</td>
      <td style="width:140px;padding:5px">
        <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
      </td>
      <td style="width:20px;padding:10px">
        -
      </td>
      <td style="width:140px;padding:5px">
        <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
      </td>
      <td style="vertical-align: middle">
        <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
      </td>
    </tr>
  </table>
  <div class="panel-body">
    <div class="row">
      <div class="col-lg-3">
        <div class="panel panel-info">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${saldo_in}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на начало
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-success">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${income_sum}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Приход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-green">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${outcome_sum}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Расход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-default">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${saldo_out}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на конец
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 100%; margin-top:10px">
  <div class="panel-heading">
    Дополнительные склады
  </div>
  <div class="panel-body">
    <div class="row">
      <div class="col-lg-3">
        <div class="panel panel-info">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${hn_saldo_in}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на начало
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-success">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${hn_day_in}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Приход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-green">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${hn_day_out}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Расход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-default">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${hn_saldo_out}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на конец
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
  <!-- /.panel-body -->
</div>
<style>
  table tr th {text-align: center; background:#e8e8e8}
</style>
<div class="panel panel-info" style="width: 100%; margin-top:10px">
  <div class="panel-heading">
    Список препартов
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <tr>
        <th>Наименование</th>
        <th>Сальдо на начала</th>
        <th>Сальдо на начала</th>
        <th>Приход</th>
        <th>Приход</th>
        <th>Приход</th>
        <th>Приход</th>
        <th>Приход</th>
        <th>Приход</th>
      </tr>
      <c:forEach items="${rows}" var="p">
        <tr>
          <td>${p.c1}</td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c2}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c3}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c4}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c5}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c6}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c7}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c8}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c9}"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td>&nbsp;</td>
        <td colspan="4" class="bold">ИТОГО</td>
        <td class="bold right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></td>
      </tr>
    </table>
  </div>
</div>


<%--<div class="panel panel-info" style="width: 100%; margin-top:10px">
  <div class="panel-heading">
    Предтоящие оплаты по пациентам
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <tr>
        <th>№ ИБ</th>
        <th>ФИО</th>
        <th>Дата рег</th>
        <th>Дата вып</th>
        <th>Год рождения</th>
        <th>Сумма</th>
      </tr>
      <c:forEach items="${patients}" var="p">
        <tr>
          <td class="center">${p.c4}</td>
          <td>${p.c1}</td>
          <td class="center">${p.c2}</td>
          <td class="center">${p.c3}</td>
          <td class="center">${p.c5}</td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c6}"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td>&nbsp;</td>
        <td colspan="4" class="bold">ИТОГО</td>
        <td class="bold right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></td>
      </tr>
    </table>
  </div>
</div>--%>
<iframe style="display: none" name="drug_excel"></iframe>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>
