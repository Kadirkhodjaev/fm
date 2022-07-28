<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  * {font-size: 11px}
</style>
<table style="width:100%">
  <tr>
    <td style="width: 50%; vertical-align: top; padding:0 10px">
      <table style="width:100%">
        <tr>
          <td style="width:50%">
            Ўзбекистон Республикаси<br>
            Соғликни Сақлаш Вазирлиги<br>
            «Фарход Мадад Шифо»<br>
            Хусусий клиникаси
          </td>
          <td style="text-align: right">
            Ўзбекистон Республикаси<br>
            Соғликни Сақлаш Вазирлигининг<br>
            2020-йил 31-декабрдаги 363-сонли<br>
            буйруғи билан тасдиқланган<br>
            066-ракамли тиббий хужжат шакли
          </td>
        </tr>
      </table>
      <div style="font-weight: bold; text-align: center; margin:20px 0">
        ШИФОХОНАДАН ЧИКАРИЛГАН ЛАРНИНГ СТАТИСТИК КАРТАСИ
      </div>
      <div style="text-align: center; margin-bottom: 20px">
        (беморнинг тиббий баённомаси №<b>${pat.yearNum}</b>)
      </div>
      <hr>
      <div style="margin:10px 0">
        Фамилияси,исми: <b>${pat.surname} ${pat.name} ${pat.middlename}</b>
      </div>
      <table style="width:100%; margin:10px 0">
        <tr>
          <td style="width:50%">1. Жинси: <b>${pat.sex.name}</b></td>
          <td>Туғилган санаси: <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.birthday}" /></b></td>
        </tr>
      </table>
      <div style="margin:10px 0">
        2. Доимий яшаш жойи: <b>${country.name} ${region.name} ${pat.address}</b>
      </div>
      <div style="margin:10px 0">
        2а. Ижтимоий холати: ишлайди, ишламайди, ўқувчи, талаба, ногирон, х/   хизматда (чизинг)
      </div>
      <div style="margin:10px 0">
        2б.Паспорт: <b>${pat.passportInfo}</b>
      </div>
      <table style="width:100%; border-collapse: collapse">
        <tr>
          <td style="width:50%; border:1px solid black; vertical-align: top; padding:10px">
            <div>3. Шифохонага ким томонидан олиб келинган</div>
            <div style="padding-left: 50px">-03</div>
            <div style="padding-left: 50px">-ўзи</div>
            <div style="padding-left: 50px">-йўлланма билан</div>
            <div style="margin:5px 0">3а. Йўллаган муассаса ташхиси</div>
            <div style="margin:5px 0">3б. Кабулхона булими ташхиси</div>
            <div style="font-weight: bold">${pat.startDiagnoz}</div>
            <div style="margin:10px 0">4.	Касаллик ёки жарохат олгандан  неча соат кейин (чизинг)</div>
            <div style="padding-left: 30px;margin-top:5px">1. Дастлабки 6 соат ичида - 1</div>
            <div style="padding-left: 30px;margin-top:5px">2. 7-24 соат ичида - 2</div>
            <div style="padding-left: 30px;margin-top:5px">3.	24 соатдан кейин - 3</div>
            <div style="margin:10px 0">5. Шифохонага шошилинч олиб келинган (чизинг)</div>
            <div style="padding-left: 30px;margin-top:5px">1. Ха - 1</div>
            <div style="padding-left: 30px;margin-top:5px">1. Йук - 2</div>

          </td>
          <td style="border:1px solid black; vertical-align: top; padding:10px">
            <div>6. Шифохонага пул тўлаб ёткизилди (чизинг)</div>
            <div style="padding-left: 30px;margin-top:5px">1. Ха - 1</div>
            <div style="padding-left: 30px;margin-top:5px">1. Йук - 2</div>
            <div style="margin:10px 0">7. Шифохонага ёткизилган сана: <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.dateBegin}" /> ${pat.time}</b>
            <div style="margin:5px 0">бўлими <b>${pat.dept.name}</b></div>
            <div style="margin:5px 0">ўрин жой тури <b>${pat.room.name} ${pat.room.roomType.name}</b></div>
            <div style="margin:5px 0">8. Айнан шу касаллик билан мазкур йилда шифохнага ётқизилган:</div>
            <div style="padding-left: 30px;margin-top:5px">биринчи марта    -1</div>
            <div style="padding-left: 30px;margin-top:5px">қайта -2</div>
            <div style="margin:10px 0">8а.Ўтказилган ўрин-кунлар: ${days}</div>
            <div style="padding-left: 30px;margin-top:5px">1. Чиқарилди - 1</div>
            <div style="padding-left: 30px;margin-top:5px">2. Вафот этди - 2</div>
            <div style="padding-left: 30px;margin-top:5px">3. Бошқа шифохонага ўтказилди - 3</div>
              <div style="margin:10px 0">9. Чикарилган, ўлган сана (чизинг): <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.dateEnd}" /></b></div>
          </td>
        </tr>
      </table>
    </td>
    <td style="vertical-align: top; padding:0 10px">
      10. Беморнинг якуний ташхиси
      <table border="1" style="border-collapse: collapse; width: 100%">
        <tr>
          <td>&nbsp;</td>
          <td style="font-weight: bold; text-align: center">Асосий</td>
          <td style="font-weight: bold; text-align: center">Йўлдош касалликлар</td>
          <td style="font-weight: bold; text-align: center">&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="2">Клиник</td>
          <td rowspan="2">${vypiska.c1}</td>
          <td rowspan="2">&nbsp;</td>
          <td style="text-align: center">10а</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td rowspan="2" style="width:90px">Патолого - анатомик</td>
          <td rowspan="2" style="width:40%">&nbsp;</td>
          <td rowspan="2">&nbsp;</td>
          <td style="text-align: center">10б</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      <div style="margin:5px 0">11.  Ўлим содир бўлганда (сабаби кўрсатилсин):</div>
      <div style="margin:5px 0">а. Ўлимга олиб келган бевосита сабаб</div>
      <table style="width:100%;margin:10px 0"><tr><td style="width:300px">(касаллик ёки асосий касаллик асорати) а)</td><td style="border-bottom:1px solid black"></td></tr></table>
      <table style="width:100%;margin:10px 0"><tr><td style="width:350px">б. Ўлим сабабини бевосита чикарувчи касаллик б)</td><td style="border-bottom:1px solid black"></td></tr></table>
      <table style="width:100%;margin:10px 0"><tr><td style="width:300px">в. Асосий касаллик охирида кўрсатилади в)</td><td style="border-bottom:1px solid black"></td></tr></table>
      <table style="width:100%;margin:10px 0"><tr><td style="width:300px">в. Асосий касаллик охирида кўрсатилади в)</td><td style="border-bottom:1px solid black"></td></tr></table>
      <div style="margin:5px 0">11а. Бевосита ўлимга олиб келувчи касаллик ёки унинг асорати билан боғлиқ бўлмаган бошқа мухим касалликлар</div>
      <div style="border-bottom:1px solid black; margin-top:30px"></div>
      <div style="margin:5px 0">12. Жаррохлик амалиётлари</div>
      <table style="width:100%; border-collapse: collapse" border="1">
        <tr>
          <td style="text-align: center; font-weight: bold">Сана<br>соат</td>
          <td style="text-align: center; font-weight: bold">Жаррохлик амалиёти  а</td>
          <td style="text-align: center; font-weight: bold">Асорати б</td>
          <td style="text-align: center; font-weight: bold">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td rowspan="2" style="text-align: center">10а</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td rowspan="2" style="text-align: center">10б</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
      <div style="margin:10px 0">13. ОИТС га текширилди  “_____”______20____й.    натижа _______________</div>
      <div style="margin:10px 0">14. RW га текширилди: <b><fmt:formatDate pattern = "dd.MM.yyyy" value = "${plan.resDate}" /> й.</b> натижа: <b>${rw.c24}</b></div>
      <div style="margin:10px 0">15. Ногирон уруш қатнашчиси (чизинг)</div>
      <div style="margin:10px 0">16. Вақтинча махнаига лаёқатсизлик вароғи:</div>
      <div style="margin:10px 0">очилди  “_____”____________20____й</div>
      <div style="margin:10px 0">беркитилган  “_____”____________20____й</div>
      <table style="margin-top:30px; width:100%">
        <tr>
          <td>Даволовчи шифокор: <b>${lvfio}</b></td>
          <td style="border-bottom:1px solid black; width:30%"></td>
        </tr>
      </table>
      <table style="margin-top:20px; width:100%">
        <tr>
          <td>Бўлим мудири: <b>${pat.zavlv.fio}</b></td>
          <td style="border-bottom:1px solid black; width:30%"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
