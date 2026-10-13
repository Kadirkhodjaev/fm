<%@ page pageEncoding="UTF-8" %>
<%-- Аптека → Справочники: общее для вкладок (стиль, поиск по строкам, окно, загрузка/сохранение/удаление через /drugs/dict/*.s) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  table.fm-grid tbody tr { cursor:pointer; }
  .dk-st { display:inline-block; padding:0 8px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:20px; }
  .dk-st.A { background:#E9F7EF; color:#1E7B43; }
  .dk-st.P { background:#F1F2F4; color:#6B7280; }
  .dk-yes { display:inline-block; padding:0 7px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .dk-no { color:#C3C7CE; }
  table.fm-grid tr[data-f=P] .nm { color:#9AA1AC; }
  .dk-checks { display:grid; grid-template-columns:repeat(auto-fill, minmax(190px, 1fr)); gap:6px 12px; max-height:220px; overflow:auto; padding:8px 10px; border:1px solid #E6E8EC; border-radius:10px; }
  .dk-checks label { display:flex; align-items:center; gap:7px; margin:0; font-size:13px; font-weight:500; color:#1F2430; cursor:pointer; }
  .dk-checks input { margin:0; }
</style>
<script>
  var DK = {
    base: '/drugs/dict', // адрес справочников: /drugs/dict (аптека) или /eats/dict (питание)
    // строки #<p>Rows: data-s (текст поиска), data-f (A/P для кнопок #<p>Seg)
    filter: function (p) {
      var f = $('#' + p + 'Seg button.on').attr('data-f') || '';
      var q = $.trim($('#' + p + 'Search').val() || '').toLowerCase(), words = q ? q.split(/\s+/) : [], n = 0;
      $('#' + p + 'Rows > tr').each(function () {
        var tr = $(this), s = String(tr.attr('data-s') || '').toLowerCase(), ok = !f || tr.attr('data-f') == f;
        for (var i = 0; ok && i < words.length; i++) if (s.indexOf(words[i]) < 0) ok = false;
        tr.toggle(ok);
        if (ok) n++;
      });
      $('#' + p + 'Shown').text(n);
      $('#' + p + 'Empty').toggle(n == 0);
    },
    seg: function (p, btn) { $(btn).addClass('on').siblings().removeClass('on'); DK.filter(p); },
    reload: function (page) { $('#pager').load(DK.base + '/' + page + '.s'); },
    open: function (p, title) { $('#' + p + 'Err').hide(); $('#' + p + 'Title').text(title); $('#' + p + 'Modal').addClass('open'); },
    close: function (p) { $('#' + p + 'Modal').removeClass('open'); },
    err: function (p, msg) { $('#' + p + 'Err').text(msg).show(); },
    get: function (p, code, id, fill) {
      $.ajax({
        url: DK.base + '/get.s', method: 'post', data: 'code=' + code + '&id=' + id, dataType: 'json',
        success: function (res) { if (res.success) fill(res); else DK.err(p, res.msg); }
      });
    },
    save: function (p, form, page) {
      $.ajax({
        url: DK.base + '/save.s', method: 'post', data: $(form).serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) { openMsg(res); DK.close(p); DK.reload(page); }
          else DK.err(p, res.msg);
        }
      });
    },
    del: function (code, id, name, page) {
      FmsConfirm('Удалить «' + name + '»?', function () {
      $.ajax({
        url: DK.base + '/delete.s', method: 'post', data: 'code=' + code + '&id=' + id, dataType: 'json',
        success: function (res) {
          if (res.success) { openMedMsg('Запись удалена', true); DK.reload(page); }
          else errMsg(res.msg);
        }
      });
    });
    },
    // состояние в окне: радиокнопки name=state со значениями Y / ''
    setState: function (form, on) { $(form).find('[name=state][value="' + (on ? 'Y' : '') + '"]').prop('checked', true); }
  };
</script>
