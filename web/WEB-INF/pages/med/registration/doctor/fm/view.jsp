<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<%--
  Страница также выгружается в Word (?word=Y), поэтому вёрстка на таблицах
  и только простые CSS-свойства, которые Word понимает (без flex/grid).
--%>
<style>
  .ov { width:100%; max-width:900px; margin:16px auto; border-collapse:collapse; border-spacing:0;
    font-family:'Inter', Calibri, Arial, sans-serif; font-size:14px; color:#1F2430; background:#fff;
    border:1px solid #E6E8EC; }
  .ov td { padding:9px 12px; border:1px solid #EEF0F3; vertical-align:top; line-height:1.45; }
  .ov td.l { width:22%; background:#FAFBFC; color:#6B7280; font-size:12.5px; font-weight:bold; }
  .ov td.v { width:28%; }
  .ov tr.sec td { padding:11px 12px; background:#F3F4F6; color:#1F2430; font-size:12px; font-weight:bold;
    letter-spacing:.5px; text-transform:uppercase; border-top:2px solid #D7182E; }
  .ov tr.q td { background:#FAFBFC; color:#3C4250; font-size:13px; }
  .ov tr.q td b { color:#1F2430; }
  .ov tr.a td { padding:10px 12px 14px; min-height:24px; }
  .ov .sch { text-align:center; font-size:13px; font-weight:bold; color:#1F2430; text-transform:uppercase; letter-spacing:.3px; }
  .ov .sch span { display:block; margin-top:2px; font-size:12px; font-weight:normal; color:#6B7280; text-transform:none; letter-spacing:0; }
</style>

<c:if test="${page == 1}">
  <table class="ov" width="800" cellspacing="0" cellpadding="0">
    <tr class="sec"><td colspan="4">Госпитализация</td></tr>
    <tr>
      <td class="l">Дата поступления</td>
      <td class="v">${pat.date_Begin}</td>
      <td class="l">Дата выписки</td>
      <td class="v">${pat.date_End}</td>
    </tr>
    <tr>
      <td class="l">Диагноз при поступлении</td>
      <td colspan="3">${pat.startDiagnoz}</td>
    </tr>
    <tr>
      <td class="l">Сопутствующие болезни</td>
      <td colspan="3">${pat.sopustDBolez}</td>
    </tr>
    <tr>
      <td class="l">Осложнение</td>
      <td colspan="3">${pat.oslojn}</td>
    </tr>

    <tr class="sec"><td colspan="4">Эпидемиологический анамнез</td></tr>
    <tr>
      <td colspan="4" class="sch">Схема<span>сбора эпидемиологического анамнеза</span></td>
    </tr>
    <tr class="q">
      <td colspan="4"><b>1.</b> Имел(а) ли контакт с инфекционными больными (брюшным тифом, паратифами, др. сальмонеллёзами, дизентерией,
        прочими ОКИ, вирусными гепатитами, туберкулёзом, венерическими заболеваниями) по месту жительства или прописки, работы, учёбы
        на протяжении максимального срока инкубации для каждого заболевания</td>
    </tr>
    <tr class="a"><td colspan="4">${pat.no1}</td></tr>
    <tr class="q">
      <td colspan="4"><b>2.</b> Выезжал(а) ли за пределы населённого пункта за 1 неделю – 2 месяца до настоящего заболевания.
        Место пребывания и дата возвращения (с какого по какое время)</td>
    </tr>
    <tr class="a"><td colspan="4">${pat.no2}</td></tr>
    <tr class="q">
      <td colspan="4"><b>3.</b> Какие инфекционные заболевания перенёс(ла)?</td>
    </tr>
    <tr class="a"><td colspan="4">${pat.no3}</td></tr>
    <tr class="q">
      <td colspan="4"><b>4.</b> Находился(лась) ли на стационарном лечении, получал(а) ли гемотрансфузии (кровь и её компоненты),
        подвергался(лась) ли оперативным и массивным вмешательствам за последние 6 месяцев</td>
    </tr>
    <tr class="a"><td colspan="4">${pat.no4}</td></tr>
  </table>
</c:if>

<c:if test="${page == 2}">
  <table class="ov" width="800" cellspacing="0" cellpadding="0">
    <tr class="sec"><td colspan="4">Жалобы и анамнез</td></tr>
    <tr>
      <td class="l">Жалобы</td>
      <td colspan="3">${pat.jaloby}</td>
    </tr>
    <tr>
      <td class="l">Анамнез</td>
      <td colspan="3">${pat.anamnez}</td>
    </tr>

    <tr class="sec"><td colspan="4">Status praesens</td></tr>
    <tr>
      <td class="l">Общее состояние</td>
      <td class="v">${pat.c1}</td>
      <td class="l">Сознание</td>
      <td class="v">${pat.c2}</td>
    </tr>
    <tr>
      <td class="l">Положение</td>
      <td class="v">${pat.c3}</td>
      <td class="l">Телосложение</td>
      <td class="v">${pat.c4}</td>
    </tr>
    <tr>
      <td class="l">Кожные покровы</td>
      <td colspan="3">${pat.c36}</td>
    </tr>
    <tr>
      <td class="l">Клетчатка</td>
      <td class="v">${pat.c5}</td>
      <td class="l">Костно-мышечная система</td>
      <td class="v">${pat.c6}</td>
    </tr>
    <tr>
      <td class="l">Суставы</td>
      <td class="v">${pat.c7}</td>
      <td class="l">Лимфатические узлы</td>
      <td class="v">${pat.c8}</td>
    </tr>

    <tr class="sec"><td colspan="4">Органы дыхания и кровообращения</td></tr>
    <tr>
      <td class="l">Аускультация лёгких</td>
      <td class="v">${pat.c12}</td>
      <td class="l">Число дыханий</td>
      <td class="v">${pat.c10}</td>
    </tr>
    <tr>
      <td class="l">Аускультация сердца</td>
      <td class="v">${pat.c17}</td>
      <td class="l">На аорте</td>
      <td class="v">${pat.c18}</td>
    </tr>
    <tr>
      <td class="l">Пульс: частота</td>
      <td class="v">${pat.c20}</td>
      <td class="l">Ритм</td>
      <td class="v">${pat.c21}</td>
    </tr>
    <tr>
      <td class="l">Шумы в сердце</td>
      <td colspan="3">${pat.c37}</td>
    </tr>
    <tr>
      <td class="l">Артериальное давление</td>
      <td colspan="3">${pat.c25}</td>
    </tr>

    <tr class="sec"><td colspan="4">Органы пищеварения и мочевыделения</td></tr>
    <tr>
      <td class="l">Язык</td>
      <td class="v">${pat.c26}</td>
      <td class="l">Живот</td>
      <td class="v">${pat.c27}</td>
    </tr>
    <tr>
      <td class="l">Печень</td>
      <td class="v">${pat.c28}</td>
      <td class="l">Селезёнка</td>
      <td class="v">${pat.c29}</td>
    </tr>
    <tr>
      <td class="l">Стул</td>
      <td class="v">${pat.c30}</td>
      <td class="l">Мочеиспускание</td>
      <td class="v">${pat.c31}</td>
    </tr>
    <tr>
      <td class="l">Симптом Пастернацкого</td>
      <td colspan="3">${pat.c33}</td>
    </tr>
    <tr>
      <td class="l">Периферические отёки</td>
      <td colspan="3">${pat.c34}</td>
    </tr>
  </table>
</c:if>
