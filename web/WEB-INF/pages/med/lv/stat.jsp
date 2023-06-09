<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="row" style="margin:20px 0 0 0">
  <div class="col-md-8">
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-twitter fa-fw"></i>
        Статистика
      </div>
      <div class="panel-body">
        <div class="list-group">
          <div class="list-group">
            <div href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество текущих пациентов
              <span class="pull-right text-muted small"><em>${c1}</em></span>
            </div>
            <div href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество выписанных пациентов за текущий месяц
              <span class="pull-right text-muted small"><em>${c2}</em></span>
            </div>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> ЛЮКС (Коек: ${c11}, Резидент: ${c11_UZB}, Не резидент: ${c11 - c11_UZB})
              <span class="pull-right text-muted small"><em>${c8}</em></span>
            </div>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> Полулюкс (Коек: ${c13}, Резидент: ${c13_UZB}, Не резидент: ${c13 - c13_UZB})
              <span class="pull-right text-muted small"><em>${c10}</em></span>
            </div>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> Простая (Коек: ${c12}, Резидент: ${c12_UZB}, Не резидент: ${c12 - c12_UZB})
              <span class="pull-right text-muted small"><em>${c9}</em></span>
            </div>
            <a href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество пациентов за прошлый месяц
              <span class="pull-right text-muted small"><em>${c3}</em></span>
            </a>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> ЛЮКС (Коек: ${c31}, Резидент: ${c31_UZB}, Не резидент: ${c31 - c31_UZB})
              <span class="pull-right text-muted small"><em>${c28}</em></span>
            </div>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> Полулюкс (Коек: ${c33}, Резидент: ${c33_UZB}, Не резидент: ${c33 - c33_UZB})
              <span class="pull-right text-muted small"><em>${c30}</em></span>
            </div>
            <div href="#" class="list-group-item" style="padding-left:35px">
              <i class="fa fa-users fa-fw"></i> Простая (Коек: ${c32}, Резидент: ${c32_UZB}, Не резидент: ${c32 - c33_UZB})
              <span class="pull-right text-muted small"><em>${c29}</em></span>
            </div>
            <a href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество пациентов за текущий год
              <span class="pull-right text-muted small"><em>${c4}</em></span>
            </a>
            <a href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество пациентов за прошлый год
              <span class="pull-right text-muted small"><em>${c5}</em></span>
            </a>
            <a href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество выписанных пациентов за сегодня
              <span class="pull-right text-muted small"><em>${c6}</em></span>
            </a>
            <a href="#" class="list-group-item">
              <i class="fa fa-twitter fa-fw"></i> Количество поступивших пациентов за сегодня
              <span class="pull-right text-muted small"><em>${c7}</em></span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-md-4">
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-twitter fa-fw"></i>
        Информация
      </div>
      <div class="panel-body">
        <div class="list-group">
          <div class="list-group">
            <a href="#" onclick="window.open('/lv/stat.s?stat=1'); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех обследования на сегодня
            </a>
            <a href="#" onclick="window.open('/lv/stat.s?stat=2'); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех обследования на завтра
            </a>
            <a href="#" onclick="window.open('/lv/stat.s?stat=3'); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех назначений на сегодня
            </a>
            <a href="#" onclick="window.open('/lv/stat.s?stat=4'); return false;" class="list-group-item">
              <i class="fa fa-print fa-fw"></i> Список всех назначений на завтра
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
