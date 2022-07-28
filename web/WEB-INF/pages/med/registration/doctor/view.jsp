<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:if test="${print}">
  <style>
    * {font-size:${sessionScope.fontSize}px !important;}
    table {width:95% !important;}
  </style>
</c:if>

<c:if test="${page == 1}">
  <table class="formTable" width="700px" style="border-spacing: 0; margin: auto">
    <tr>
      <td style="border:1px solid #e8e8e8;"><b>Дата поступления</b>:
      <td style="border:1px solid #e8e8e8" colspan="3">${date_Begin}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Отделение</b>:
      <td style="border:1px solid #e8e8e8" colspan="3">${pat.dept.name}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>№ палаты</b>:
      <td style="border:1px solid #e8e8e8">${pat.room.name} - ${pat.room.roomType.name}
      <td style="border:1px solid #e8e8e8"><b>Лечащий врач</b>:
      <td style="border:1px solid #e8e8e8">${lv}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Диагноз при поступлении</b>:
      <td colspan="3" style="border:1px solid #e8e8e8">${pat.startDiagnoz}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Сопутствующие болезни</b>:
      <td colspan="3" style="border:1px solid #e8e8e8">${pat.sopustDBolez}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Осложнение</b>:
      <td colspan="3" style="border:1px solid #e8e8e8">${pat.oslojn}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8">
        <p style="text-align: center"><b>СХЕМА<br>Сбора эпидемиологического анамнеза</b></p>
        <p>Имел(а) ли контакт с инфекционными больными (брюшным тифом, паратифами, др салмонеллёзами, дизентерией, прочим ОКИ,
          вирусными гепатитами, туберкулезом, венерическими заболеваниями) по месту жительства или прописки, работы, учебы на
          протяжении максимального срока инкубации для каждого заболевания</p>
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8; padding:10px 0">${pat.no1}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8">Выезжал(а) ли пределы населенного пункта за неделю, -2 месяца до настоящего заболевания. Место пребывания и дата возвращения (вписать с какого по какое время)
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8; padding:10px 0">${pat.no2}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8">Какие инфеционные заболевания перенёс(ла)?
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8; padding:10px 0">${pat.no3}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8">Находился (лась) ли на стационарном лечении, получал(а) ли гемотрансфузии (кровь и ее компоненты), подвергалась ли оперативным и массивным вмешательствам за последние 6 месяцев
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8; padding:10px 0">${pat.no4}
  </table>
</c:if>
<c:if test="${page == 2}">
  <table class="formTable" width="700px" style="border-spacing: 0; margin:auto">
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Жалобы</b>:
      <td colspan="3" style="border:1px solid #e8e8e8">${pat.jaloby}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Анамнез</b>:
      <td colspan="3" style="border:1px solid #e8e8e8">${pat.anamnez}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8"><b>Status praesens</b>
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Общее состояние</b>:
      <td style="border:1px solid #e8e8e8">${pat.c1}
      <td style="border:1px solid #e8e8e8"><b>Сознание</b>:
      <td style="border:1px solid #e8e8e8">${pat.c2}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Положение</b>:
      <td style="border:1px solid #e8e8e8">${pat.c3}
      <td style="border:1px solid #e8e8e8"><b>Телосложение</b>:
      <td style="border:1px solid #e8e8e8">${pat.c4}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Клечатка</b>:
      <td style="border:1px solid #e8e8e8">${pat.c5}
      <td style="border:1px solid #e8e8e8"><b>Костно-мышечная сис.</b>:
      <td style="border:1px solid #e8e8e8">${pat.c6}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Суставы</b>:
      <td style="border:1px solid #e8e8e8">${pat.c7}
      <td style="border:1px solid #e8e8e8"><b>Лимфатические узлы</b>:
      <td style="border:1px solid #e8e8e8">${pat.c8}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Грудная клетка</b>:
      <td style="border:1px solid #e8e8e8">${pat.c9}
      <td style="border:1px solid #e8e8e8"><b>Число дыхания</b>:
      <td style="border:1px solid #e8e8e8">${pat.c10}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Перкуссия грудной клетки</b>:
      <td style="border:1px solid #e8e8e8">${pat.c11}
      <td style="border:1px solid #e8e8e8"><b>Аускультация легких</b>:
      <td style="border:1px solid #e8e8e8">${pat.c12}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Осмотр сердечной области</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c13}
    <tr>
      <td colspan="4" style="border:1px solid #e8e8e8"><b>Перкуссия границы сердца</b>
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Правая</b>:
      <td style="border:1px solid #e8e8e8">${pat.c14}
      <td style="border:1px solid #e8e8e8"><b>Левая</b>:
      <td style="border:1px solid #e8e8e8">${pat.c15}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Верхняя</b>:
      <td style="border:1px solid #e8e8e8">${pat.c16}
      <td style="border:1px solid #e8e8e8">&nbsp;
      <td style="border:1px solid #e8e8e8">&nbsp;
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Аускультация сердца</b>:
      <td style="border:1px solid #e8e8e8">${pat.c17}
      <td style="border:1px solid #e8e8e8"><b>на аорте</b>:
      <td style="border:1px solid #e8e8e8">${pat.c18}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>на легочной артерии</b>:
      <td style="border:1px solid #e8e8e8">${pat.c19}
      <td style="border:1px solid #e8e8e8">&nbsp;
      <td style="border:1px solid #e8e8e8">&nbsp;
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Пульс: Частота</b>:
      <td style="border:1px solid #e8e8e8">${pat.c20}
      <td style="border:1px solid #e8e8e8"><b>ритм</b>:
      <td style="border:1px solid #e8e8e8">${pat.c21}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>наполнение</b>:
      <td style="border:1px solid #e8e8e8">${pat.c22}
      <td style="border:1px solid #e8e8e8"><b>напряжение</b>:
      <td style="border:1px solid #e8e8e8">${pat.c23}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>дефицит пульса</b>:
      <td style="border:1px solid #e8e8e8">${pat.c24}
      <td style="border:1px solid #e8e8e8">&nbsp;
      <td style="border:1px solid #e8e8e8">&nbsp;
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Артериальное давление</b>:
      <td style="border:1px solid #e8e8e8">${pat.c25}
      <td style="border:1px solid #e8e8e8">&nbsp;
      <td style="border:1px solid #e8e8e8">&nbsp;
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Язык</b>:
      <td style="border:1px solid #e8e8e8">${pat.c26}
      <td style="border:1px solid #e8e8e8"><b>Живот</b>:
      <td style="border:1px solid #e8e8e8">${pat.c27}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Печень</b>:
      <td style="border:1px solid #e8e8e8">${pat.c28}
      <td style="border:1px solid #e8e8e8"><b>Селезенка</b>:
      <td style="border:1px solid #e8e8e8">${pat.c29}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Стул</b>:
      <td style="border:1px solid #e8e8e8">${pat.c30}
      <td style="border:1px solid #e8e8e8"><b>Мочеиспускание</b>:
      <td style="border:1px solid #e8e8e8">${pat.c31}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Боли в области почек</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c32}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Симптом Пастернацкого</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c33}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Периферические отеки</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c34}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Время поступления</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c35}
  </table>
</c:if>