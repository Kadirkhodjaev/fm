<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="curYear" value="<%=new java.util.Date().getYear() + 1900%>" />
<table style="border-spacing:0;margin:auto;" >
  <tr>
    <td colspan="2" style="padding:3px">&nbsp;</td>
    <td colspan="2" style="text-align:right;padding:3px"><b>Ўзбекистон Республикаси</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px"><b>ЎЗБЕКИСТОН РЕСПУБЛИКАСИ</b></td>
    <td colspan="2" style="text-align:right;padding:3px"><b>Соғлиқни сақлаш вазирининг<u></u></b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px"><b>СОҒЛИҚНИ САҚЛАШ ВАЗИРЛИГИ</b></td>
    <td colspan="2" style="text-align:right;padding:3px"><b>2017 йил 25 декабрдаги №777-сонли буйруғи</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px"><b>«ФАРХОД МАДАД ШИФО» КЛИНИКАСИ</b></td>
    <td colspan="2" style="text-align:right;padding:3px"><b>билан тасдиқланган</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px">&nbsp;</td>
    <td colspan="2" style="text-align:right;padding:3px"><b>003-рақамли тиббий хужжат шакли</b></td>
  </tr>
</table>
<table style="border-spacing:0;margin:auto">
  <tr>
    <td colspan="2" style="padding:3px"><b>Тартиб билан таништирдим:</b></td>
    <td colspan="2" style="text-align:right;padding:3px"><b>Педикулёзга кўрилди</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px"><b>Тартиб билан танишдим:</b></td>
    <td colspan="2" style="text-align:right;padding:3px;"><b>Тениаринхозга сўралди</b></td>
  </tr>
  <tr>
    <td colspan="2" style="padding:3px"><b>Тел: <u>${p.tel}</u></b></td>
    <td colspan="2" style="text-align:right;padding:3px"><b><u>${p.temp}</u> t˚ С</b></td>
  </tr>
</table>
<p style="text-align:center;padding:0 !important;"><b>ШИФОХОНАДАГИ БЕМОРНИНГ</b></p>
<p style="text-align:center;padding:0 !important;"><b>ТИББИЙ БАЁННОМАСИ № <u>${p.yearNum}</u></b></p>
<p style="margin:auto;padding:3px">Касалхонага ётқизилган куни ва вақти: <b><u>${p.date_Begin} ${p.time}</u></b></p>
<p style="margin:auto;">Касалхонадан  чиқарилган куни ва вақти: <u></u></p>
<p style="margin:auto;padding:3px"><b><u>${p.dept.name}</u></b> бўлими, <b><u>${p.room.name} - ${p.room.roomType.name}</u></b> хона</p>
<p style="margin:auto;padding:3px">_______________________ бўлимига ўтқазилган _______ кун ётиб даволанган</p>
<p style="margin:auto;padding:3px">Беморни олиб юриш турлари: <b><u>${p.vidPer.name}</u></b></p>
<p style="margin:auto;padding:3px">Қон гурухи <b><u>${p.bloodGroup.name}</u></b>, <b><u>${p.resus}</u></b> резус мансублиги <u></u></p>
<p style="margin:auto;padding:3px">Дориларнинг ножўя таьсири:</p>
<p style="margin:auto;padding:3px"><b><u>${p.drugEffect}</u></b></p>
<p style="margin:auto;padding:3px ">Паспорт маълумотлари: <b><u>${p.passportInfo}</u></b></p>
<p style="margin:auto;padding:3px">1. Фамилияси, исми, шарифи: <b><u>${p.surname} ${p.name} ${p.middlename}</u></b></p>
<p style="margin:auto;padding:3px">2. Жинси: <b><u>${p.sex.name}</u></b></p>
<p style="margin:auto;padding:3px">3. Ёши: <b><u>${curYear - p.birthyear}</u></b> (тўлиқ ёш, болалар учун: 1ёшгача-ойлар ҳисобида, 2ойгача-кунлар хисобида)</p>
<p style="margin:auto;padding:3px">4. Доимий яшаш жойи: <b><u>${p.address}</u></b></p>
<p style="margin:auto;padding:3px">5. Иш жойи, касби, лавозими: <b><u>${p.work}</u></b>, <b><u>${p.post}</u></b></p>
<p style="margin:auto;padding:3px">6. Бемор қаердан юборилган: <b><u>${p.orientedBy}</u></b></p>
<p style="margin:auto;padding:3px">7. Касалхонага шошилинч равишда олиб келтирилган</p>
<p style="margin:auto;padding:3px"><span style="padding:0 20px">- Қандай транспортда: <b><u>${p.transport}</u></b></span></p>
<p style="margin:auto;padding:3px"><span style="padding:0 20px">- Касаллик бошлангандан сўнг:</span></p>
<p style="margin:auto;padding:3px">8. Беморнинг йўлланмасидаги ташхиси: <b><u>${p.diagnoz}</u></b></p>
<p style="margin:auto;padding:3px">9. Қабулхонада қўйилган ташҳис:</p>
<p style="margin:auto;padding:3px"><b><u>${p.startDiagnoz}</u></b></p>
<p style="margin:auto;padding-top:50px;text-align:center">
  <b>Даволаш шифокори: _______________________ Булим  мудири: ________________________</b>
