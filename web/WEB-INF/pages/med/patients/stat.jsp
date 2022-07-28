<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .table tr:hover {background:#e8e8e8}
</style>
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
              <p class="announcement-heading" style="font-size:50px">${cur}</p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Количество текущих пациентов
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
            <div class="col-xs-6">
              <i class="fa fa-users fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:50px">${vyp}</p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Количество выписанных пациентов
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
              <p class="announcement-heading" style="font-size:50px">${curMonth}</p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Количество пациентов за месяц
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
              <p class="announcement-heading" style="font-size:50px">${curYear}</p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Количество пациентов за год
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
          <td style="text-align:center;padding:5px;">Лечаший врач</td>
          <td style="text-align:center;padding:5px;" width="110">Регистрация</td>
          <td style="text-align:center;padding:5px;" width="80">Выписка</td>
          <td style="text-align:center;padding:5px;" width="60">Всего</td>
        </tr>
        <c:forEach items="${lvs}" var="lv">
          <tr style="<c:if test="${lv.c1 == '0'}">font-weight: bold;</c:if>">
            <td style="padding:5px"><i class="fa fa-user fa-fw"></i> ${lv.c2}</td>
            <td style="padding:5px"><span class="pull-right text-muted"><c:if test="${lv.c3 != '0'}">${lv.c3}</c:if></span></td>
            <td style="padding:5px"><span class="pull-right text-muted"><c:if test="${lv.c4 != '0'}">${lv.c4}</c:if></span></td>
            <td style="padding:5px"><span class="pull-right text-muted"><c:if test="${lv.c5 != '0'}">${lv.c5}</c:if></span></td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</div>
