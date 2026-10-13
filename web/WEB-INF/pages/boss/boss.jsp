<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Модуль «Руководство и учредители» (страница /boss.s). Грузится в #mainWindow через openPage/setPage, как остальные страницы.
  Контроллер страницы кладёт в модель:
    today    — сегодняшняя дата (java.util.Date)
    dataFrom — первая дата, за которую есть данные (java.util.Date)
  Данные каждой вкладки JS берёт POST-запросом с /boss/data.s?tab=<вкладка>, когда вкладку открывают (формат в README.md).
  JS лежит в отдельных файлах: в JSP запись ${...} внутри JS была бы съедена EL.
--%>
<link href="/res/boss/boss.css?v=9" rel="stylesheet">
<%-- Страница вставляется в #mainWindow через jQuery, и jQuery сам скачивает эти скрипты по XHR: атрибут charset тогда не действует,
     текст декодируется по Content-Type сервера. Поэтому для скриптов модуля явно просим UTF-8 (файлы к тому же сохранены с BOM). --%>
<script>
  if (window.jQuery && !window.__bossUtf8) {
    window.__bossUtf8 = true;
    jQuery.ajaxPrefilter('script', function (o) { if (o.url && o.url.indexOf('/res/boss/') !== -1) o.mimeType = 'text/javascript; charset=UTF-8'; });
  }
</script>
<script src="/res/boss/rp.js?v=9" charset="UTF-8"></script>
<script src="/res/boss/boss.js?v=11" charset="UTF-8"></script>

