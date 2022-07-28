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
<table cellspacing="0" style="margin:auto;border-collapse:collapse">
  <tr>
    <td width="75%" align="center" style="vertical-align:middle; ;border:1px solid black">10. Касалхонада қўйилган диагноз</td>
    <td width="20%" align="center" style="border:1px solid black">Касаллик<br>аниқланган сана</td>
    <td width="15%" align="center" style="vertical-align:middle;border:1px solid black">Шифокор имзоси</td>
  </tr>
  <tr>
    <td style="border:1px solid black"><b>Асосий:</b> ${obos.c5}</td>
    <td style="border:1px solid black">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
  </tr>
  <tr>
    <td style="border:1px solid black"><b>Хамрох:</b> ${obos.c6}</td>
    <td style="border:1px solid black">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
  </tr>
  <tr>
    <td style="border:1px solid black"><b>Асорати:</b> ${obos.c7}</td>
    <td style="border:1px solid black">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
  </tr>
</table>
<p style="margin:auto">11. Касалхонада қўйилган якуний диагноз</p>
<p style="margin:auto">а) асосий </p>
<p style="margin:auto;padding:5px 0;">
  <u>${vyp.c1}</u>
</p>
<p style="margin:auto;padding:12px;">б) асосий касалликнинг асорати</p>
<c:if test="${vyp.c9 != null && vyp.c9 != '' && vyp.c9 != '<br>'}">
  <p style="margin:auto;padding:5px 0;">
    <u>${vyp.c9}</u>
  </p>
</c:if>
<p style="margin:auto;padding:12px">в) аниқланган бошқа касалликлар</p>
<p style="margin:auto;padding:5px 0;">
  <u>${vyp.c8}</u>
</p>
<p style="margin:auto;padding:5px">12. Мазкур йил давомида шу касаллик бўйича касалхонага ётиши: биринчи марта, қайта(тагига чизилсин)</p>
<p style="margin:auto;padding:5px">Хаммаси бўлиб <span>______________________________</span> марта</p>
<p style="margin:auto;padding:5px">13. Жарроҳлик операциялари, оғриқсизлантириш усуллари ва операциядан кейинга асоратлар</p>
<p style="margin:auto;padding:5px">
<table cellspacing="0" style="margin:auto; border-collapse:collapse; width:100% !important;">
  <tr>
    <td width="25%" align="center" style="vertical-align:top; ;border:1px solid black">Операциянинг номи</td>
    <td width="20%" align="center" style="border:1px solid black">Вақти, соати</td>
    <td width="30%" align="center" style="vertical-align:top;border:1px solid black">Оғриқсизлантириш усули</td>
    <td width="25%" align="center" style="vertical-align:top;border:1px solid black">Асоратлари</td>
  </tr>
  <tr>
    <td style="border:1px solid black; padding-left: 2px">1.</td>
    <td style="border:1px solid black;padding-left: 5px ">&nbsp;</td>
    <td style="border:1px solid black;padding-left: 5px">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
  </tr>
  <tr>
    <td style="border:1px solid black;padding-left: 2px">2.&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
    <td style="border:1px solid black">&nbsp;</td>
  </tr>
</table>
</p>
<p style="margin:auto;padding-bottom:7px;">Операция қилувчи</p>
<p style="margin:auto;">14. Даволашнинг бошқа турлари(кўрсатилсин)</p>
<p style="margin:auto;padding:12px 0;border-bottom:1px solid black"></p>
<p style="margin:auto;padding:12px 0;border-bottom:1px solid black"></p>
<table style="border-spacing:0;margin:auto">
  <tr>
    <td colspan="4" style="text-align:left">15. Мехнатга яроқсизлик варақаси:</td>
    <td colspan="4" style="text-align: center">№_____________________ дан _____________________ гача</td>
  </tr>
  <tr>
    <td colspan="4">&nbsp;</td>
    <td colspan="4" style="text-align: center">№_____________________ дан _____________________ гача</td>
  </tr>
</table>
<p style="margin:auto; padding-top:5px;">
  16. Даволаш натижаси:касалхонадан жавоб берилди:тузалди, бир оз яхшиланди, ўзгаришсиз, оғирлашган ҳолда, ўлди, бошқа муассасага ўтқазилди
</p>
<p style="margin:auto;padding:12px 0; border-bottom:1px solid black"></p>
<p style="margin:auto;text-align:center;font-size:14px !important;">(Даволаш муассасасининг номи)</p>
<p style="margin:auto;padding-top:4px;">
  Қабулхонада вафот этди, хомиладорликнинг 28-ҳафтасигача вафот этди, хомиладорликнинг 28чи ҳафтасидан кейин вафот этди, туғиш олдидан вафот этди, туққондан кейин вафот этди.
</p>
<p style="margin:auto;">17. Меҳнат қобилияти тикланди, сустлашди, вақтинча йўқолди, мазкур касаллик сабабли бутунлай йўқотди, бошқа сабабларга кўра(тагига чизилсин)</p>
<p style="margin:auto;">18. Экспертизага юбориш учун хулоса</p>
<p style="margin:auto;padding:12px 0; border-bottom:1px solid black"></p>
<p style="margin:auto;padding:12px 0; border-bottom:1px solid black"></p>
<p style="margin:auto;padding:12px 0;">19. Алоҳида белгилар</p>
<p style="margin:auto;padding:12px 0; border-bottom:1px solid black"></p>
<table style="border-spacing:0;padding-top:5px;margin:auto">
  <tr>
    <td colspan="2" style="text-align: left">20. Қабул қилинганда текширилди</td>
    <td colspan="3" style="text-align: center"> а) Қон RW ва ОИТС</td>
    <td colspan="4" style="text-align: center">б) ахлат посеви</td>
    <td colspan="4" style="text-align: right">в) педикулё</td>
  </tr>
</table>
<p style="margin:auto; padding:5px 0;">г) мавхум касалликлар</p>
<p style="margin:auto; padding:5px 0; border-bottom:1px solid black"></p>
<table style="margin:auto; border-spacing:0; padding-top:5px">
  <tr>
    <td colspan="3" style="text-align:left; padding-top:10px">Даволаш шифокори:</td>
    <td style="text-align:center; padding-top:10px; border-bottom:1px solid black">${lv}</td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
    <td style="text-align:center;font-size:10px !important">(фамилия, имзо)</td>
  </tr>
  <tr>
    <td colspan="3" style="text-align:left; padding-top:20px">Булим  мудири:</td>
    <td style="text-align:center; padding-top:10px; border-bottom:1px solid black">${zavOtdel}</td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
    <td style="text-align:center;font-size:10px !important">(фамилия, имзо)</td>
  </tr>
</table>