<%@ page pageEncoding="UTF-8" %>
<%-- Окно «Расчёт по препарату» (Анализ склада, Анализ медикаментов): содержимое из /mn/drug/analys.s --%>
<div class="fm-overlay" id="mnDrugModal" onclick="if (event.target === this) $('#mnDrugModal').removeClass('open')">
  <div class="fm-modal" style="width:1200px">
    <div class="fm-modal-head">
      <h3>Расчёт по препарату · <span id="drug_name"></span></h3>
      <button type="button" class="fm-x" onclick="$('#mnDrugModal').removeClass('open')"><i class="fa fa-times"></i></button>
    </div>
    <div class="fm-modal-body" id="drug_analys"></div>
  </div>
</div>
<script>
  function drugAnalys(tr) {
    var id = $(tr).attr('data-id');
    $('#drug_name').text(id + ' · ' + $(tr).attr('data-name'));
    $('#drug_analys').html('<div class="fm-hint">Загрузка…</div>').load('/mn/drug/analys.s?id=' + id);
    $('#mnDrugModal').addClass('open');
  }
</script>
