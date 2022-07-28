<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:if test="${page == 1}">
  <table class="formTable" width="800px" style="border-spacing: 0; margin: auto">
    <tr>
      <td style="border:1px solid #e8e8e8;" nowrap><b>Дата поступления</b>:
      <td style="border:1px solid #e8e8e8">${pat.date_Begin}
      <td style="border:1px solid #e8e8e8"><b>Дата выписки</b>:
      <td style="border:1px solid #e8e8e8">${pat.date_End}
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
  <table class="formTable" width="800px" style="border-spacing: 0; margin:auto">
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
      <td style="border:1px solid #e8e8e8"><b>Кожные покровы</b>:
      <td style="border:1px solid #e8e8e8" colspan="3">${pat.c36}
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
    <td style="border:1px solid #e8e8e8"><b>Аускультация легких</b>:
    <td style="border:1px solid #e8e8e8">${pat.c12}
      <td style="border:1px solid #e8e8e8"><b>Число дыхания</b>:
      <td style="border:1px solid #e8e8e8">${pat.c10}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Аускультация сердца</b>:
      <td style="border:1px solid #e8e8e8">${pat.c17}
      <td style="border:1px solid #e8e8e8"><b>на аорте</b>:
      <td style="border:1px solid #e8e8e8">${pat.c18}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Пульс: Частота</b>:
      <td style="border:1px solid #e8e8e8">${pat.c20}
      <td style="border:1px solid #e8e8e8"><b>ритм</b>:
      <td style="border:1px solid #e8e8e8">${pat.c21}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Шумы в сердце</b>:
      <td style="border:1px solid #e8e8e8" colspan="3">${pat.c37}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Артериальное давление</b>:
      <td style="border:1px solid #e8e8e8" colspan="3">${pat.c25}
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
      <td style="border:1px solid #e8e8e8"><b>Симптом Пастернацкого</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c33}
    <tr>
      <td style="border:1px solid #e8e8e8"><b>Периферические отеки</b>:
      <td colspan="4" style="border:1px solid #e8e8e8">${pat.c34}
  </table>
</c:if>