<div class="fms-ruk" id="fmsRuk">
  <div class="head">
    <div>
      <div class="crumb"><a href="#">Разделы</a> / Управление</div>
      <h1>Руководство и учредители</h1>
      <p>Деньги, койки и приём клиники за <span data-rk="periodLabel"></span>. Суммы в тыс. сум.</p>
    </div>
    <div class="spacer"></div>
    <span class="sample" data-rk="sample" hidden>Пример данных. Реальные цифры придут из MedOnline</span>
  </div>

  <div class="filters">
    <div class="rp" data-rk="period"></div>
    <span class="cmp">Сравниваем с <b data-rk="prevLabel"></b></span>
    <span class="hint">Месяц сравнивается с прошлым месяцем, квартал с прошлым кварталом, неделя с прошлой неделей по тем же дням. Другие даты с таким же числом дней перед ними.</span>
  </div>
  <div class="err-box" data-rk="error" hidden><span data-rk="errorText"></span> <button type="button" class="btn-g" data-rk="retry">Повторить</button></div>
  <div class="loading" data-rk="loading" hidden><span class="spin" aria-hidden="true"></span>Загружаю данные вкладки…</div>

  <nav class="tabs" role="tablist" aria-label="Разделы модуля">
    <button type="button" role="tab" data-t="sum">Сводка</button>
    <button type="button" role="tab" data-t="cash">Касса</button>
    <button type="button" role="tab" data-t="stat">Стационар</button>
    <button type="button" role="tab" data-t="amb">Амбулатория</button>
    <button type="button" role="tab" data-t="drug">Медикаменты</button>
    <button type="button" role="tab" data-t="doc">Врачи и партнёры</button>
    <button type="button" role="tab" data-t="clients">Клиенты</button>
  </nav>

  <div data-rk-body>
    <!-- СВОДКА -->
    <section data-panel="sum" class="grid">
      <div class="c12 kpis" data-rk="kpis"></div>
      <div class="card c12">
        <h3>Сейчас и в прошлом периоде</h3>
        <p class="sub" data-rk="cmpSub"></p>
        <div class="tw"><table data-rk="cmp"></table></div>
      </div>
      <div class="card c12">
        <h3>Поступления в кассу по месяцам</h3>
        <p class="sub">Оплаты стационара и амбулатории в кассе, тыс. сум. Серым выделен выбранный период, пунктиром прошлый. Наведите на график, чтобы увидеть суммы.</p>
        <div class="legend"><span><i style="background:var(--s1)"></i>Стационар</span><span><i style="background:var(--s2)"></i>Амбулатория</span></div>
        <svg class="chart" data-rk="trend" viewBox="0 0 1200 250" role="img" aria-label="Поступления стационара и амбулатории за 12 месяцев"></svg>
      </div>
      <div class="card c12">
        <h3>Из чего складывается акт стационара</h3>
        <p class="sub">Разделы акта выполненных работ за период и сколько было в прошлом периоде</p>
        <div class="tw"><table data-rk="acts"></table></div>
      </div>
    </section>

    <!-- КАССА -->
    <section data-panel="cash" class="grid" hidden>
      <div class="card c6">
        <h3>Способы оплаты</h3>
        <p class="sub">Операции по кассе: наличные, пластик, онлайн, перечисление</p>
        <div class="hbar" data-rk="pay"></div>
      </div>
      <div class="card c6">
        <h3>Скидки по типам</h3>
        <p class="sub">Тип скидки пациента и ручные скидки в кассе, тыс. сум</p>
        <div class="hbar" data-rk="disc"></div>
      </div>
      <div class="card c12">
        <h3>Кассиры</h3>
        <p class="sub">Кто принимал деньги, делал возвраты и давал скидки. Нажмите на заголовок столбца для сортировки.</p>
        <div class="tw"><table data-rk="cashiers"></table></div>
      </div>
    </section>

    <!-- СТАЦИОНАР -->
    <section data-panel="stat" class="grid" hidden>
      <div class="card c7">
        <h3>Коечный фонд сейчас</h3>
        <p class="sub" data-rk="bedSub"></p>
        <div class="floors" data-rk="floors"></div>
        <div class="bedkey"><span><i class="bed"></i>занята</span><span><i class="bed bron"></i>бронь</span><span><i class="bed free"></i>свободна</span></div>
      </div>
      <div class="card c5">
        <h3>Отделения</h3>
        <p class="sub">Выписано, средний койко-день и сумма актов</p>
        <div class="tw"><table data-rk="deps"></table></div>
      </div>
      <div class="card c12">
        <h3>Незакрытые акты с долгом</h3>
        <p class="sub">Акты, где «К оплате» больше нуля. Пациент выписан, а касса не закрыта.</p>
        <div class="tw"><table data-rk="debts"></table></div>
      </div>
    </section>

    <!-- АМБУЛАТОРИЯ -->
    <section data-panel="amb" class="grid" hidden>
      <div class="card c12">
        <h3>Пациенты в амбулатории сейчас</h3>
        <p class="sub">Статусы регистраций на текущий момент</p>
        <div class="flow" data-rk="flow"></div>
      </div>
      <div class="card c6">
        <h3>Выручка по группам услуг</h3>
        <p class="sub">Группы амбулаторных услуг за период</p>
        <div class="hbar" data-rk="ambGroups"></div>
      </div>
      <div class="card c6">
        <h3>Резиденты и иностранцы</h3>
        <p class="sub">Иностранцы платят по отдельному прейскуранту</p>
        <div class="hbar" data-rk="resid"></div>
        <p class="sub" style="margin:12px 0 0" data-rk="residNote"></p>
      </div>
    </section>

    <!-- МЕДИКАМЕНТЫ -->
    <section data-panel="drug" class="grid" hidden>
      <div class="c12 kpis k5" data-rk="drugKpis"></div>
      <div class="card c12">
        <h3>Медикаменты по отделениям</h3>
        <p class="sub">Выдано на пост и списано в акты пациентов по цене аптеки, тыс. сум. Разница не попала ни в акты, ни в остаток поста. Кабинеты и списание без отделения сюда не входят. Акт считается по дате выписки, поэтому за короткий период в акты может уйти больше, чем выдано: расходуются остатки поста.</p>
        <div class="tw"><table data-rk="drugDeps"></table></div>
      </div>
      <div class="card c7">
        <h3>Препараты с наибольшим расходом</h3>
        <p class="sub">Топ-8 по сумме расхода за период, тыс. сум</p>
        <div class="tw"><table data-rk="drugTop"></table></div>
      </div>
      <div class="card c5">
        <h3>По типу назначения</h3>
        <p class="sub">Назначения врачей за период, штук</p>
        <div class="hbar" data-rk="drugTypes"></div>
        <h3 style="margin-top:20px">Чьи препараты</h3>
        <p class="sub">«Свой» значит, что пациент принёс препарат сам и в акт он не попадает</p>
        <div class="hbar" data-rk="drugSource"></div>
      </div>
    </section>

    <!-- ВРАЧИ И ПАРТНЁРЫ -->
    <section data-panel="doc" class="grid" hidden>
      <div class="card c12">
        <h3>Врачи</h3>
        <p class="sub">Услуги, выручка и вознаграждение по проценту из карточки услуги, тыс. сум</p>
        <div class="tw"><table data-rk="docs"></table></div>
      </div>
      <div class="card c12">
        <h3>Партнёры-направители</h3>
        <p class="sub">По коду отправителя при регистрации и проценту для партнёров из группы услуг, тыс. сум</p>
        <div class="tw"><table data-rk="partners"></table></div>
      </div>
    </section>

    <!-- КЛИЕНТЫ: клиентская база и финансовый анализ клиента (/boss/clients/*), не зависит от периода -->
    <section data-panel="clients" hidden>
      <div id="bossClients"><div class="loading"><span class="spin" aria-hidden="true"></span>Загружаю клиентов…</div></div>
    </section>
  </div>
</div>

<script>
  FmsRuk.init(document.getElementById('fmsRuk'), {
    today: '<fmt:formatDate value="${today}" pattern="dd.MM.yyyy"/>',
    dataFrom: '<fmt:formatDate value="${dataFrom}" pattern="dd.MM.yyyy"/>'
  });

  // Вкладка «Клиенты» грузит свои страницы (список и карточку клиента) внутрь себя
  function bossCl(url) {
    $('#bossClients').load(url);
  }
  (function () {
    var root = document.getElementById('fmsRuk');
    var filters = root.querySelector('.filters');
    var loaded = false;
    function sync() {
      var on = !root.querySelector('[data-panel="clients"]').hidden;
      if (filters) filters.style.display = on ? 'none' : '';   // период к клиентам не относится
      if (on && !loaded) { loaded = true; bossCl('/boss/clients/list.s'); }
    }
    root.querySelectorAll('.tabs button').forEach(function (b) { b.addEventListener('click', function () { setTimeout(sync, 0); }); });
    sync();
  })();
</script>
