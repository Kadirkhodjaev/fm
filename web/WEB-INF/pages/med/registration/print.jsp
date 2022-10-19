<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
  table, p { width:95% !important; }
</style>
<c:set var="curYear" value="<%=new java.util.Date().getYear() + 1900%>" />
<table style="border-spacing:0;margin:auto;" >
  <tr>
    <td colspan="2" style="padding:5px">&nbsp;</td>
    <td colspan="2" style="text-align:right;padding:5px"><b>Ўзбекистон Республикаси</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px"><b>ЎЗБЕКИСТОН РЕСПУБЛИКАСИ</b></td>
    <td colspan="2" style="text-align:right;padding:5px"><b>Соғлиқни сақлаш вазирининг<u></u></b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px"><b>СОҒЛИҚНИ САҚЛАШ ВАЗИРЛИГИ</b></td>
    <td colspan="2" style="text-align:right;padding:5px"><b>2020 йил 31 декабрдаги №363-сонли буйруғи</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px"><b>«ФАРХОД МАДАД ШИФО» КЛИНИКАСИ</b></td>
    <td colspan="2" style="text-align:right;padding:5px"><b>билан тасдиқланган</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px">&nbsp;</td>
    <td colspan="2" style="text-align:right;padding:5px"><b>003-рақамли тиббий хужжат шакли</b></td>
  </tr>
</table>
<table style="border-spacing:0;margin:auto">
  <tr>
    <td colspan="2" style="padding:5px"><b>Тартиб билан таништирдим:</b></td>
    <td colspan="2" style="text-align:right;padding:5px"><b>Педикулёзга кўрилди</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px"><b>Тартиб билан танишдим:</b></td>
    <td colspan="2" style="text-align:right;padding:5px;"><b>Тениаринхозга сўралди</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:5px"><b>Тел: <u>${p.tel}</u></b></td>
    <td colspan="2" style="text-align:right;padding:5px"><b><u>${p.temp}</u> t˚ С</b></td>
  </tr>
</table>
<p style="text-align:center;padding:0 !important;"><b style="font-size:${sessionScope.fontSize + 8}px !important;">ШИФОХОНАДАГИ БЕМОРНИНГ</b></p>
<p style="text-align:center;padding:0 !important;"><b style="font-size:${sessionScope.fontSize + 8}px !important;">ТИББИЙ БАЁННОМАСИ № <u>${p.yearNum}</u></b></p>
<p style="margin:auto;padding:5px">Касалхонага ётқизилган куни ва вақти: <b><u>${p.date_Begin} ${p.time}</u></b></p>
<p style="margin:auto;">Касалхонадан  чиқарилган куни ва вақти: <u></u></p>
<p style="margin:auto;padding:5px"><b><u>${p.dept.name}</u></b> бўлими,
  <c:if test="${p.room != null}"><b><u>${p.room.floor.name} ${p.room.name}-хона ${p.room.roomType.name}</u></b></c:if>
</p>
<p style="margin:auto;padding:5px">_______________________ бўлимига ўтқазилган _______ кун ётиб даволанган</p>
<p style="margin:auto;padding:5px">Беморни олиб юриш турлари: <b><u>${p.vidPer.name}</u></b></p>
<p style="margin:auto;padding:5px">Қон гурухи <b><u>${p.bloodGroup.name}</u></b>, <b><u>${p.resus}</u></b> резус мансублиги <u></u></p>
<p style="margin:auto;padding:5px">Дориларнинг ножўя таьсири:</p>
<p style="margin:auto;padding:5px"><b><u>${p.drugEffect}</u></b></p>
<p style="margin:auto;padding:5px ">Паспорт маълумотлари: <b><u>${p.passportInfo}</u></b></p>
<p style="margin:auto;padding:5px">1. Фамилияси, исми, шарифи: <b><u>${p.surname} ${p.name} ${p.middlename}</u></b></p>
<p style="margin:auto;padding:5px">2. Жинси: <b><u>${p.sex.name}</u></b>, Буйи: <b><u>${p.rost} см</u></b>, Огирлиги: <b><u>${p.ves} кг</u></b></p>
<p style="margin:auto;padding:5px">3. Тугилган сана: <b><u>${p.birthdayString}</u></b> (тўлиқ ёш, болалар учун: 1ёшгача-ойлар ҳисобида, 2ойгача-кунлар хисобида)</p>
<p style="margin:auto;padding:5px">4. Доимий яшаш жойи: <b><u>${p.address}</u></b></p>
<p style="margin:auto;padding:5px">5. Иш жойи, касби, лавозими: <b><u>${p.work}</u></b>, <b><u>${p.post}</u></b></p>
<p style="margin:auto;padding:5px">6. Бемор қаердан юборилган: <b><u>${p.orientedBy}</u></b></p>
<p style="margin:auto;padding:5px">7. Касалхонага шошилинч равишда олиб келтирилган</p>
<p style="margin:auto;padding:5px 70px">- Қандай транспортда: <b><u>${p.transport}</u></b></p>
<p style="margin:auto;padding:5px 70px">- Касаллик бошлангандан сўнг: </p>
<p style="margin:auto;padding:5px">8. Беморнинг йўлланмасидаги ташхиси: <b><u>${p.diagnoz}</u></b></p>
<p style="margin:auto;padding:5px">9. Қабулхонада қўйилган ташҳис:</p>
<p style="margin:auto;padding:5px"><b>Асосий: <u>${p.startDiagnoz}</u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Хамрох: <u>${p.sopustDBolez}</u></b></p>
<br/>
<table style="margin:auto;width:100%;">
  <tr>
    <td width="150"><b>Даволаш шифокори:</b></td>
    <td style="border-bottom:1px solid black">&nbsp;</td>
    <td width="120" align="right"><b>Булим  мудири:</b></td>
    <td style="border-bottom:1px solid black">&nbsp;</td>
  </tr>
