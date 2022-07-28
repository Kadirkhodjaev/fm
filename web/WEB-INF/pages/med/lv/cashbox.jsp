<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .table tr:hover {background:#e8e8e8}
</style>
<div style="padding:15px;">
  <div class="row">
    <div class="col-lg-4">
      <div class="panel panel-success">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-money fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${paid}" type = "number"/></p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Оплаченная сумма
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-money fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${total - paid}" type = "number"/></p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Сумма к оплате
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="panel panel-info">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-money fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${total}" type = "number"/></p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                ИТОГО
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <!-- /.panel-heading -->
      <table class="table table-bordered" width="100%">
        <tr style="font-weight:bold;background:#f1f1f1">
          <td style="text-align:center;padding:5px;">Наименование</td>
          <td style="text-align:center;padding:5px;" width="110">Сумма</td>
        </tr>
        <c:forEach items="${services}" var="ser">
          <tr style="<c:if test="${lv.c1 == '0'}">font-weight: bold;</c:if>">
            <td style="padding:5px"><i class="fa fa-user fa-fw"></i> ${ser.c1}</td>
            <td style="padding:5px"><span class="pull-right text-muted"><fmt:formatNumber value="${ser.c2}" type = "number"/></span></td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</div>