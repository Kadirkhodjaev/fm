<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script>
  var totalSum = ${serviceTotal};
  function delService(id, state) {
    if (state == 'PAID') {
      if (confirm('Возврат денег?')) {
        var msg = prompt('Причина возврата денег');
        if (msg != null && msg.length > 0) {
          $.ajax({
            url: '/amb/delSer.s',
            method: 'post',
            data: 'id=' + id + '&msg=' + encodeURIComponent(msg),
            dataType: 'json',
            success: function (res) {
              if (res.success) {
                setPage('/cashbox/amb.s?id=${patient.id}');
              }
            }
          });
        }
      }
    } else {
      if (confirm('Вы действительно хотите удалить?')) {
        $.ajax({
          url: '/amb/delSer.s',
          method: 'post',
          data: 'id=' + id,
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              setPage('/cashbox/amb.s?id=${patient.id}');
            }
          }
        });
      }
    }
  }
  function printCheck(id) {
    window.open('/amb/print.s?check=' + id);
  }
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading bold">
    Реквизиты пациента <span style="color:red">ID: ${patient.id}</span>
    <c:if test="${serviceTotalSum == 0}">
      <button type="button" class="btn btn-info" style="float:right; height:25px; padding:1px 10px" onclick="printCheck(0)"><b class="fa fa-print"></b> Чек</button>
    </c:if>
  </div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td class="right bold" nowrap>ФИО<d></d>:</td>
        <td colspan="3">
          ${patient.surname} ${patient.name} ${patient.middlename}
        </td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="birthyear"/>:</td>
        <td>${patient.birthyear}</td>
        <td class="right bold" nowrap><ui:message code="sex"/>:</td>
        <td>${patient.sex.name}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="phone"/>:</td>
        <td>${patient.tel}</td>
        <td class="right bold" nowrap><ui:message code="passportInfo"/>:</td>
        <td>${patient.passportInfo}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap>Резиденство:</td>
        <td>${country}</td>
        <td class="right bold" nowrap>Область:</td>
        <td>${region}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="address"/>:</td>
        <td colspan="3">${patient.address}</td>
      </tr>
    </table>
  </div>
  <div class="panel panel-info" style="margin-left:-1px; width: 800px !important;">
    <div class="panel-heading bold">
      Услуги<c:if test="${fn:length(ds) > 0}"> и медикаменты</c:if>
    </div>
    <div>
      <table class="table table-bordered">
        <tr>
          <td class="center bold">№</td>
          <td class="center bold">#</td>
          <td class="center bold">Наименование</td>
          <td class="center bold">Сумма</td>
          <td class="center bold">Врач</td>
          <c:if test="${patient.state != 'ARCH'}">
            <td class="center bold" style="width: 30px">Удалить</td>
          </c:if>
        </tr>
        <c:forEach items="${services}" var="ser" varStatus="loop">
          <tr id="ser${ser.id}">
            <td class="center">${loop.index + 1}</td>
            <td class="center">
              <c:if test="${ser.state == 'DEL'}"><span style="color:red;font-weight:bold">Возврат</span></c:if>
              <c:if test="${ser.state == 'AUTO_DEL'}"><span style="color:red;font-weight:bold">Удален</span></c:if>
              <c:if test="${ser.state == 'DONE'}"><img src='/res/imgs/green.gif'/></c:if>
              <%--<c:if test="${ser.state == 'ENT'}"><img src='/res/imgs/red.gif'/></c:if>--%>
              <c:if test="${ser.state == 'PAID' && ser.result.id == 0}">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Сделать не оплаченным" onclick="setServicePayState('ret', ${ser.id})"><span class="fa fa-remove"></span></button>
              </c:if>
              <c:if test="${ser.state == 'ENT'}">
                <button class="btn btn-success btn-sm" style="height:20px;padding:1px 10px" title="Сделать оплаченным" onclick="setServicePayState('pay', ${ser.id})"><span class="fa fa-check"></span></button>
              </c:if>
            </td>
            <td <c:if test="${ser.state == 'ENT'}">style="color:red"</c:if>>
                ${ser.service.name}
            </td>
            <td class="right" style="padding-right:7px">${ser.price}</td>
            <td class="center">${ser.users[0].fio}</td>
            <c:if test="${patient.state != 'ARCH'}">
              <td class="center">
                <c:if test="${ser.state == 'ENT' || (ser.state != 'DEL' && ser.state != 'DONE' && set.state != 'ARCH' && is_admin && ser.state != 'AUTO_DEL')}">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delService(${ser.id}, '${ser.state}')"><span class="fa fa-minus"></span></button>
                </c:if>
              </td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${serviceTotalSum > 0}">
          <tr style="font-weight: bold">
            <td class="center">&nbsp;</td>
            <td class="center">&nbsp;</td>
            <td>ИТОГО к оплате</td>
            <td class="right" style="padding-right:7px">
              <fmt:formatNumber value = "${serviceTotalSum}" type = "number"/>
            </td>
            <td class="center">&nbsp;</td>
            <td class="center">&nbsp;</td>
          </tr>
        </c:if>
      </table>
      <table class="table table-bordered">
        <tr>
          <td class="center bold">№</td>
          <td class="center bold">Наименование</td>
          <td class="center bold">Кол-во</td>
          <td class="center bold">Цена</td>
          <td class="center bold">Сумма</td>
        </tr>
        <c:forEach items="${drugs}" var="drug" varStatus="loop">
          <tr>
            <td class="center">${loop.index + 1}</td>
            <td>
                ${drug.drug.name}
            </td>
            <td class="right" style="padding-right:7px">${drug.rasxod}</td>
            <td class="right" style="padding-right:7px"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${drug.hndrug.outRow.price}" type = "number"/></td>
            <td class="right" style="padding-right:7px"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${drug.rasxod * drug.hndrug.outRow.price}" type = "number"/></td>
          </tr>
        </c:forEach>
        <c:if test="${drugSums > 0}">
          <tr style="font-weight: bold">
            <td class="center">&nbsp;</td>
            <td colspan="3">ИТОГО</td>
            <td class="right" style="padding-right:7px">
              <fmt:formatNumber value = "${drugSums}" type = "number"/>
            </td>
          </tr>
        </c:if>
      </table>
      <c:if test="${fn:length(pays) > 0}">
        <table class="table table-bordered">
          <tr>
            <td class="center bold">Тип</td>
            <td class="center bold">Дата</td>
            <td class="center bold">Наличные</td>
            <td class="center bold">Карта</td>
            <td class="center bold">Перечисление</td>
            <td width="80px" class="center bold">Чек</td>
            <td width="80px" class="center bold">Удалить</td>
          </tr>
          <c:forEach items="${pays}" var="pay">
            <tr>
              <td align="center">
                <c:if test="${pay.payType == 'ret'}">Возврат</c:if>
                <c:if test="${pay.payType != 'ret'}">Оплата</c:if>
              </td>
              <td align="center">
                <fmt:formatDate pattern = "dd.MM.yyyy" value = "${pay.crOn}" />
              </td>
              <td align="center"><fmt:formatNumber value="${pay.cash}" type = "number"/></td>
              <td align="center"><fmt:formatNumber value="${pay.card}" type = "number"/></td>
              <td align="center"><fmt:formatNumber value="${pay.transfer}" type = "number"/></td>
              <td class="center">
                <button type="button" class="btn btn-info" style="height:20px;padding:0 10px" onclick="printCheck(${pay.id})"><b class="fa fa-print"></b></button>
              </td>
              <td align="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" onclick="delCashOper(${pay.id})">
                  <span class="fa fa-minus"></span>
                </button>
              </td>
            </tr>
          </c:forEach>
          <c:forEach items="${discounts}" var="discount" varStatus="loop">
            <tr>
              <td align="center">
                Скидка
              </td>
              <td align="center">
                <a href="#" onclick="addEditDiscount(${discount.id})" title="Редактировать">
                  <fmt:formatDate pattern = "dd.MM.yyyy" value = "${discount.crOn}" />
                </a>
              </td>
              <td align="center" colspan="3"><fmt:formatNumber value="${discount.summ}" type = "number"/></td>
              <td align="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDiscount(${discount.id})"><span class="fa fa-minus"></span></button>
              </td>
            </tr>
          </c:forEach>
        </table>
      </c:if>
    </div>
    <c:if test="${serviceTotalSum > 0 || paidSum > 0}">
      <div class="panel-heading">
        Оплата. Итоговая сумма к оплате <span id="totalSumSpan" style="color:red;font-weight:bold"></span>
        <c:if test="${patient.state != 'ARCH'}">
          <ul class="pagination" style="float:right; margin-top:-5px">
            <li class="paginate_button" style="display:none" id="discount_add" tabindex="0"><a href="#" onclick="addEditDiscount(0);return false"><i title="Добавить скидку" class="fa fa-plus"></i> Добавить</a></li>
            <li class="paginate_button" tabindex="0"><a href="#" onclick="calcTotal(); return false;"><i title="Расчет" class="fa fa-print"></i> Расчет</a></li>
            <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="saveForm();return false;"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
          </ul>
        </c:if>
      </div>
      <ul class="nav nav-tabs">
        <input name="pay_type" value="<c:if test="${serviceTotalSum > 0}">pay</c:if><c:if test="${serviceTotalSum == 0 && paidSum > 0}">ret</c:if>" id="pay_type" type="hidden"/>
        <c:if test="${serviceTotalSum > 0}">
          <li class="active"><a href="#pager" onclick="setPayType('pay')" data-toggle="tab" aria-expanded="true">Опалата</a></li>
        </c:if>
        <c:if test="${paidSum > 0}">
          <li class=""><a href="#pager" onclick="setPayType('ret')" data-toggle="tab" aria-expanded="false">Возврат</a></li>
        </c:if>
        <c:if test="${serviceTotalSum > 0}">
          <li class=""><a href="#discount" onclick="setPayType('discount')" data-toggle="tab" aria-expanded="false">Скидки</a></li>
        </c:if>
      </ul>
      <div class="tab-content">
        <div class="tab-pane active fade in" id="pager">
          <table class="table table-bordered">
            <tr>
              <td class="center">
                <input type="checkbox" id="cardCheck" tabindex="-1" onchange="setPay('card', this)" />
              </td>
              <td class="center bold">Пластиковая карта</td>
              <td class="center">
                <input class="form-control center" style="font-size:20px" id="cardInput" onblur="calcSum(this)" type="number" value="" readonly />
              </td>
            </tr>
            <tr>
              <td class="center">
                <input type="checkbox" id="cashCheck" tabindex="-1" onclick="setPay('cash', this)"/>
              </td>
              <td class="center bold">Наличные</td>
              <td class="center">
                <input  class="form-control center" style="font-size:20px" id="cashInput" readonly onblur="calcSum(this)" type="number"/>
              </td>
            </tr>
            <tr>
              <td class="center">
                <input type="checkbox" id="transferCheck" tabindex="-1" onclick="setPay('transfer', this)"/>
              </td>
              <td class="center bold">Печисление</td>
              <td class="center">
                <input  class="form-control center" style="font-size:20px" id="transferInput" readonly onblur="calcSum(this)" type="number"/>
              </td>
            </tr>
            <tr>
              <td class="center">
                &nbsp;
              </td>
              <td class="center bold">ИТОГО</td>
              <td class="center">
                <input class="form-control center" style="font-size:20px" id="totalInput" readonly/>
              </td>
            </tr>
          </table>
        </div>
        <div class="tab-pane fade" id="discount">
          <table class="table table-bordered">
            <tr>
              <td width="50px" class="center bold">№</td>
              <td width="120px" class="center bold">Дата</td>
              <td class="center bold">Описание</td>
              <td class="center bold">Сумма</td>
              <td width="150px" class="center bold">Пользователь</td>
              <td width="100px" class="center bold">#</td>
            </tr>
            <c:forEach items="${discounts}" var="discount" varStatus="loop">
              <tr class="hover hand" ondblclick="addEditDiscount(${discount.id})">
                <td class="center">${loop.index + 1}</td>
                <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${discount.crOn}" /></td>
                <td>${discount.text}</td>
                <td class="right"><fmt:formatNumber value = "${discount.summ}" type = "number"/></td>
                <td nowrap class="center">${discount.crBy.fio}</td>
                <td nowrap class="center">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDiscount(${discount.id})"><span class="fa fa-minus"></span></button>
                </td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </div>
    </c:if>
  </div>