</table>
<!-- Second Page -->
<p style="page-break-after:always"></p>
<p style="text-align:center;padding:5px;font-size:${sessionScope.fontSize + 10}px !important"><b style="font-size:${sessionScope.fontSize + 4}px !important;">ҚАБУЛХОНА БЎЛИМИДА ШИФОКОР КЎРИГИ</b></p>
<p style="margin:auto;padding:5px;">ФИШ: <b><u>${p.surname} ${p.name} ${p.middlename}</u></b></p>
<p style="margin:auto;padding:5px;">А/Д: <b><u>${p.c25}</u></b></p>
<p style="margin:auto;padding:5px;">Пульс: <b><u>${p.c20}</u></b></p>
<p style="margin:auto;padding:5px;">Шикоятлари:</p>
<p style="margin:auto;padding:5px;"><b><u>${p.jaloby}</u></b></p>
<p style="margin:auto;padding:5px;">Анамнез:</p>
<p style="margin:auto;padding:5px;"><b><u>${p.anamnez}</u></b></p>
<p style="margin:auto;padding:5px;">Эпидемиологик анамнез</p>
<p style="margin:auto;padding:5px">
  А.Турар жойида,иш-ўқиш жойида,хар бир касаллик учун алоҳида яширин даври мобайнида юқумли касаллар билан алоқада бўлганми(қорин тифи, паратиф, б.салмонеллезлар, ичбуруғ, УИК, вирусли гепатит, сил, венерик касаллик)
</p>
<p style="margin:auto;padding:5px"><b><u>${p.no1}</u></b></p>
<p style="margin:auto;padding:5px">Б.Госпитализациягача 2 ой мобайнида турар жойидан ташқарига чиқганми? Булган жойи ва қайтган муддати:</p>
<p style="margin:auto;padding:5px"><b><u>${p.no2}</u></b></p>
<p style="margin:auto;padding:5px">Қандай юқумли касалликлар: <b><u>${p.no3}</u></b></p>
<p style="margin:auto;padding:5px">Охирги 6 ойичида стационардаво, гемотрансфузия ёки операция ўтқазганми?</p>
<p style="margin:auto;padding:5px"><b><u>${p.no4}</u></b></p>
<p style="margin:auto;padding:5px">Умумий ахволи: <b><u>${p.c1}</u></b></p>
<p style="margin:auto;padding:5px">Тери қопламалари: <b><u>${p.c36}</u></b></p>
<p style="margin:auto;padding:5px">Тана тузилиши: <b><u>${p.c4}</u></b></p>
<p style="margin:auto;padding:5px">Шишлар: <b><u>${p.c34}</u></b></p>
<p style="margin:auto;padding:5px">Ўпкада нафас: <b><u>${p.c12}</u></b></p>
<p style="margin:auto;padding:5px">Юрак тонлари: <b><u>${p.c17}</u></b></p>
<p style="margin:auto;padding:5px">Юракда шовқин: <b><u>${p.c37}</u></b> Пульс: <b><u>${p.c21}</u></b></p>
<p style="margin:auto;padding:5px">Тили: <b><u>${p.c26}</u></b>, Қорин: <b><u>${p.c27}</u></b></p>
<p style="margin:auto;padding:5px">Жигар: <b><u>${p.c28}</u></b></p>
<p style="margin:auto;padding:5px">Талоқ: <b><u>${p.c29}</u></b></p>
<p style="margin:auto;padding:5px">Пешоб ажралиши: <b><u>${p.c31}</u></b></p>
<p style="margin:auto;padding:5px">Пастернацкий симптоми:<b><u>${p.c33}</u></b></p>
<p style="margin:auto;padding:5px">Ич келиши: <b><u>${p.c30}</u></b></p>
<p style="margin:auto;text-align:center;padding:5px"><b>ҚАБУЛХОНАДА ҚУЙИЛГАН ТАШХИС</b></p>
<p style="margin:auto;padding:5px;">Асосий:</p>
<p style="margin:auto;padding:5px;"><b><u>${p.startDiagnoz}</u></b></p>
<p style="margin:auto;padding:5px;">Хамрох:</p>
<p style="margin:auto;padding:5px;"><b><u>${p.sopustDBolez}</u></b></p>
<p style="margin:auto;padding:5px;">Асорати:</p>
<p style="margin:auto;padding:5px;"><b><u>${p.oslojn}</u></b></p>
<p style="text-align:center;font-style:italic"><b>Қабулхона бўлимидаги шифокор Ф.И.Ш: _____________________________________ имзоси ______________</b></p>