</p>
<!-- Second Page -->
<p style="page-break-after:always"></p>
<p style="text-align:center;padding:3px;"><b>ҚАБУЛХОНА БЎЛИМИДА ШИФОКОР КЎРИГИ</b></p>
<p style="margin:auto;padding:3px;">А/Д: <b><u>${p.c25}</u></b></p>
<p style="margin:auto;padding:3px;">Пульс: <b><u>${p.c20}</u></b></p>
<p style="margin:auto;padding:3px;">Шикоятлари:</p>
<p style="margin:auto;padding:3px;"><b><u>${p.jaloby}</u></b></p>
<p style="margin:auto;padding:3px;">Анамнез:</p>
<p style="margin:auto;padding:3px;"><b><u>${p.anamnez}</u></b></p>
<p style="margin:auto;padding:3px;">Эпидемиологик анамнез</p>
<p style="margin:auto;padding:3px">
  А.Турар жойида,иш-ўқиш жойида,хар бир касаллик учун алоҳида яширин даври мобайнида юқумли касаллар билан алоқада бўлганми(қорин тифи, паратиф, б.салмонеллезлар, ичбуруғ, УИК, вирусли гепатит, сил, венерик касаллик)
</p>
<p style="margin:auto;padding:3px"><b><u>${p.no1}</u></b></p>
<p style="margin:auto;padding:3px">Б.Госпитализациягача 2 ой мобайнида турар жойидан ташқарига чиқганми? Булган жойи ва қайтган муддати:</p>
<p style="margin:auto;padding:3px"><b><u>${p.no2}</u></b></p>
<p style="margin:auto;padding:3px">Қандай юқумли касалликлар: <b><u>${p.no3}</u></b></p>
<p style="margin:auto;padding:3px">Охирги 6 ойичида стационардаво, гемотрансфузия ёки операция ўтқазганми?</p>
<p style="margin:auto;padding:3px"><b><u>${p.no4}</u></b></p>
<p style="margin:auto;padding:3px">Умумий ахволи: <b><u>${p.c1}</u></b></p>
<p style="margin:auto;padding:3px">Тери қопламалари: <b><u>${p.c6}</u></b></p>
<p style="margin:auto;padding:3px">Тана тузилиши: <b><u>${p.c4}</u></b></p>
<p style="margin:auto;padding:3px">Шишлар: <b><u>${p.c8}</u></b></p>
<p style="margin:auto;padding:3px">Ўпкада нафас: <b><u>${p.c9}</u></b>, <b><u>${p.c10}</u></b></p>
<p style="margin:auto;padding:3px">Юрак тонлари: <b><u>${p.c12}</u></b></p>
<p style="margin:auto;padding:3px">Юракда шовқин: <b><u>${p.c17}</u></b> Пульс: <b><u>${p.c21}</u></b></p>
<p style="margin:auto;padding:3px">Тили: <b><u>${p.c26}</u></b>, Қорин: <b><u>${p.c27}</u></b></p>
<p style="margin:auto;padding:3px">Жигар: <b><u>${p.c28}</u></b></p>
<p style="margin:auto;padding:3px">Талоқ: <b><u>${p.c29}</u></b></p>
<p style="margin:auto;padding:3px">Пешоб ажралиши: <b><u>${p.c31}</u></b></p>
<p style="margin:auto;padding:3px">Пастернацкий симптоми:<b><u>${p.c33}</u></b></p>
<p style="margin:auto;padding:3px">Ич келиши: <b><u>${p.c30}</u></b></p>
<p style="margin:auto;text-align:center;padding:3px"><b>ҚАБУЛХОНАДА ҚУЙИЛГАН ТАШХИС</b></p>
<p style="margin:auto;padding:3px;">Асосий:</p>
<p style="margin:auto;padding:3px;"><b><u>${p.startDiagnoz}</u></b></p>
<p style="margin:auto;padding:3px;">Хамрох:</p>
<p style="margin:auto;padding:3px;"><b><u>${p.sopustDBolez}</u></b></p>
<p style="margin:auto;padding:3px;">Асорати:</p>
<p style="margin:auto;padding:3px;"><b><u>${p.oslojn}</u></b></p>
<p style="text-align:center;font-style:italic"><b>Қабулхона бўлимидаги шифокор Ф.И.Ш: ________________________________ имзоси ______________</b></p>
