<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><%
  response.setContentType("application/vnd.ms-excel;charset=UTF-8");
  response.setHeader("Content-Disposition", "attachment; filename=act.xls;");%>
<table style="border-collapse: collapse; border-spacing:0;">
  <tr style="border:0">
    <td colspan="5">&nbsp;</td><td colspan="2" style="text-align: center; font-size:14px;">УТВЕРЖДАЮ</td>
  </tr>
  <tr>
    <td colspan="5">&nbsp;</td><td colspan="2" style="text-align: center; font-size:14px;">Директор "${clinic_name}"</td>
  </tr>
  <tr>
    <td colspan="5">&nbsp;</td><td colspan="2" style="text-align: center; font-size:14px">${boss.fio}</td>
  </tr>
  <tr>
    <td colspan="5">&nbsp;</td><td colspan="2" style="text-align: center;border-width: thin; border-bottom-color: black; border-bottom-style: solid;">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight:bold; text-align: center; font-size:18px;" colspan="7">Акт выполненых работ № ${obj.actNum}</td>
  </tr>
  <tr>
    <td style="font-weight:bold; text-align: center; font-size:14px" colspan="7">от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateEnd}" />г.</td>
  </tr>
  <tr>
    <td style="font-weight:bold; text-align: center; font-size:14px" colspan="7">к договору № ${obj.patient.contractNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateBegin}" />г.</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="4" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Общая терапия</td>
    <td colspan="2" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">ИБ №</td>
    <td style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">${obj.patient.yearNum}</td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="2" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">ФИО</td>
    <td colspan="2" style="text-align: center; border-width: thin; border-color: black; border-style: solid;">${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename} </td>
    <td colspan="2" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Год рождения</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid;">${obj.patient.birthyear} </td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="2" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Дата поступления</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid; width:120px"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateBegin}" /></td>
    <td style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid; width:120px">Дата выписки</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid; width:120px"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateEnd}" /></td>
    <td style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid; width:120px">койка/день</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid; width:120px"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.dayCount}"/></td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="2" style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Наличные</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${cashSum}"/></td>
    <td style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Терминал</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${cardSum}"/></td>
    <td style="font-weight: bold; text-align: center; border-width: thin; border-color: black; border-style: solid;">Перечисление</td>
    <td style="text-align: center; border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${transferSum}"/></td>
  </tr>
  <c:if test="${fn:length(drugs) > 0}">
    <tr style="font-size: 14px">
      <td style="font-weight:bold; text-align: center;" colspan="7">Медикаменты</td>
    </tr>
    <tr style="font-size: 14px">
      <td align="center" style="font-weight: bold; border-width: thin; border-color: black; border-style: solid;">№</td>
      <td align="center" colspan="3" style="font-weight: bold; border-width: thin; border-color: black; border-style: solid;">Наименование</td>
      <td align="center" style="font-weight: bold; border-width: thin; border-color: black; border-style: solid;">Количество</td>
      <td align="center" style="font-weight: bold; border-width: thin; border-color: black; border-style: solid;">Цена</td>
      <td align="center" style="font-weight: bold; border-width: thin; border-color: black; border-style: solid;">Общая сумма</td>
    </tr>
    <c:forEach items="${drugs}" var="row" varStatus="loop">
      <tr style="font-size: 14px">
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;">${loop.index + 1}</td>
        <td colspan="3" style="border-width: thin; border-color: black; border-style: solid;">${row.drugName}</td>
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.serviceCount}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price*row.serviceCount}"/></td>
      </tr>
    </c:forEach>
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">ИТОГО</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></td>
    </tr>
  </c:if>
  <c:if test="${fn:length(labs) > 0}">
    <tr style="font-size: 14px">
      <td style="font-weight:bold; text-align: center;" colspan="7">Лабораторные исследования</td>
    </tr>
    <c:forEach items="${labs}" var="elem" varStatus="loop">
      <tr style="font-size: 14px">
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;">${loop.index + 1}</td>
        <td colspan="3" style="border-width: thin; border-color: black; border-style: solid;">${elem.serviceName}</td>
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.serviceCount}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price == 0 ? elem.real_price : elem.price}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price*elem.serviceCount}"/></td>
      </tr>
    </c:forEach>
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">ИТОГО</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${labSum}"/></td>
    </tr>
  </c:if>
  <c:if test="${fn:length(consuls) > 0}">
    <tr style="font-size: 14px">
      <td style="font-weight:bold; text-align: center;" colspan="7">Узкие специалисты</td>
    </tr>
    <c:forEach items="${consuls}" var="elem" varStatus="loop">
      <tr style="font-size: 14px">
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;">${loop.index + 1}</td>
        <td colspan="3" style="border-width: thin; border-color: black; border-style: solid;">${elem.serviceName}</td>
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.serviceCount}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price == 0 ? elem.real_price : elem.price}"/></td>
        <td align="right" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price*elem.serviceCount}"/></td>
      </tr>
    </c:forEach>
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">ИТОГО</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${consulSum}"/></td>
    </tr>
  </c:if>
  <c:if test="${fn:length(kdos) > 0}">
    <tr style="font-size: 14px">
      <td style="font-weight:bold; text-align: center;" colspan="7">Медицинские услуги</td>
    </tr>
    <c:forEach items="${kdos}" var="elem" varStatus="loop">
      <tr style="font-size: 14px">
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;">${loop.index + 1}</td>
        <td colspan="3" style="border-width: thin; border-color: black; border-style: solid;">${elem.serviceName}</td>
        <td align="center" style="border-width: thin; border-color: black; border-style: solid;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.serviceCount}"/></td>
        <td style="border-width: thin; border-color: black; border-style: solid; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price == 0 ? elem.real_price : elem.price}"/></td>
        <td style="border-width: thin; border-color: black; border-style: solid; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${elem.price*elem.serviceCount}"/></td>
      </tr>
    </c:forEach>
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">ИТОГО</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${kdoSum}"/></td>
    </tr>
  </c:if>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <c:if test="${fn:length(epics) > 0}">
    <c:forEach items="${epics}" var="epic">
      <tr style="font-size: 14px">
        <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
        <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Стоимость палаты: ${epic.c1}</td>
        <td style="border-width: thin; border-color: black; border-style: solid;text-align: center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${epic.c6}"/></td>
        <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${epic.c5}"/></td>
        <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${epic.c5*epic.c6}"/></td>
      </tr>
    </c:forEach>
  </c:if>
  <c:if test="${fn:length(epics) == 0}">
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Стоимость палаты: ${obj.patient.dept.name}</td>
      <td style="border-width: thin; border-color: black; border-style: solid;text-align: center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.dayCount}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.koykoPrice}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.koykoPrice*obj.dayCount}"/></td>
    </tr>
  </c:if>
  <c:forEach items="${watchers}" var="watcher" varStatus="loop">
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Дополнительное место</td>
      <td style="border-width: thin; border-color: black; border-style: solid;text-align: center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${watcher.dayCount}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${watcher.price}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${watcher.dayCount*watcher.price}"/></td>
    </tr>
  </c:forEach>
  <c:if test="${dis_perc > 0}">
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Стоимость палаты с учетом скидки</td>
      <td style="border-width: thin; border-color: black; border-style: solid;text-align: center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${dis_perc}"/>%</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${dis_sum}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${dis_sum * (100-dis_perc) / 100}"/></td>
    </tr>
  </c:if>
  <c:if test="${discount_sum > 0}">
    <tr style="font-size: 14px">
      <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
      <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Мед. услуги входящие стоимость койки</td>
      <td style="border-width: thin; border-color: black; border-style: solid;text-align: center">&nbsp;</td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${discount_sum}"/></td>
      <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right">0</td>
    </tr>
  </c:if>
  <tr style="font-size: 14px">
    <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
    <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Питание</td>
    <td style="border-width: thin; border-color: black; border-style: solid;text-align: center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.dayCount}"/></td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.eatPrice}"/></td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.eatPrice*obj.dayCount}"/></td>
  </tr>
  <tr style="font-size: 14px">
    <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
    <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Медикаменты на сумму</td>
    <td style="border-width: thin; border-color: black; border-style: solid;text-align: center">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></td>
  </tr>
  <tr style="font-size: 14px">
    <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
    <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Медицинские услуги на сумму</td>
    <td style="border-width: thin; border-color: black; border-style: solid;text-align: center">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${consulSum + labSum + kdoSum}"/></td>
  </tr>
  <tr style="font-size: 14px">
    <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
    <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">Всего</td>
    <td style="border-width: thin; border-color: black; border-style: solid;text-align: center">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.totalSum}"/></td>
  </tr>
  <tr style="font-size: 14px">
    <td style="border-width: thin; border-color: black; border-style: solid;">&nbsp;</td>
    <td colspan="3" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold">К доплате</td>
    <td style="border-width: thin; border-color: black; border-style: solid;text-align: center">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold">&nbsp;</td>
    <td style="border-width: thin; border-color: black; border-style: solid;font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.paySum}"/></td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="2" style="border-width: thin; border-color: black; border-style: solid; font-weight:bold; text-align: center; vertical-align: middle">Сумма прописью:</td>
    <td colspan="5" style="font-weight:bold;border-width: thin; border-color: black; border-style: solid;text-align: center; vertical-align: middle">${sum_in_word}</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td>&nbsp;</td>
    <td style="text-align: right;font-weight: bold;">Главный бухгалтер</td>
    <td style="border-bottom-width: thin; border-bottom-color: black; border-bottom-style: solid;" colspan="2">&nbsp;</td>
    <td colspan="3" style="font-weight: bold;">${glavbuh.fio}</td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td>&nbsp;</td>
    <td style="text-align: right;font-weight: bold;">Лечащий врач</td>
    <td style="border-bottom-width: thin; border-bottom-color: black; border-bottom-style: solid;" colspan="2">&nbsp;</td>
    <td colspan="3" style="font-weight: bold;">${lvFio}</td>
  </tr>
  <tr style="font-size: 14px">
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td>&nbsp;</td>
    <td style="text-align: right;font-weight: bold;">Старшая медсестра</td>
    <td style="border-bottom-width: thin; border-bottom-color: black; border-bottom-style: solid;" colspan="2">&nbsp;</td>
    <td colspan="3" style="font-weight: bold;">${head_nurse}</td>
  </tr>
  <tr>
    <td colspan="7">&nbsp;</td>
  </tr>
  <tr style="font-size: 14px">
    <td>&nbsp;</td>
    <td style="text-align: right;font-weight: bold;">Пациент</td>
    <td style="border-bottom-width: thin; border-bottom-color: black; border-bottom-style: solid;" colspan="2">&nbsp;</td>
    <td colspan="3" style="font-weight: bold;">${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</td>
  </tr>
</table>
