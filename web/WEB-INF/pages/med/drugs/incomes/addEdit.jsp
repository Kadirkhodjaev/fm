<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/js/fms-pick.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .ph { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    --ok:#15803D; --ok-bg:#E8F7EE; --warn:#B45309; --warn-bg:#FEF3C7;
    padding:12px 14px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .ph * { box-sizing:border-box; }
  .ph-top { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  .ph-top h2 { margin:0; font-size:19px; font-weight:700; }
  .ph-badge { display:inline-block; padding:3px 11px; border-radius:10px; font-size:12.5px; font-weight:600; background:var(--warn-bg); color:var(--warn); }
  .ph-badge.ok { background:var(--ok-bg); color:var(--ok); }
  .ph-top .sp { flex:1; }
  .ph .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 13px; border-radius:9px; border:1.5px solid var(--border); background:#fff; color:var(--text);
    font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .ph .ab:hover { background:var(--bg); }
  .ph .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ph .ab.primary:hover { background:var(--brand-dark); }
  .ph .ab.danger { color:var(--brand); }
  .ph .ab.sm { height:30px; padding:0 10px; font-size:12.5px; }
  .ph .ab:disabled { opacity:.5; cursor:not-allowed; }
  .ph-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:12px; }
  .ph-card-h { display:flex; align-items:center; gap:10px; padding:9px 14px; border-bottom:1px solid var(--border); background:#FAFBFC; border-radius:14px 14px 0 0; }
  .ph-card-h h3 { margin:0; font-size:14px; font-weight:700; }
  .ph-card-h .sp { flex:1; }
  .ph-card-b { padding:12px 14px; }
  .ph-row { display:flex; flex-wrap:wrap; gap:10px 14px; align-items:flex-end; }
  .ph .f { display:flex; flex-direction:column; gap:3px; min-width:0; }
  .ph .f > label { margin:0; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.2px; }
  .ph .form-control, .ph .pi { height:34px; border:1.5px solid var(--border); border-radius:9px; padding:4px 10px; font-size:14px; width:100%; box-shadow:none; background:#fff; color:var(--text); }
  .ph .form-control:focus, .ph .pi:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); outline:none; }
  .ph .pi[readonly] { background:#F8F9FA; color:var(--muted); }
  .ph textarea.pi { height:34px; resize:vertical; }
  .ph .num { text-align:right; font-variant-numeric:tabular-nums; }
  .ph .pk { display:flex; gap:6px; }
  .ph .pk .ab { padding:0 10px; }
  .ph .chips { display:flex; gap:5px; margin-top:4px; }
  .ph .chip { height:24px; padding:0 9px; border-radius:8px; border:1px solid var(--border); background:#fff; font-size:12px; color:var(--muted); cursor:pointer; }
  .ph .chip:hover { background:var(--brand-soft); color:var(--brand); border-color:#F6C4CA; }
  .ph .calc { display:flex; flex-wrap:wrap; gap:8px 22px; margin-top:10px; padding:8px 12px; border-radius:10px; background:#F8F9FA; font-size:13px; }
  .ph .calc span b { font-variant-numeric:tabular-nums; }
  .ph .calc .tot b { color:var(--brand); font-size:15px; }
  .ph .hint { margin-top:6px; font-size:12.5px; min-height:18px; }
  .ph .hint.warn { color:var(--warn); }
  .ph .hint.err { color:var(--brand); }
  .ph table.gr { width:100%; border-collapse:collapse; }
  .ph table.gr th { padding:7px 10px; font-size:11px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:right; background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; }
  .ph table.gr th.l, .ph table.gr td.l { text-align:left; }
  .ph table.gr td { padding:7px 10px; border-bottom:1px solid #F0F1F4; font-size:13.5px; text-align:right; font-variant-numeric:tabular-nums; vertical-align:middle; }
  .ph table.gr tbody tr:hover td { background:#FAFBFC; }
  .ph table.gr td.nm { text-align:left; }
  .ph table.gr td.nm .t { font-weight:600; }
  .ph table.gr td.nm .s { font-size:12px; color:var(--muted); }
  .ph table.gr td.nm a { color:var(--text); text-decoration:none; }
  .ph table.gr td.nm a:hover { color:var(--brand); text-decoration:underline; }
  .ph table.gr td.c { text-align:center; }
  .ph .exp { display:inline-block; padding:2px 9px; border-radius:8px; font-size:12.5px; background:#F1F2F4; color:#374151; }
  .ph .exp.w { background:var(--warn-bg); color:var(--warn); }
  .ph .exp.d { background:var(--brand-soft); color:var(--brand); }
  .ph .rm { border:0; background:none; color:#B0B6BF; padding:4px 7px; border-radius:8px; cursor:pointer; }
  .ph .rm:hover { background:var(--brand-soft); color:var(--brand); }
  .ph .totals { display:flex; flex-wrap:wrap; gap:6px 28px; padding:10px 14px; border-top:1px solid var(--border); background:#FAFBFC; border-radius:0 0 14px 14px; align-items:center; }
  .ph .totals .k { font-size:12px; color:var(--muted); }
  .ph .totals .v { font-weight:700; font-variant-numeric:tabular-nums; }
  .ph .totals .big .v { color:var(--brand); font-size:16px; }
  .ph .recon { margin-left:auto; display:flex; align-items:center; gap:8px; }
  .ph .recon .pi { width:150px; height:30px; }
  .ph .recon .st { font-size:12.5px; font-weight:600; }
  .ph .recon .st.ok { color:var(--ok); }
  .ph .recon .st.bad { color:var(--brand); }
  .ph .empty { padding:22px; text-align:center; color:var(--muted); }
  .ph .hid { display:none; }
</style>

<%-- Справочники для поиска: препараты и производители (названия экранируются через c:out) --%>
<div class="hid" id="ph-src" style="display:none">
  <c:forEach items="${drug_names}" var="cc"><i class="sd" data-id="${cc.id}" data-c="${cc.counter}" data-m="<c:out value='${cc.measure.name}'/>"><c:out value="${cc.name}"/></i></c:forEach>
  <c:forEach items="${mans}" var="cc"><i class="sm" data-id="${cc.id}"><c:out value="${cc.name}"/></i></c:forEach>
</div>

<div class="ph" id="ph" data-act="${obj.id}" data-state="${obj.state}" data-nds="${ndsProc}">
  <div class="ph-top">
    <h2>Приход<c:if test="${obj.id > 0}"> № ${obj.regNum} от <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.regDate}"/></c:if><c:if test="${empty obj.id or obj.id == 0}">: новый акт</c:if></h2>
    <c:if test="${obj.state == 'E'}"><span class="ph-badge">Введён, не подтверждён</span></c:if>
    <c:if test="${obj.state == 'O'}"><span class="ph-badge ok">Подтверждён</span></c:if>
    <c:if test="${obj.state == 'C'}"><span class="ph-badge ok">Закрыт</span></c:if>
    <span class="sp"></span>
    <button class="ab" type="button" onclick="setPage('/drugs/acts.s')"><i class="fa fa-backward"></i> К списку</button>
    <c:if test="${obj.state == 'E' || obj.state == null}">
      <button class="ab" type="button" onclick="PH.saveAct()"><i class="fa fa-save"></i> Сохранить реквизиты</button>
    </c:if>
    <c:if test="${obj.state == 'E'}">
      <button class="ab danger" type="button" onclick="PH.act('delete')"><i class="fa fa-trash-o"></i> Удалить акт</button>
      <button class="ab primary" type="button" onclick="PH.confirmAct()"><i class="fa fa-check"></i> Подтвердить акт</button>
    </c:if>
  </div>

  <%-- ===== Реквизиты акта ===== --%>
  <div class="ph-card">
    <div class="ph-card-h"><h3>Реквизиты акта</h3></div>
    <div class="ph-card-b">
      <form id="addEditForm" onsubmit="return false;">
        <input type="hidden" name="id" value="${obj.id}">
        <div class="ph-row">
          <div class="f" style="flex:2 1 360px">
            <label>Договор</label>
            <select class="form-control" name="contract">
              <c:forEach items="${contracts}" var="contract">
                <option <c:if test="${contract.id == obj.contract.id}">selected</c:if> value="${contract.id}">№${contract.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${contract.regDate}"/> - ${contract.partner.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="f" style="width:150px">
            <label>Рег № *</label>
            <input type="text" class="pi" name="reg_num" value="${obj.regNum}"/>
          </div>
          <div class="f" style="width:130px">
            <label>Рег дата *</label>
            <input type="text" class="pi" style="text-align:center" readonly name="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>
          </div>
          <div class="f" style="flex:2 1 260px">
            <label>Дополнительная информация</label>
            <input type="text" class="pi" name="extra_info" value="<c:out value='${obj.extraInfo}'/>"/>
          </div>
        </div>
      </form>
    </div>
  </div>

  <c:if test="${obj.state == 'E'}">
    <%-- ===== Ввод позиции ===== --%>
    <div class="ph-card" id="ph-entry">
      <div class="ph-card-h">
        <h3>Добавить позицию</h3>
        <span class="sp"></span>
        <span style="font-size:12.5px; color:var(--muted)">Enter — добавить и перейти к следующему препарату</span>
      </div>
      <div class="ph-card-b">
        <div class="ph-row">
          <div class="f" style="flex:2 1 300px">
            <label>Препарат *</label>
            <div class="pk">
              <input type="text" class="pi" id="e-drug" placeholder="Начните вводить название препарата">
              <button class="ab sm" type="button" title="Добавить новый препарат в справочник" data-toggle="modal" data-target="#phNewDrug"><i class="fa fa-plus"></i></button>
            </div>
          </div>
          <div class="f" style="flex:1 1 220px">
            <label>Производитель *</label>
            <div class="pk">
              <input type="text" class="pi" id="e-man" placeholder="Название производителя">
              <button class="ab sm" type="button" title="Добавить нового производителя" data-toggle="modal" data-target="#phNewMan"><i class="fa fa-plus"></i></button>
            </div>
          </div>
          <div class="f" style="width:150px">
            <label>Срок годности *</label>
            <input type="text" class="pi fms-cal" id="e-exp" placeholder="дд.мм.гггг" autocomplete="off">
            <div class="chips">
              <button type="button" class="chip" data-years="1">+1 г</button>
              <button type="button" class="chip" data-years="2">+2 г</button>
              <button type="button" class="chip" data-years="3">+3 г</button>
            </div>
          </div>
        </div>
        <div class="ph-row" style="margin-top:10px">
          <div class="f" style="width:110px"><label>Блоков *</label><input type="number" min="0" step="any" class="pi num" id="e-bc"></div>
          <div class="f" style="width:150px"><label>Цена блока *</label><input type="number" min="0" step="any" class="pi num" id="e-price"></div>
          <div class="f" style="width:130px"><label>Ед. в блоке</label><input type="number" min="0" step="any" class="pi num" id="e-upb"></div>
          <div class="f" style="width:130px"><label>Всего единиц</label><input type="number" min="0" step="any" class="pi num" id="e-cnt"></div>
          <div class="f" style="width:100px"><label>Ед. изм.</label><input type="text" class="pi" id="e-measure" readonly></div>
          <div class="f" style="margin-left:auto">
            <label>&nbsp;</label>
            <button class="ab primary" type="button" id="e-add"><i class="fa fa-plus"></i> Добавить в акт</button>
          </div>
        </div>
        <div class="calc">
          <span>Цена за единицу: <b id="c-unit">—</b></span>
          <span>НДС за единицу (${ndsProc}%): <b id="c-nds">—</b></span>
          <span>Сумма без НДС: <b id="c-net">—</b></span>
          <span class="tot">Сумма с НДС: <b id="c-gross">—</b></span>
        </div>
        <div class="hint" id="e-hint"></div>
      </div>
    </div>

    <%-- ===== Новый препарат / производитель в справочник ===== --%>
    <div class="modal fade" id="phNewDrug" tabindex="-1" role="dialog" style="display:none">
      <div class="modal-dialog" style="width:460px; max-width:96vw">
        <div class="modal-content">
          <div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Новый препарат в справочник</h4></div>
          <div class="modal-body">
            <form id="new-drug-form" onsubmit="return false;">
              <input type="hidden" name="id" value="" />
              <input type="hidden" name="code" value="drug" />
              <input type="hidden" name="state" value="Y" />
              <div class="ph" style="padding:0">
                <div class="f" style="margin-bottom:10px">
                  <label>Категория *</label>
                  <select class="form-control" name="category">
                    <c:forEach items="${categories}" var="category">
                      <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="f">
                  <label>Наименование *</label>
                  <input type="text" id="drug-name" class="pi" name="name" value=""/>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
            <button type="button" class="btn btn-primary" onclick="PH.saveNewDrug()">Сохранить</button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal fade" id="phNewMan" tabindex="-1" role="dialog" style="display:none">
      <div class="modal-dialog" style="width:460px; max-width:96vw">
        <div class="modal-content">
          <div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">Новый производитель</h4></div>
          <div class="modal-body">
            <form id="new-man-form" onsubmit="return false;">
              <input type="hidden" name="id" value="" />
              <input type="hidden" name="code" value="manufacturer" />
              <input type="hidden" name="state" value="Y" />
              <div class="ph" style="padding:0">
                <div class="f"><label>Наименование *</label><input type="text" id="man-name" class="pi" name="name" value=""/></div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" id="close-modal1" data-dismiss="modal">Закрыть</button>
            <button type="button" class="btn btn-primary" onclick="PH.saveNewMan()">Сохранить</button>
          </div>
        </div>
      </div>
    </div>
  </c:if>

  <%-- ===== Позиции акта ===== --%>
  <c:if test="${obj.id > 0}">
    <div class="ph-card">
      <div class="ph-card-h"><h3>Позиции акта</h3><span class="sp"></span><span id="g-count" style="font-size:12.5px; color:var(--muted)"></span></div>
      <div style="overflow-x:auto">
        <table class="gr" id="ph-grid">
          <thead>
            <tr>
              <th class="l">Препарат</th>
              <th>Срок годности</th>
              <th>Блоков</th>
              <th>Цена блока</th>
              <th>Единиц</th>
              <th>Цена ед.</th>
              <th>Цена ед. с НДС</th>
              <th>Сумма с НДС</th>
              <th>Расход</th>
              <th>Остаток</th>
              <th class="l">Ед.</th>
              <th style="width:44px"></th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${drugs}" var="drug">
              <tr data-id="${drug.id}" data-drug="${drug.drug.id}" data-man="${drug.manufacturer.id}" data-rasxod="${drug.rasxod}"
                  data-exp="<fmt:formatDate pattern="yyyy-MM-dd" value="${drug.endDate}"/>"
                  data-net="${drug.countPrice * drug.counter}" data-vat="${(empty drug.nds ? 0 : drug.nds) * drug.counter}"
                  data-price="${drug.price}" data-bc="${drug.blockCount}" data-cnt="${drug.counter}" data-unit="${drug.countPrice}">
                <td class="nm">
                  <c:if test="${drug.rasxod == 0}">
                    <a href="#" class="t" onclick="PH.edit(${drug.id}); return false;" title="Изменить цену и количество"><c:out value="${drug.drug.name}"/></a>
                  </c:if>
                  <c:if test="${drug.rasxod != 0}"><div class="t"><c:out value="${drug.drug.name}"/></div></c:if>
                  <div class="s"><c:out value="${drug.manufacturer.name}"/></div>
                </td>
                <td class="c"><span class="exp"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.endDate}"/></span></td>
                <td><fmt:formatNumber value="${drug.blockCount}" type="number"/></td>
                <td><fmt:formatNumber value="${drug.price}" type="number"/></td>
                <td><fmt:formatNumber value="${drug.counter}" type="number"/></td>
                <td><fmt:formatNumber value="${drug.countPrice}" type="number"/></td>
                <td><fmt:formatNumber value="${drug.countPrice + (empty drug.nds ? 0 : drug.nds)}" type="number"/></td>
                <td><b><fmt:formatNumber value="${(drug.countPrice + (empty drug.nds ? 0 : drug.nds)) * drug.counter}" type="number"/></b></td>
                <td><fmt:formatNumber value="${drug.rasxod}" type="number"/></td>
                <td><fmt:formatNumber value="${drug.counter - drug.rasxod}" type="number"/></td>
                <td class="l">${drug.measure.name}</td>
                <td class="c">
                  <c:if test="${obj.state == 'E' && drug.rasxod == 0}">
                    <button class="rm" type="button" title="Удалить позицию" onclick="PH.del(${drug.id})"><i class="fa fa-trash-o"></i></button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
        <div class="empty" id="g-empty" style="display:none">Позиций пока нет. Добавьте первую выше.</div>
      </div>
      <div class="totals">
        <span><span class="k">Без НДС</span><br><span class="v" id="t-net">0</span></span>
        <span><span class="k">НДС</span><br><span class="v" id="t-vat">0</span></span>
        <span class="big"><span class="k">Итого с НДС</span><br><span class="v" id="t-gross">0</span></span>
        <c:if test="${obj.state == 'E'}">
          <span class="recon">
            <span class="k" style="font-size:12px; color:var(--muted)">Сумма по накладной</span>
            <input type="text" class="pi num" id="recon-in" placeholder="сверить">
            <span class="st" id="recon-st"></span>
          </span>
        </c:if>
      </div>
    </div>
  </c:if>

  <%-- Редактирование цены и количества существующей позиции --%>
  <div class="modal fade" tabindex="-1" id="editDrugModal" role="dialog" style="display: none;">
    <div class="modal-dialog" style="width:480px; max-width:96vw">
      <div class="modal-content">
        <div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:16px"><span id="edit_drug_name"></span></h4></div>
        <div class="modal-body">
          <form id="editDrugForm" name="editDrugForm" onsubmit="return false;">
            <input type="hidden" name="id" value="" />
            <div class="ph" style="padding:0">
              <div class="ph-row">
                <div class="f" style="flex:1 1 180px"><label>Кол-во блоков *</label><input type="number" step="any" class="pi num" name="count_block" id="m-bc"></div>
                <div class="f" style="flex:1 1 180px"><label>Цена блока *</label><input type="number" step="any" class="pi num" name="price_block" id="m-price"></div>
                <div class="f" style="flex:1 1 180px"><label>Всего единиц *</label><input type="number" step="any" class="pi num" name="count_drug" id="m-cnt"></div>
                <div class="f" style="flex:1 1 180px"><label>Цена единицы *</label><input type="number" step="any" class="pi num" name="price_drug" id="m-unit"></div>
              </div>
              <div class="hint" style="margin-top:8px; color:var(--muted)">При изменении блоков и цены блока количество единиц и цена единицы пересчитываются (их можно поправить вручную). НДС пересчитывается при сохранении.</div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" id="edit-drug-close" data-dismiss="modal">Закрыть</button>
          <button type="button" class="btn btn-primary" onclick="PH.saveEdit()">Сохранить</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  window.PH = (function () {
    var $root = $('#ph'), actId = $root.data('act'), state = '' + $root.data('state'), ndsProc = Number($root.data('nds')) || 0;
    var drugs = [], mans = [], lastMan = {}, pickDrug = null, pickMan = null, cur = {drug: null, man: null};

    $('#ph-src .sd').each(function () {
      var d = $(this);
      drugs.push({id: d.data('id'), name: d.text(), counter: Number(d.data('c')) || 0, measure: '' + (d.data('m') || ''), hint: '' + (d.data('m') || '')});
    });
    $('#ph-src .sm').each(function () { mans.push({id: $(this).data('id'), name: $(this).text()}); });
    $('#ph-grid tbody tr').each(function () { lastMan[$(this).data('drug')] = $(this).data('man'); });

    function num(v) { var n = parseFloat(('' + v).replace(/[\s\u00a0]/g, '').replace(',', '.')); return isNaN(n) ? 0 : n; }
    function r2(n) { return Math.round(n * 100) / 100; }
    function fmt(n) { return Math.round(n).toLocaleString('ru-RU'); }
    function fmt2(n) { return n.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2}); }
    function msg(t, ok) { if (typeof showMsg === 'function') showMsg(t, ok); else alert(t); }
    function isoToRu(iso) { var a = iso.split('-'); return a[2] + '.' + a[1] + '.' + a[0]; }
    function parseRu(s) {
      var m = /^(\d{1,2})\.(\d{1,2})\.(\d{4})$/.exec($.trim(s));
      if (!m) return null;
      var d = new Date(+m[3], +m[2] - 1, +m[1]);
      return (d.getFullYear() === +m[3] && d.getMonth() === +m[2] - 1 && d.getDate() === +m[1]) ? d : null;
    }
    function expClass(d) {
      var days = (d - new Date()) / 86400000;
      return days < 90 ? 'd' : days < 180 ? 'w' : '';
    }

    /* ---------- итоги акта ---------- */
    function totals() {
      var net = 0, vat = 0, n = 0;
      $('#ph-grid tbody tr').each(function () { net += Number($(this).data('net')) || 0; vat += Number($(this).data('vat')) || 0; n++; });
      $('#t-net').text(fmt2(net)); $('#t-vat').text(fmt2(vat)); $('#t-gross').text(fmt2(net + vat));
      $('#g-count').text(n ? 'Позиций: ' + n : '');
      $('#g-empty').toggle(!n); $('#ph-grid').toggle(n > 0);
      recon(net + vat);
      return net + vat;
    }
    function recon(gross) {
      var v = $('#recon-in').val();
      if (v === undefined) return;
      var st = $('#recon-st').removeClass('ok bad').text('');
      if ($.trim(v) === '') return;
      var diff = r2(num(v) - gross);
      if (Math.abs(diff) < 1) st.addClass('ok').text('сходится');
      else st.addClass('bad').text('разница ' + fmt2(diff));
      try { localStorage.setItem('ph-recon-' + actId, v); } catch (e) {}
    }
    function markExpiry() {
      $('#ph-grid tbody tr').each(function () {
        var iso = '' + $(this).data('exp');
        if (!iso || iso.length < 10) return;
        var d = new Date(iso + 'T00:00:00');
        $(this).find('.exp').removeClass('w d').addClass(expClass(d));
      });
    }

    /* ---------- расчёт строки ввода ---------- */
    function calc(src) {
      var bc = num($('#e-bc').val()), price = num($('#e-price').val()), upb = num($('#e-upb').val()), cnt = num($('#e-cnt').val());
      if (src === 'cnt' && bc > 0 && cnt > 0) { upb = cnt / bc; $('#e-upb').val(r2(upb)); }
      else if (bc > 0 && upb > 0) { cnt = bc * upb; $('#e-cnt').val(cnt); }
      var unit = (upb > 0 && price > 0) ? r2(price / upb) : 0;
      var nds = r2(Math.round(ndsProc * unit) / 100);
      $('#c-unit').text(unit ? fmt2(unit) : '—');
      $('#c-nds').text(unit ? fmt2(nds) : '—');
      $('#c-net').text(unit && cnt ? fmt2(unit * cnt) : '—');
      $('#c-gross').text(unit && cnt ? fmt2((unit + nds) * cnt) : '—');
      return {bc: bc, price: price, upb: upb, cnt: cnt, unit: unit, nds: nds};
    }
    function hint(t, cls) { $('#e-hint').removeClass('warn err').addClass(cls || '').text(t || ''); }
    function checkSoft() {
      var d = parseRu($('#e-exp').val()), t = '';
      if (d) {
        var days = (d - new Date()) / 86400000;
        if (days <= 0) { hint('Срок годности уже истёк', 'err'); return; }
        if (days < 180) t = 'Остаточный срок годности меньше 6 месяцев';
      }
      var dr = cur.drug;
      if (dr && d) {
        var iso = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2), dup = false;
        $('#ph-grid tbody tr').each(function () { if ($(this).data('drug') == dr.id && $(this).data('exp') == iso) dup = true; });
        if (dup) t = (t ? t + '. ' : '') + 'В акте уже есть этот препарат с таким же сроком годности (та же партия?)';
      }
      hint(t, t ? 'warn' : '');
    }

    function resetEntry(full) {
      pickDrug.clear(); cur.drug = null;
      $('#e-bc, #e-price, #e-upb, #e-cnt, #e-measure').val('');
      if (full) { pickMan.clear(); cur.man = null; $('#e-exp').val(''); }
      calc(); hint('');
    }

    function add() {
      var c = calc(), d = parseRu($('#e-exp').val()), err = '';
      if (!cur.drug) err = 'Выберите препарат из списка подсказок';
      else if (!cur.man) err = 'Выберите производителя из списка подсказок';
      else if (!d) err = 'Укажите срок годности в формате дд.мм.гггг';
      else if (d <= new Date()) err = 'Срок годности не может быть меньше текущей даты';
      else if (!(c.bc > 0)) err = 'Укажите количество блоков';
      else if (!(c.price > 0)) err = 'Укажите цену блока';
      else if (!(c.upb > 0)) err = 'Укажите количество единиц в блоке';
      if (err) { hint(err, 'err'); return; }
      var data = {act: actId, drug: cur.drug.id, man: cur.man.id, end_date: $.trim($('#e-exp').val()), price: c.price, block_count: c.bc,
        counter: c.cnt, one_price: c.unit, nds: c.nds};
      $('#e-add').prop('disabled', true);
      $.ajax({
        url: '/drugs/act/drug/save.s', method: 'post', data: data, dataType: 'json',
        success: function (res) {
          if (!res.success) { hint(res.msg || 'Не удалось добавить', 'err'); return; }
          var id = res.id || 0, name = cur.drug.name;
          appendRow(id, cur.drug, cur.man, d, c);
          lastMan[cur.drug.id] = cur.man.id;
          msg('Добавлено: ' + name, true);
          resetEntry(false);
          $('#e-drug').focus();
        },
        error: function () { hint('Ошибка связи с сервером', 'err'); },
        complete: function () { $('#e-add').prop('disabled', false); }
      });
    }
    function esc(s) { return $('<div/>').text(s == null ? '' : s).html(); }
    function appendRow(id, dr, man, d, c) {
      var iso = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2);
      var tr = $('<tr/>').attr({'data-id': id, 'data-drug': dr.id, 'data-man': man.id, 'data-rasxod': 0, 'data-exp': iso,
        'data-net': c.unit * c.cnt, 'data-vat': c.nds * c.cnt, 'data-price': c.price, 'data-bc': c.bc, 'data-cnt': c.cnt, 'data-unit': c.unit})
        .data({id: id, drug: dr.id, man: man.id, rasxod: 0, exp: iso, net: c.unit * c.cnt, vat: c.nds * c.cnt, price: c.price, bc: c.bc, cnt: c.cnt, unit: c.unit});
      tr.html(
        '<td class="nm"><a href="#" class="t" onclick="PH.edit(' + id + '); return false;" title="Изменить цену и количество">' + esc(dr.name) + '</a><div class="s">' + esc(man.name) + '</div></td>' +
        '<td class="c"><span class="exp ' + expClass(d) + '">' + isoToRu(iso) + '</span></td>' +
        '<td>' + fmt2(c.bc).replace(/,00$/, '') + '</td><td>' + fmt2(c.price).replace(/,00$/, '') + '</td><td>' + fmt2(c.cnt).replace(/,00$/, '') + '</td>' +
        '<td>' + fmt2(c.unit).replace(/,00$/, '') + '</td><td>' + fmt2(c.unit + c.nds).replace(/,00$/, '') + '</td>' +
        '<td><b>' + fmt2((c.unit + c.nds) * c.cnt).replace(/,00$/, '') + '</b></td><td>0</td><td>' + fmt2(c.cnt).replace(/,00$/, '') + '</td>' +
        '<td class="l">' + esc(dr.measure) + '</td>' +
        '<td class="c"><button class="rm" type="button" title="Удалить позицию" onclick="PH.del(' + id + ')"><i class="fa fa-trash-o"></i></button></td>');
      $('#ph-grid tbody').prepend(tr);
      totals();
    }

    /* ---------- редактирование и удаление позиции ---------- */
    function mCalc(src) {
      var bc = num($('#m-bc').val()), price = num($('#m-price').val()), cnt = num($('#m-cnt').val()), unit = num($('#m-unit').val());
      var upb = $('#m-cnt').data('upb') || 0;
      if (src === 'bc' && upb > 0) { cnt = bc * upb; $('#m-cnt').val(cnt); }
      if ((src === 'bc' || src === 'price' || src === 'cnt') && bc > 0 && cnt > 0 && price > 0) { $('#m-unit').val(r2(price / (cnt / bc))); }
    }
    function edit(id) {
      var tr = $('#ph-grid tbody tr[data-id=' + id + ']');
      $('#edit_drug_name').text(tr.find('.t').first().text());
      $('#editDrugForm input[name=id]').val(id);
      var bc = Number(tr.data('bc')), cnt = Number(tr.data('cnt'));
      $('#m-bc').val(bc); $('#m-price').val(tr.data('price')); $('#m-cnt').val(cnt).data('upb', bc > 0 ? cnt / bc : 0); $('#m-unit').val(tr.data('unit'));
      $('#editDrugModal').modal('show');
    }
    function saveEdit() {
      $.ajax({
        url: '/drugs/act/drug/update.s', method: 'post', data: $('#editDrugForm').serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('#editDrugModal').modal('hide'); $('.modal-backdrop').remove(); $('body').removeClass('modal-open');
            msg('Данные успешно сохранены', true);
            setPage('/drugs/act/addEdit.s?id=' + actId);
          } else msg(res.msg, false);
        }
      });
    }
    function del(id) {
      var tr = $('#ph-grid tbody tr[data-id=' + id + ']');
      if (!confirm('Удалить позицию «' + $.trim(tr.find('.t').first().text()) + '» из акта?')) return;
      $.ajax({
        url: '/drugs/act/drug/delete.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) {
          if (res.success) { tr.remove(); totals(); msg('Позиция удалена', true); } else msg(res.msg, false);
        }
      });
    }

    /* ---------- действия с актом ---------- */
    function saveAct() {
      var f = $('#addEditForm');
      if ($.trim(f.find('[name=reg_num]').val()) === '' || $.trim(f.find('[name=reg_date]').val()) === '') { msg('Заполните все обязательные поля', false); return; }
      $.ajax({
        url: '/drugs/act/addEdit.s', method: 'post', data: f.serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) { msg('Данные успешно сохранены', true); setPage('/drugs/act/addEdit.s?id=' + res.id); } else msg(res.msg, false);
        }
      });
    }
    function act(action) {
      if (!confirm(action === 'delete' ? 'Удалить акт целиком вместе со всеми позициями?' : 'Подтверждаете данное действие?')) return;
      $.ajax({
        url: '/drugs/act/action.s', method: 'post', data: 'code=' + action + '&id=' + actId, dataType: 'json',
        success: function (res) {
          if (res.success) {
            if (action === 'confirm') setPage('/drugs/act/addEdit.s?id=' + res.id); else setPage('/drugs/acts.s');
          } else msg(res.msg, false);
        }
      });
    }
    function confirmAct() {
      var gross = totals(), v = $('#recon-in').val();
      var n = $('#ph-grid tbody tr').length;
      if (!n) { msg('В акте нет ни одной позиции', false); return; }
      var txt = 'Подтвердить акт? Позиций: ' + n + ', итого с НДС: ' + fmt2(gross) + '.\nПосле подтверждения препараты поступят на склад.';
      if ($.trim(v) !== '' && Math.abs(num(v) - gross) >= 1) txt = 'ВНИМАНИЕ: сумма по накладной (' + fmt2(num(v)) + ') не совпадает с итогом акта (' + fmt2(gross) + ').\n\n' + txt;
      if (!confirm(txt)) return;
      $.ajax({
        url: '/drugs/act/action.s', method: 'post', data: 'code=confirm&id=' + actId, dataType: 'json',
        success: function (res) { if (res.success) setPage('/drugs/act/addEdit.s?id=' + res.id); else msg(res.msg, false); }
      });
    }

    /* ---------- новый препарат / производитель ---------- */
    function saveNewDrug() {
      if ($.trim($('#drug-name').val()) === '') { alert('Наименование не может быть пустым'); return; }
      $.ajax({
        url: '/drugs/dict/save.s', method: 'post', data: $('#new-drug-form').serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) {
            var item = {id: res.id, name: res.name, counter: 0, measure: '', hint: ''};
            drugs.push(item); pickDrug.setItems(drugs); pickDrug._pick(item);
            $('#close-modal').click(); $('#new-drug-form')[0].reset();
          } else alert(res.msg);
        }
      });
    }
    function saveNewMan() {
      if ($.trim($('#man-name').val()) === '') { alert('Наименование не может быть пустым'); return; }
      $.ajax({
        url: '/drugs/dict/save.s', method: 'post', data: $('#new-man-form').serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) {
            var item = {id: res.id, name: res.name};
            mans.push(item); pickMan.setItems(mans); pickMan._pick(item);
            $('#close-modal1').click(); $('#new-man-form')[0].reset();
          } else alert(res.msg);
        }
      });
    }

    /* ---------- инициализация ---------- */
    $(function () {
      markExpiry(); totals();
      try { var saved = localStorage.getItem('ph-recon-' + actId); if (saved && $('#recon-in').length) { $('#recon-in').val(saved); totals(); } } catch (e) {}
      $('#recon-in').on('input', function () { totals(); });
      if (!$('#e-drug').length) return;
      pickDrug = fmsPick($('#e-drug')[0], {
        items: drugs,
        onPick: function (d) {
          cur.drug = d;
          $('#e-measure').val(d.measure);
          $('#e-upb').val(d.counter > 0 ? d.counter : '');
          if (lastMan[d.id] && !cur.man) { var m = mans.filter(function (x) { return x.id == lastMan[d.id]; })[0]; if (m) { pickMan.set(m); cur.man = m; } }
          calc(); checkSoft();
          $(cur.man ? '#e-exp' : '#e-man').focus();
        },
        onClear: function () { cur.drug = null; $('#e-measure').val(''); }
      });
      pickMan = fmsPick($('#e-man')[0], {
        items: mans,
        onPick: function (m) { cur.man = m; $('#e-exp').focus(); },
        onClear: function () { cur.man = null; }
      });
      $('#e-bc, #e-price, #e-upb').on('input', function () { calc(); });
      $('#e-cnt').on('input', function () { calc('cnt'); });
      $('#e-exp').on('input change', checkSoft);
      $('#ph-entry .chip').on('click', function () {
        var d = new Date(); d.setFullYear(d.getFullYear() + Number($(this).data('years')));
        $('#e-exp').val(('0' + d.getDate()).slice(-2) + '.' + ('0' + (d.getMonth() + 1)).slice(-2) + '.' + d.getFullYear()).trigger('change');
      });
      $('#e-add').on('click', add);
      $('#ph-entry').on('keydown', 'input.pi', function (e) {
        if (e.which === 13 && !$(e.target).is('#e-drug, #e-man')) { e.preventDefault(); add(); }
      });
      $('#m-bc').on('input', function () { mCalc('bc'); });
      $('#m-price').on('input', function () { mCalc('price'); });
      $('#m-cnt').on('input', function () { mCalc('cnt'); });
      $('#e-drug').focus();
    });

    return {saveAct: saveAct, act: act, confirmAct: confirmAct, add: add, edit: edit, saveEdit: saveEdit, del: del, saveNewDrug: saveNewDrug, saveNewMan: saveNewMan};
  })();
</script>