</div>
<!-- Add Edit Discount -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты скидки</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="AMB" />
          <input type="hidden" name="patient" value="${patient.id}" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Сумма скидки*:</td>
              <td>
                <input type="number" class="form-control right" maxlength="20" name="summ"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Описание:</td>
              <td>
                <textarea class="form-control" name="text" maxlength="200"></textarea>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveDiscount()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  var totalSum = ${serviceTotalSum}, paidSum = ${paidSum}, discountSumm = ${discountSum};
  $(function() {
    $('#totalSumSpan').html('<fmt:formatNumber value = "${serviceTotalSum}" type = "number"/>');
  });
  function setPay(type, dom) {
    var elem = document.getElementById(type + 'Input');
    if (dom.checked) {
      elem.removeAttribute("readonly");
    } else {
      dom.removeAttribute("checked");
      elem.setAttribute("readonly", "true");
      elem.value = '';
    }
    calcSum(null);
  }
  function calcTotal(){
    var total = document.getElementById("totalInput"),
      card = document.getElementById('cardInput'),
      transfer = document.getElementById('transferInput'),
      cash = document.getElementById('cashInput');
    var sum = 0;
    var cCard = document.getElementById("cardCheck"),
      cTransfer = document.getElementById("transferCheck"),
      cCash = document.getElementById("cashCheck");
    var checkedCount = 0, valueCount = 0;
    if (card.value !== '') {valueCount++; sum = parseFloat(card.value);}
    if (cash.value !== '') {valueCount++; sum += parseFloat(cash.value);}
    if (transfer.value !== '') {valueCount++; sum += parseFloat(transfer.value);}
    if (cCard.checked) checkedCount++;
    if (cTransfer.checked) checkedCount++;
    if (cCash.checked) checkedCount++;
    if (valueCount + 1 !== checkedCount) {
      alert('Есть не заполненные поля');
      return;
    }
    if (cCard.checked && card.value === '') card.value = totalSum - sum;
    if (cTransfer.checked && transfer.value === '') transfer.value = totalSum - sum;
    if (cCash.checked && cash.value === '') cash.value = totalSum - sum;
    total.value = totalSum;
  }
  function calcSum(elem) {
    try {
      var payType = $('#pay_type').val();
      var total = document.getElementById("totalInput");
      var transfer = document.getElementById('transferInput'),
        card = document.getElementById('cardInput'),
        cash = document.getElementById('cashInput');
      var sum = 0;
      total.style.border = '1px solid #eee';
      total.style.color = 'black';
      total.title = 'Сумма оплаты';
      if (card.value !== '') sum = parseFloat(card.value);
      if (cash.value !== '') sum += parseFloat(cash.value);
      if (transfer.value !== '') sum += parseFloat(transfer.value);
      //
      if(payType !== 'pay') {
        if(sum > paidSum) {
          if (elem != null) elem.value = 0;
          alert('Итоговая сумма возврата не может быть больше оплаченной!');
          return;
        }
      }
      //
      if (payType === 'pay' && sum > totalSum) {
        if (elem != null) {
          elem.value = 0;
        }
        alert('ИТОГО не может быть больше суммы к оплате');
        total.style.border = '1px solid red';
        total.style.color = 'red';
        total.title = 'Сумма оплаты больше ожидаемого';
      }
      document.getElementById("totalInput").value = sum;
    } catch (e) {
      alert('Проверьте правильности ввода цифр');
      document.getElementById("totalInput").value = '0';
    }
  }
  function saveForm() {
    var payType = $('#pay_type').val();
    var transfer = document.getElementById('transferInput'),
      card = document.getElementById('cardInput'),
      cash = document.getElementById('cashInput');
    var sum = 0, params = 'id=${patient.id}&pay_type=' + payType + '&';
    if (card.value !== '') {sum += parseFloat(card.value); params += 'card=' + card.value + '&';}
    if (cash.value !== '') {sum += parseFloat(cash.value); params += 'cash=' + cash.value + '&';}
    if (transfer.value !== '') {sum += parseFloat(transfer.value); params += 'humo=' + transfer.value + '&';}
    if (payType === 'pay' && totalSum !== sum) {
      alert('Сумма не верна. Проверьте правильности итоговой суммы');
      return;
    }
    $.ajax({
      url: '/cashbox/amb.s',
      method: "post",
      data: params,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setPayType(type) {
    if(type === 'discount')
      $('#discount_add').show();
    else
      $('#discount_add').hide();
    $('#pay_type').val(type)
  }
  function addEditDiscount(id) {
    addEditForm.reset();
    document.getElementById("modal_window").click();
    if(id > 0) {
      $.ajax({
        url: '/cashbox/getDiscount.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('*[name=id]').val(res.id);
            $('*[name=summ]').val(res.summ);
            $('*[name=text]').val(res.text);
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function saveDiscount() {
    try {
      var discountSum = parseFloat($('*[name=summ]').val());
      if(discountSum + discountSumm > totalSum) {
        alert('Сумма скидки не может превышать сумму к оплате');
        return;
      }
      $.ajax({
        url: '/cashbox/discount.s',
        method: "post",
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            $('#close-modal').click();
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/amb.s?id=${patient.id}');
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
    } catch (e) {
      alert('Проверьте правильности ввода');
    }
  }
  function delDiscount(id) {
    $.ajax({
      url: '/cashbox/delDiscount.s',
      method: "post",
      data: 'id=' + id,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setServicePayState(code, id) {
    $.ajax({
      url: '/cashbox/setServicePayState.s',
      method: "post",
      data: 'code=' + code + '&id=' + id,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function delCashOper(id) {
    if(confirm('Вы действительно хотите удалить оплату?'))
      $.ajax({
        url: '/cashbox/amb/delPay.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/amb.s?id=${patient.id}');
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
  }
</script>
