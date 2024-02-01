<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>

<div class="panel panel-info w-100 margin-auto">
  <div class="panel-heading">
    <span class="fa fa-user"></span> Пациент - <span class="text-danger bold">${patient.fio} (${patient.client.birthdate != null ? "ДР" : "ГР"}: <c:if test="${patient.client.birthdate != null}"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.client.birthdate}" /></c:if><c:if test="${patient.client.birthdate == null}">${patient.client.birthyear}</c:if>)</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/ambs/patients.s');return false;"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <div class="row mt-20 plr-20">
    <div class="col-lg-4">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-money fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${ent_sum}" type="number"/></p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                К оплате
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="panel panel-success">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-dollar fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${paid_sum}" type="number"/></p>
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
      <div class="panel panel-info">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-caret-down fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value="${discount_sum}" type="number"/></p>
            </div>
          </div>
        </div>
        <a href="#" onclick="return false;">
          <div class="panel-footer announcement-bottom">
            <div class="row">
              <div class="col-xs-12">
                Сумма скидки
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>
  </div>
  <table class="w-100">
    <tr>
      <td class="w-50 plr-20" style="vertical-align: top">
        <h3 class="text-info border-bottom-1 pb-10 bold">Услуги</h3>
        <table class="w-100 p-5 light-table">
          <thead>
            <tr>
              <td class="wpx-40"><b class="fa fa-certificate"></b></td>
              <td>Наименование</td>
              <td class="wpx-150">Сумма</td>
              <td class="wpx-40"><b class="fa fa-trash"></b></td>
            </tr>
          </thead>
          <c:forEach items="${patient_services}" var="s">
            <tr class="hover hand">
              <td class="border-bottom-1 center">
                <img src="/res/imgs/green.gif" alt=""/>
              </td>
              <td class="border-bottom-1">${s.service.name}</td>
              <td class="border-bottom-1 right">${s.price}</td>
              <td class="center">
                <button class="btn btn-danger btn-icon">
                  <i class="fa fa-remove"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
        </table>
        <h3 class="text-info border-bottom-1 pb-10 bold">Оплаты</h3>
        <table class="w-100 p-5 light-table">
          <thead>
            <tr>
              <td>Тип платежа</td>
              <td>Дата и время</td>
              <td>Наличные</td>
              <td>Карта</td>
              <td class="wpx-40"><b class="fa fa-print"></b></td>
              <td class="wpx-40"><b class="fa fa-trash"></b></td>
            </tr>
          </thead>
          <c:forEach items="${pays}" var="pay">
            <tr class="hover hand">
              <td class="center">
                <c:if test="${pay.payType == 'ret'}">Возврат</c:if>
                <c:if test="${pay.payType != 'ret'}">Оплата</c:if>
              </td>
              <td class="center">
                <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${pay.crOn}" />
              </td>
              <td class="right"><fmt:formatNumber value="${pay.cash}" type = "number"/></td>
              <td class="right"><fmt:formatNumber value="${pay.card}" type = "number"/></td>
              <td class="center">
                <button class="btn btn-info btn-icon">
                  <i class="fa fa-print"></i>
                </button>
              </td>
              <td class="center">
                <button class="btn btn-danger btn-icon">
                  <i class="fa fa-remove"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
        </table>
        <h3 class="text-info border-bottom-1 pb-10 bold">Скидки</h3>
        <table class="w-100 p-5 light-table">
          <thead>
            <tr>
              <td>Дата и время</td>
              <td>Сумма</td>
              <td>Описание</td>
              <td class="wpx-40"><b class="fa fa-trash"></b></td>
            </tr>
          </thead>
          <tbody>
          <c:forEach items="${discounts}" var="discount" varStatus="loop">
            <tr>
              <td class="center">
                <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${discount.crOn}" />
              </td>
              <td class="center" colspan="3">
                <fmt:formatNumber value="${discount.summ}" type = "number"/>
              </td>
              <td>
                ${discount.msg}
              </td>
              <td class="center">
                <button class="btn btn-danger btn-icon">
                  <i class="fa fa-remove"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </td>
      <td class="plr-20" style="vertical-align: top">
        <h3 class="text-info border-bottom-1 pb-10 bold">Оплата</h3>
        <table class="w-100">
          <tr>
            <td>Наличный</td>
            <td>Пластиковая карта</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
<!--Услуги -->


