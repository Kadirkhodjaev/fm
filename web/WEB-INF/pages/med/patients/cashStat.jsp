<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .table tr:hover {background:#e8e8e8}
</style>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/patients/cashStat.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function openDetails(code) {
    $('#cash_details_form_start').val($('#period_start').val());
    $('#cash_details_form_end').val($('#period_end').val());
    $('#cash_details_form_type').val(code);
    cash_details_form.submit();
  }
</script>
<form target="_blank" method="post" action="/rep/run.s" name="cash_details_form">
  <input type="hidden" name="repId" value="35"/>
  <input type="hidden" id="cash_details_form_start" name="period_start" value=""/>
  <input type="hidden" id="cash_details_form_end" name="period_end" value=""/>
  <input type="hidden" id="cash_details_form_type" name="type" value=""/>
</form>
<div class="panel panel-info">
  <!-- /.panel-heading -->
  <div class="panel-heading bold">
    Услуги итого: <span style="font-weight:bold; color:red; font-size:15px"><fmt:formatNumber value="${obj.c10 + obj.c20}" type = "number"/></span>
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
      <td style="">
        <button onclick="setCashStat()" class="btn btn-success">Поиск</button>
      </td>
    </tr>
  </table>
</div>
<div class="panel panel-info">
  <!-- /.panel-heading -->
  <div class="panel-heading bold">
    Амбулатория итого: <a href="#" onclick="openDetails('amb'); return false"><span style="font-weight:bold; color:red; font-size:15px"><fmt:formatNumber value="${obj.c20}" type = "number"/></span></a>
  </div>
  <div style="padding:15px;">
    <div class="row">
      <div class="col-lg-3">
        <div class="panel panel-info">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c1}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Карта
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
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c3}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Перечисление
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
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c4}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Наличные
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="panel panel-info">
  <!-- /.panel-heading -->
  <div class="panel-heading bold">
    Стационар итого: <a href="#" onclick="openDetails('stat'); return false"><span style="font-weight:bold; color:red; font-size:15px"><fmt:formatNumber value="${obj.c10}" type = "number"/></span></a>
  </div>
  <div style="padding:15px;">
    <div class="row">
      <div class="col-lg-3">
        <div class="panel panel-info">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c5}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Карта
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
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c7}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Перечисление
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
              <div class="col-xs-6">
                <i class="fa fa-users fa-5x"></i>
              </div>
              <div class="col-xs-6 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${obj.c8}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Наличные
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>