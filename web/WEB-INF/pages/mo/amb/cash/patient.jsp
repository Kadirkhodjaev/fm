<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/jquery.mask.js"></script>
<script src="/res/js/common.js"></script>

<div class="panel panel-info w-100 margin-auto">
  <div class="panel-heading" title="ID : ${patient.id}">
    <span class="fa fa-user"></span> Пациент - <span class="text-danger bold">${patient.fio} (${patient.client.birthdate != null ? "ДР" : "ГР"}: <c:if test="${patient.client.birthdate != null}"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.client.birthdate}" /></c:if><c:if test="${patient.client.birthdate == null}">${patient.client.birthyear}</c:if>)</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/ambs/patients.s');return false;"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <div class="mt-20 plr-20">
    <div class="col-lg-4">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <div class="row">
            <div class="col-xs-6">
              <i class="fa fa-money fa-5x"></i>
            </div>
            <div class="col-xs-6 text-right">
              <input type="hidden" class="money" id="amb_ent_sum_format" value="">
              <p class="announcement-heading" id="amb_ent_sum" style="font-size:20px"><fmt:formatNumber value="${ent_sum}" type="number"/></p>
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
      <td class="plr-20" style="vertical-align: top">
        <c:if test="${ent_sum > 0}">
        <div class="border-bottom-1 mb-20" style="height:58px">
          <h3 class="text-info bold float-left" id="pay_type_name">Оплата</h3>
        </div>
          <table class="w-100">
          <tr>
            <td class="wpx-40">
              <i class="fa fa-money fa-2x"></i>
            </td>
            <td class="text-success vertical-align-middle bold">
              Наличный
            </td>
            <td class="form-group input-group">
              <span class="input-group-addon hand" onclick="setCheck(event, 'cash')">
                <input type="checkbox" class="hand" id="cash_checkbox" onchange="setState('cash')">
              </span>
              <input type="text" class="form-control right money" disabled id="amb_pay_cash" style="font-size:25px" onchange="checkPay('cash')" maxlength="12" value="">
              <span class="input-group-btn">
                <button class="btn btn-default p-10" type="button" id="btn_pay_cash" onclick="setAmbPay('cash')">
                  <i class="fa fa-check"></i>
                </button>
              </span>
            </td>
          </tr>
          <tr>
            <td class="wpx-40">
              <i class="fa fa-credit-card fa-2x"></i>
            </td>
            <td class="text-success vertical-align-middle bold">
              Пластиковая карта
            </td>
            <td class="form-group input-group">
            <span class="input-group-addon hand" onclick="setCheck(event, 'card')">
              <input type="checkbox" class="hand" id="card_checkbox" onchange="setState('card')">
            </span>
              <input type="text" class="form-control right money" disabled id="amb_pay_card" style="font-size:25px" onchange="checkPay('card')" maxlength="12" value="">
              <span class="input-group-btn">
              <button class="btn btn-default p-10" type="button" id="btn_pay_card" onclick="setAmbPay('card')">
                <i class="fa fa-check"></i>
              </button>
            </span>
            </td>
          </tr>
          <tr>
            <td colspan="3" class="text-right">
              <button class="btn btn-success btn-icon" type="button" onclick="savePay()"><i class="fa fa-save"></i> Сохранить</button>
            </td>
          </tr>
        </table>
          <div class="border-bottom-1 mb-20" style="height:58px">
            <h3 class="text-info bold float-left">Скидка</h3>
          </div>
          <table class="w-100">
            <tr>
              <td class="wpx-40">
                <i class="fa fa-suitcase fa-2x"></i>
              </td>
              <td class="text-success vertical-align-middle bold">
                Предоставить скидку
              </td>
              <td class="form-group input-group">
                <span class="input-group-addon">
                  <i class="fa fa-asterisk"></i>
                </span>
                <input type="text" class="form-control right money" id="amb_discount_sum" placeholder="Сумма скидки" style="font-size:25px" maxlength="12" value="">
                <span class="input-group-btn">
                  <button class="btn btn-default p-10" type="button" onclick="saveDiscount()">
                    <i class="fa fa-check"></i>
                  </button>
                </span>
              </td>
            </tr>
          </table>
        </c:if>
      </td>
      <td class="w-60 plr-20" style="vertical-align: top">
        <c:if test="${fn:length(patient_services) > 0}">
          <h3 class="text-info border-bottom-1 pb-10 bold">Услуги</h3>
          <table class="w-100 p-5 light-table">
            <thead>
              <tr>
                <td class="wpx-40"><b class="fa fa-certificate"></b></td>
                <td>Наименование</td>
                <td>Дата обс.</td>
                <td class="wpx-150">Сумма</td>
                <td class="wpx-40"><b class="fa fa-trash"></b></td>
              </tr>
            </thead>
            <c:forEach items="${patient_services}" var="s">
              <tr class="hover hand">
                <td class="border-bottom-1 center">
                  <c:if test="${s.state == 'DEL'}"><img src='/res/imgs/red.gif' alt="" title="Возврат денежных средств. Причина: ${s.msg}"/></c:if>
                  <c:if test="${s.state == 'AUTO_DEL'}"><img src='/res/imgs/yellow.gif' alt="" title="Автоматическое удаление услуги"/></c:if>
                  <c:if test="${s.state == 'PAID' || s.state == 'DONE'}"><img src='/res/imgs/green.gif' alt="" title="<c:if test="${s.state == 'DONE'}">Выполнена</c:if><c:if test="${s.state == 'PAID'}">Оплачена</c:if>"/></c:if>
                  <c:if test="${s.state == 'ENT'}">
                    <button class="btn btn-primary btn-icon" title="Исключить из оплаты" for-pay="Y" id="ser_pay_${s.id}" onclick="setForPay('${s.id}', ${s.dprice})">
                      <i class="fa fa-check"></i>
                    </button>
                  </c:if>
                </td>
                <td class="border-bottom-1">${s.service.name}</td>
                <td class="border-bottom-1 center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${s.planDate}"/></td>
                <td class="border-bottom-1 right">${s.price}</td>
                <td class="center">
                  <c:if test="${s.state == 'ENT' || (s.state != 'DEL' && s.state != 'DONE' && s.state != 'ARCH' && sessionScope.ENV.userId == 1 && s.state != 'AUTO_DEL')}">
                    <button class="btn btn-danger btn-icon" title="<c:if test="${s.state == 'ENT'}">Удалить</c:if><c:if test="${s.state == 'PAID'}">Возврат денежных средств</c:if>" onclick="delService(${s.id}, '${s.state}', ${s.dprice})">
                      <i class="fa fa-remove"></i>
                    </button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </table>
        </c:if>
        <c:if test="${fn:length(pays) > 0}">
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
                <c:if test="${pay.payType == 'pay'}">
                  <button class="btn btn-info btn-icon" onclick="printCheck(1, 'check=' + ${pay.id})">
                    <i class="fa fa-print"></i>
                  </button>
                </c:if>
              </td>
              <td class="center">
                <button class="btn btn-danger btn-icon" onclick="delPay(${pay.id})">
                  <i class="fa fa-remove"></i>
                </button>
              </td>
            </tr>
          </c:forEach>
        </table>
        </c:if>
        <c:if test="${fn:length(discounts) > 0}">
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
              <td class="center" nowrap>
                <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${discount.crOn}" />
              </td>
              <td class="center" nowrap>
                <fmt:formatNumber value="${discount.summ}" type = "number"/>
              </td>
              <td>
                ${discount.text}
              </td>
              <td class="center">
                <c:if test="${sessionScope.ENV.userId == 1}">
                  <button class="btn btn-danger btn-icon" onclick="delDiscount(${discount.id})">
                    <i class="fa fa-remove"></i>
                  </button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
        </c:if>
      </td>
    </tr>
  </table>
