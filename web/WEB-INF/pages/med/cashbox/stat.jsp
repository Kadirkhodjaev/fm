<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script>
  function closeIB(){
    if(confirm('Осторожно!!! Вы действительно хотите закрыть ИБ? Все действии закроются!')) {
      $.ajax({
        url: '/cashbox/closeib.s',
        method: 'post',
        data: 'id=${pat.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function saveKoyko(){
    $.ajax({
      url: '/cashbox/setKoyko.s',
      method: 'post',
      data: 'id=${pat.id}&koyko=' + $('#koyko-days').val(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function setDisPerc() {
    $.ajax({
      url: '/cashbox/stat/setDisPerc.s',
      method: 'post',
      data: 'id=${pat.id}&perc=' + $('#diss_perc').val(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>
<div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px;">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; color: #337ab7">${pat.yearNum} - ${pat.surname} ${pat.name} ${pat.middlename}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px; float:right">
          <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/patients/list.s')"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
        </ul>
      </td>
    </tr>
  </table>
</div>
<div class="panel panel-info" style="width: 900px !important; margin: auto">
  <div class="panel-heading bold" style="height:40px">
    <div style="float: left">Реквизиты пациента <span style="color:red">ID: ${pat.id}</span></div>
    <div style="float:right; color:red"><c:if test="${actExist}">Оплата по акту</c:if></div>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${pat.paid != 'CLOSED' && serviceTotal <= 1}">
        <li class="paginate_button" tabindex="0"><a href="#" onclick="closeIB()"><i title="Закрыть историю болезни" class="fa fa-print"></i> Закрыть ИБ</a></li>
      </c:if>
    </ul>
  </div>
  <div class="clearfix"></div>
  <table class="formTable">
    <tr>
      <td colspan="2" class="right bold">
        Процент скидки (от койки):
      </td>
      <td colspan="2">
        <c:if test="${pat.paid != 'CLOSED'}">
          <select id="diss_perc" class="form-control" onchange="setDisPerc(this.value)">
            <option <c:if test="${pat.dis_perc == 0 || pat.dis_perc == null}">selected</c:if> value="0">Без скидки</option>
            <option <c:if test="${pat.dis_perc == 3}">selected</c:if> value="3">3%</option>
            <option <c:if test="${pat.dis_perc == 4}">selected</c:if> value="4">4%</option>
            <option <c:if test="${pat.dis_perc == 5}">selected</c:if> value="5">5%</option>
            <option <c:if test="${pat.dis_perc == 10}">selected</c:if> value="10">10%</option>
          </select>
        </c:if>
        <c:if test="${pat.paid == 'CLOSED'}">
          ${pat.dis_perc}%
        </c:if>
      </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>ФИО:</td>
      <td colspan="3"> ${pat.surname} ${pat.name} ${pat.middlename} </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Год рождения:</td>
      <td>${pat.birthyear}</td>
      <td class="right bold" nowrap>Пол:</td>
      <td>${pat.sex.name}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Рост:</td>
      <td>${pat.rost}</td>
      <td class="right bold" nowrap>Вес:</td>
      <td>${pat.ves}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Место работы:</td>
      <td>${pat.work}</td>
      <td class="right bold" nowrap>Должность:</td>
      <td>${pat.post}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Гражданство:</td>
      <td>${country}</td>
      <td class="right bold" nowrap>Область:</td>
      <td>${region}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Адрес:</td>
      <td>${pat.address}</td>
      <td class="right bold" nowrap>Паспортные данные:</td>
      <td>${pat.passportInfo}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Телефон:</td>
      <td>${pat.tel}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Температура:</td>
      <td>${pat.temp}</td>
      <td class="right bold" nowrap>Время регистрации: </td>
      <td>${pat.time}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Лечаший врач:
      <td>${lv.fio}</td>
      <td class="right bold" nowrap>Койко дней:
      <td>
        <c:if test="${pat.paid != 'CLOSED'}">
          <input type="number" class="form-control text-center" style="width:100px" id="koyko-days" value="${pat.dayCount}">
        </c:if>
        <c:if test="${pat.paid == 'CLOSED'}">
          ${pat.dayCount}
        </c:if>
      </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Отделение:
      <td>${pat.dept.name}
      <td class="right bold" nowrap>Палата:</td>
      <td>${pat.room.name} - ${pat.room.roomType.name}</td>
    </tr>
    <tr>
      <td class="right bold">Способ оплаты:</td>
      <td colspan="3">${pat.pay_type}</td>
    </tr>
    <tr>
      <td class="right bold">Диагноз при поступлении:</td>
      <td colspan="3">${pat.diagnoz}</td>
    </tr>
  </table>
  <div class="panel panel-info" style="width:100% !important; margin: auto">
    <div class="panel-heading bold">
      Оплата. К оплате <span id="totalSumSpan" style="color:red;font-weight:bold"><fmt:formatNumber value="${serviceTotal}" type = "number"/></span>,
      Оплачено: <span style="color:red;font-weight:bold"><fmt:formatNumber value="${paidSum}" type = "number"/></span>
      Итого: <span style="color:red;font-weight:bold"><fmt:formatNumber value="${paidSum + serviceTotal}" type = "number"/></span>

      <c:if test="${serviceTotal != 0 && pat.paid != 'CLOSED'}">
        <ul class="pagination" style="float:right; margin-top:-5px">
          <li class="paginate_button" style="display:none" id="discount_add" tabindex="0"><a href="#" onclick="addEditDiscount(0);return false"><i title="Добавить скидку" class="fa fa-plus"></i> Добавить</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="calcTotal()"><i title="Расчет" class="fa fa-print"></i> Расчет</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="saveForm()"><i title="Сохранить" class="fa fa-print"></i> Сохранить</a></li>
        </ul>
      </c:if>
    </div>
    <div class="panel-body">
      <c:if test="${fn:length(pays) > 0}">
        <table class="table table-bordered">
          <tr>
            <td class="center bold">Тип</td>
            <td class="center bold">Дата</td>
            <td class="center bold">Наличные</td>
            <td class="center bold">Карта</td>
            <td class="center bold">Online</td>
            <td class="center bold">Перечисление</td>
            <td class="center bold">Удалить</td>
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
              <td align="center"><fmt:formatNumber value="${pay.online}" type = "number"/></td>
              <td align="center"><fmt:formatNumber value="${pay.transfer}" type = "number"/></td>
              <td align="center">
                <c:if test="${pat.paid != 'CLOSED'}">
                  <button class="btn btn-danger btn-sm" onclick="delCashOper(${pay.id})" style="height:20px;padding:1px 10px">
                    <span class="fa fa-minus"></span>
                  </button>
                </c:if>
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
                <c:if test="${pat.paid != 'CLOSED'}">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDiscount(${discount.id})"><span class="fa fa-minus"></span></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </table>
      </c:if>
      <c:if test="${fn:length(plans) > 0 || fn:length(planDetails) > 0 || fn:length(fizios) > 0}">
        <table class="table table-bordered">
          <tr>
            <td class="center bold">Наименование</td>
            <td class="center bold">Дата</td>
            <td class="center bold">Цена</td>
          </tr>
          <c:forEach items="${plans}" var="plan">
            <c:if test="${plan.price > 0}">
              <tr>
                <td>${plan.kdo.name}</td>
                <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${plan.actDate}" /></td>
                <td align="right"><fmt:formatNumber value="${plan.price}" type = "number"/></td>
              </tr>
            </c:if>
          </c:forEach>
          <c:forEach items="${fizios}" var="fizio">
            <c:if test="${fizio.price * (fizio.counter == null ? 0 : fizio.counter) > 0}">
              <tr>
                <td>${fizio.c1}. Кол-во: ${fizio.counter == null ? 0 : fizio.counter}</td>
                <td align="center">${fizio.c2}</td>
                <td align="right"><fmt:formatNumber value="${fizio.price * (fizio.counter == null ? 0 : fizio.counter)}" type = "number"/></td>
              </tr>
            </c:if>
          </c:forEach>
          <c:forEach items="${planDetails}" var="det">
            <c:if test="${det.price > 0}">
              <tr>
                <td>${det.c1}</td>
                <td align="center">${det.date}</td>
                <td align="right"><fmt:formatNumber value="${det.price}" type = "number"/></td>
              </tr>
            </c:if>
          </c:forEach>
        </table>
      </c:if>
      <table class="table-bordered" width="100%">
        <tr>
          <td style="padding:5px;width:25%" class="right">Количество койко дней: </td>
          <td style="padding:5px;width:25%" class="bold center">${pat.dayCount - minusDays} ${pat.room.roomType.name}</td>
          <td style="padding:5px;width:25%" class="right">Итого к оплате: </td>
          <td style="padding:5px;width:25%" class="bold right" colspan="2"><fmt:formatNumber value="${koykoTotal}" type = "number"/></td>
        </tr>
        <c:forEach items="${epics}" var="epic">
          <tr>
            <td style="padding:5px;width:25%" class="right">Количество койко дней: </td>
            <td style="padding:5px;width:25%" class="bold center">${epic.c1} ${epic.c2}</td>
            <td style="padding:5px;width:25%" class="right">Итого к оплате: </td>
            <td style="padding:5px;width:25%" colspan="2" class="bold right"><fmt:formatNumber value="${epic.c3}" type = "number"/></td>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(watchers) > 0}">
          <tr>
            <td colspan="5" class="bold center">Дополнительное спальное место</td>
          </tr>
          <c:forEach items="${watchers}" var="watcher">
            <tr>
              <td style="padding:5px;width:25%" class="right">Кол-во дней: </td>
              <td style="padding:5px;width:25%" class="center">${watcher.dayCount}</td>
              <td style="padding:5px;width:25%" class="right">Итого к оплате: </td>
              <td style="padding:5px;width:25%" class="right"><fmt:formatNumber value="${watcher.total }" type = "number"/></td>
              <td style="width:50px">
                <c:if test="${pat.paid != 'CLOSED'}">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delWatcher(${watcher.id})"><span class="fa fa-minus"></span></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </c:if>
        <c:if test="${fn:length(services) > 0}">
          <tr>
            <td colspan="4" class="bold center">Услуги</td>
          </tr>
          <tr>
            <td class="center bold" colspan="2">Услуга</td>
            <td class="center bold">Кол-во</td>
            <td class="center bold">Итого к оплате</td>
          </tr>
          <c:forEach items="${services}" var="service">
            <tr>
              <td style="padding:5px;width:25%" colspan="2" class="left">${service.kdo.name}</td>
              <td style="padding:5px;width:25%" class="center">${service.count}</td>
              <td style="padding:5px;width:25%" class="right"><fmt:formatNumber value="${service.total}" type = "number"/></td>
            </tr>
          </c:forEach>
        </c:if>
      </table>

      <c:if test="${serviceTotal != 0}">
        <hr>
        <c:if test="${(serviceTotal != 0 || paidSum != 0) && pat.paid != 'CLOSED'}">
          <ul class="nav nav-tabs">
            <input name="pay_type" value="<c:if test="${serviceTotal > 0}">pay</c:if><c:if test="${(serviceTotal == 0 && paidSum > 0) || serviceTotal < 0}">ret</c:if>" id="pay_type" type="hidden"/>
            <c:if test="${serviceTotal > 0}">
              <li class="active"><a href="#pager" onclick="setPayType('pay')" data-toggle="tab" aria-expanded="true">Опалата</a></li>
            </c:if>
            <c:if test="${paidSum != 0}">
              <li class="<c:if test="${(serviceTotal == 0 && paidSum > 0) || serviceTotal < 0}">active</c:if>"><a href="#pager" onclick="setPayType('ret')" data-toggle="tab" aria-expanded="true">Возврат</a></li>
            </c:if>
            <c:if test="${serviceTotal > 0}">
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
                  <td class="center bold" style="vertical-align: middle">Карта</td>
                  <td class="center">
                    <input class="form-control center" style="font-size:20px" id="cardInput" onblur="calcSum(this)" type="number" value="" readonly />
                  </td>
                </tr>
                <tr>
                  <td class="center">
                    <input type="checkbox" id="cashCheck" tabindex="-1" onclick="setPay('cash', this)"/>
                  </td>
                  <td class="center bold" style="vertical-align: middle">Наличные</td>
                  <td class="center">
                    <input  class="form-control center" style="font-size:20px" readonly id="cashInput" onblur="calcSum(this)" type="number"/>
                  </td>
                </tr>
                <tr>
                  <td class="center">
                    <input type="checkbox" id="onlineCheck" tabindex="-1" onclick="setPay('online', this)"/>
                  </td>
                  <td class="center bold" style="vertical-align: middle">Online</td>
                  <td class="center">
                    <input  class="form-control center" style="font-size:20px" readonly id="onlineInput" onblur="calcSum(this)" type="number"/>
                  </td>
                </tr>
                <tr>
                  <td class="center">
                    <input type="checkbox" id="transferCheck" tabindex="-1" onclick="setPay('transfer', this)"/>
                  </td>
                  <td class="center bold" style="vertical-align: middle">Перечисление</td>
                  <td class="center">
                    <input  class="form-control center" style="font-size:20px" readonly id="transferInput" onblur="calcSum(this)" type="number"/>
                  </td>
                </tr>
                <tr>
                  <td class="center">
                    &nbsp;
                  </td>
                  <td class="center bold" style="vertical-align: middle">ИТОГО</td>
                  <td class="center">
                    <input class="form-control center" style="font-size:20px" id="totalInput" readonly value="0"/>
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
          <input type="hidden" name="code" value="STAT" />
          <input type="hidden" name="patient" value="${pat.id}" />
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
  var totalSum = ${serviceTotal}, paidSum = ${paidSum}, discountSumm = ${discountSum}, payType = '';
  const operDay = '<fmt:formatDate pattern = "dd.MM.yyyy" value = "${operDay}" />';
  function setPay(type, dom) {
    var elem = document.getElementById(type + 'Input');
    if (dom.checked) {
      elem.removeAttribute("readonly");
    } else {
      dom.removeAttribute("checked");
      elem.setAttribute("readonly", "true");
      elem.value = '';
    }
  }
  function calcTotal(){
    var total = document.getElementById("totalInput"),
      card = document.getElementById('cardInput'),
      cash = document.getElementById('cashInput'),
      online = document.getElementById('onlineInput'),
      transfer = document.getElementById('transferInput');
    var sum = 0;
    var cCard = document.getElementById("cardCheck"),
      cCash = document.getElementById("cashCheck"),
      cOnline = document.getElementById("onlineCheck"),
      cTransfer = document.getElementById("transferCheck");
    var checkedCount = 0, valueCount = 0;
    if (card.value !== '') {valueCount++; sum = parseFloat(card.value);}
    if (cash.value !== '') {valueCount++; sum += parseFloat(cash.value);}
    if (online.value !== '') {valueCount++; sum += parseFloat(online.value);}
    if (transfer.value !== '') {valueCount++; sum += parseFloat(transfer.value);}
    if (cCard.checked) checkedCount++;
    if (cCash.checked) checkedCount++;
    if (cOnline.checked) checkedCount++;
    if (cTransfer.checked) checkedCount++;
    if (valueCount + 1 !== checkedCount) {
      alert('Есть не заполненные поля');
      return;
    }
    if (cCard.checked && card.value === '') card.value = totalSum - sum;
    if (cCash.checked && cash.value === '') cash.value = totalSum - sum;
    if (cOnline.checked && online.value === '') online.value = totalSum - sum;
    if (cTransfer.checked && transfer.value === '') transfer.value = totalSum - sum;
    total.value = totalSum;

  }
  function calcSum(elem) {
    try {
      payType = $('#pay_type').val();
      var total = document.getElementById("totalInput");
      var card = document.getElementById('cardInput'),
        cash = document.getElementById('cashInput'),
        online = document.getElementById('onlineInput'),
        transfer = document.getElementById('transferInput');
      var sum = 0;
      total.style.border = '1px solid #eee';
      total.style.color = 'black';
      total.title = 'Сумма оплаты';
      if (card.value !== '') sum = parseFloat(card.value);
      if (cash.value !== '') sum += parseFloat(cash.value);
      if (online.value !== '') sum += parseFloat(online.value);
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
    payType = $('#pay_type').val();
    var card = document.getElementById('cardInput'),
      cash = document.getElementById('cashInput'),
      online = document.getElementById('onlineInput'),
      transfer = document.getElementById('transferInput');
    var sum = 0, params = 'id=${pat.id}&pay_type=' + payType + '&';
    if (card.value !== '') {sum += parseFloat(card.value); params += 'card=' + card.value + '&';}
    if (cash.value !== '') {sum += parseFloat(cash.value); params += 'cash=' + cash.value + '&';}
    if (online.value !== '') {sum += parseFloat(online.value); params += 'online=' + online.value + '&';}
    if (transfer.value !== '') {sum += parseFloat(transfer.value); params += 'transfer=' + transfer.value + '&';}
    if (payType === 'pay' && totalSum === 0) {
      alert('Сумма не верна. Проверьте правильности итоговой суммы');
      return;
    }
    $.ajax({
      url: "/cashbox/stat.s",
      method: "post",
      data: params,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/stat.s?id=' + json.id);
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setPlanState(code, id){
    $.ajax({
      url: "/reg/stat/cashPlanState.s",
      method: "post",
      data: 'id=' + id + '&code=' + code,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setFizioState(code, id){
    $.ajax({
      url: "/cashbox/cashFizioState.s",
      method: "post",
      data: 'id=' + id + '&code=' + code,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/stat.s?id=${pat.id}');
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
    payType = type;
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
      if(discountSum + discountSumm > totalSum || discountSum === 0) {
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
            setPage('/cashbox/stat.s?id=${pat.id}');
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
          setPage('/cashbox/stat.s?id=${pat.id}');
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
        url: '/cashbox/stat/delPay.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
  }
  function delWatcher(id) {
    if(confirm('Вы действительно хотите удалить?'))
      $.ajax({
        url: '/cashbox/stat/delWatcher.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/stat.s?id=${pat.id}');
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