</div>
<script>
  let entSum = ${ent_sum}, summ = ${ent_sum}, paid_sum = ${paid_sum}, ss = [];
  $(() => {
    $('.money').mask("# ##0", {reverse: true});
  });
  function setAmbPay(type) {
    if(!getDOM(type + '_checkbox').checked) {
      getDOM(type + '_checkbox').checked = true;
      setState(type);
      return;
    }
    let card = fSum('card'), cash = fSum('cash');
    card = type === 'card' ? 0 : card;
    cash = type === 'cash' ? 0 : cash;
    entSum = summ - card - cash;
    if(entSum === 0) return;
    $('#amb_pay_' + type).val(entSum).trigger('input');
  }
  function checkPay(type) {
    let card =  fSum('card'), cash =  fSum('cash');
    card = type === 'card' ? card : 0;
    cash = type === 'cash' ? cash : 0;
    if(card + cash > summ) $('#amb_pay_' + type).val(0);
    entSum = summ - card - cash;
  }
  function fSum(type) {
    try {
      let s = $('#amb_pay_' + type).val();
      s = Number(s.replace(/\s/g, ''));
      if(isNaN(s)) {
        $('#amb_pay_' + type).val(0);
        return 0;
      }
      return s;
    } catch (e) {
      $('#amb_pay_' + type).val(0);
      return 0;
    }
  }
  function setCheck(evt, id) {
    if(evt.target.tagName != 'INPUT') {
      getDOM(id + '_checkbox').checked = !getDOM(id + '_checkbox').checked;
      setState(id);
    }
  }
  function setState(type) {
    getDOM('amb_pay_' + type).disabled = !getDOM('amb_pay_' + type).disabled;
    $('#amb_pay_' + type).val('');
  }
  function setForPay(id, price) {
    let flag = $('#ser_pay_' + id).attr('for-pay');
    if(flag === 'Y') {
      $('#ser_pay_' + id).removeClass('btn-primary').addClass('btn-danger').attr('for-pay', flag === 'Y' ? 'N' : 'Y');
      $('#ser_pay_' + id).find('i').removeClass('fa-check').addClass('fa-remove');
    } else {
      $('#ser_pay_' + id).removeClass('btn-danger').addClass('btn-primary').attr('for-pay', flag === 'Y' ? 'N' : 'Y');
      $('#ser_pay_' + id).find('i').removeClass('fa-remove').addClass('fa-check');
    }
    summ = summ + (flag === 'Y' ? Number(-price) : Number(price));
    $('#amb_ent_sum_format').val(summ).trigger('input');
    $('#amb_ent_sum').html($('#amb_ent_sum_format').val());
    if(getDOM('cash_checkbox').checked) getDOM('cash_checkbox').click();
    if(getDOM('card_checkbox').checked) getDOM('card_checkbox').click();
    if(flag === 'Y')
      ss.push(id);
    else
      ss.splice(ss.indexOf(id), 1);
  }
  function setPayType(type) {
    $('#pay_type_' + type).removeClass('bold');
    $('#pay_type_' + type).addClass('disabled');
    $('#pay_type_' + (type === 'pay' ? 'ret' : 'pay')).removeClass('disabled');
    $('#pay_type_' + (type === 'pay' ? 'ret' : 'pay')).addClass('bold');
    $('#pay_type_name').html(type === 'ret' ? 'Возврат' : 'Оплата');
    $('#amb_pay_type').val(type);
  }
  // API
  function reloadPage() {
    setPage('/cash/amb/patient.s?id=${patient.id}');
  }
  function saveDiscount() {
    let s = $('#amb_discount_sum').val();
    if(s === '' || s === 0 || s === null) {
      openMedMsg('Нельзя предоставить скидку! Ошибка в поле "Сумма скидки"', false);
      return;
    }
    console.log(s)
    s = Number(s.replace(/\s/g, ''));
    console.log(s)
    console.log(summ)
    if(s > summ) {
      openMedMsg('Сумма скидки не может быть больше "К оплате"', false);
      return;
    }
    let msg = prompt('Основания для скидки')
    if(msg.length > 5) {
      $.ajax({
        url: '/cash/amb/discount.s',
        method: 'post',
        data: 'id=${patient.id}&sum=' + s + '&text=' + encodeURIComponent(msg),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) reloadPage();
        }
      });
    }
  }
  function delDiscount(id) {
    if(confirm('Вы действительно хотите удалить скидку?')) {
      $.ajax({
        url: '/cash/amb/discount/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) reloadPage();
        }
      });
    }
  }
  function savePay() {
    let card = fSum('card'), cash = fSum('cash');
    if(card + cash === 0) {
      openMedMsg('Сумма платежа не может быть 0', false);
      return;
    }
    if (card + cash !== summ) {
      openMedMsg('Сумма не верна. Проверьте правильности итоговой суммы', false);
      return;
    }
    let params = 'id=${patient.id}&card=' + card + '&cash=' + cash + '&pay_type=pay';
    for(let id of ss) params += '&ss=' + id;
    $.ajax({
      url: '/cash/amb/pay.s',
      method: 'post',
      data: params,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) reloadPage();
      }
    });
  }
  function delPay(id) {
    if(confirm('Вы действительно хотите удалить платеж?'))
      $.ajax({
        url: '/cash/amb/pay/del.s',
        method: 'post',
        data: 'patient=${patient.id}&id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) reloadPage();
        }
      });
  }
  function printCheck(id, param) {
    let form = $('<form action="/print/index.s" method="post" target="_blank"></form>');
    let idx = $('<input name="print_page_id" type="hidden" value="' + id + '"/>');
    let params = $('<input name="params" type="hidden" value="' + param + '"/>');
    form.append(idx).append(params);
    $('body').append(form);
    form.submit();
    form.remove();
  }
  function delService(id, state, price) {
    if (state === 'PAID') {
      if (confirm('Оформить как возврат денежных средств?')) {
        let msg = prompt('Причина возврата денег');
        if (msg != null && msg.length > 0) {
          let params = 'id=${patient.id}&service=' + id + '&cash=' + price + '&pay_type=ret&msg=' + encodeURIComponent(msg);
          $.ajax({
            url: '/cash/amb/pay.s',
            method: 'post',
            data: params,
            dataType: 'json',
            success: function (res) {
              openMsg(res);
              if(res.success) reloadPage();
            }
          });
        }
      }
    } else {
      if (confirm('Вы действительно хотите удалить услугу?')) {
        $.ajax({
          url: '/ambs/patient/del-service.s',
          method: 'post',
          data: 'id=' + id,
          dataType: 'json',
          success: function (res) {
            openMsg(res);
            if(res.success) reloadPage();
          }
        });
      }
    }
  }
</script>


