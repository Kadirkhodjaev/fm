<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:if test="${!print}">
  <tr>
    <td colspan="10" class="kp-doc" style="font-weight:bold; padding: 10px"><div class="kp-sign"><span>Врач</span><span class="ln"></span><b>${conf_user_fio}</b></div></td>
  </tr>
</c:if>
</table>
<c:if test="${frag}"><script type="application/json" class="kb-data">${data}</script></c:if>
<c:if test="${!frag && !print}">
<script>
  // печать: значение вне нормы вида «a-b» выделяется и помечается стрелкой
  (function () {
    // все листы на странице (печать нескольких анализов собирает их в одну); каждый размечается один раз
    var ts = document.querySelectorAll('td.kp-res > table');
    for (var k = 0; k < ts.length; k++) if (!ts[k].getAttribute('data-kp')) { ts[k].setAttribute('data-kp', '1'); mark(ts[k]); }
    // пустая шапка бланка (у формы нет текста шапки) не печатается
    var sh = document.querySelectorAll('td.kp-shapka');
    for (var j = 0; j < sh.length; j++) if (!(sh[j].textContent || '').replace(/\s/g, '')) sh[j].parentNode.style.display = 'none';
    function mark(t) {
    if (!t.rows.length) return;
    var h = t.rows[0].cells, vi = -1, ni = -1;
    if (h.length > 1) t.rows[0].className += ' kp-th';
    for (var i = 0; i < h.length; i++) {
      var x = (h[i].textContent || '').toLowerCase();
      if (vi < 0 && /киймат|қиймат|натижа|результат|значение/.test(x)) vi = i;
      if (ni < 0 && /норма|меъёр|меьёр/.test(x)) ni = i;
    }
    if (vi < 0) return;
    function num(s) { s = String(s).replace(/\s/g, '').replace(',', '.'); return s !== '' && !isNaN(s) ? Number(s) : null; }
    for (var r = 1; r < t.rows.length; r++) {
      var c = t.rows[r].cells;
      if (c.length != h.length) continue;
      c[vi].className += ' kp-v';
      if (ni < 0) continue;
      c[ni].style.whiteSpace = 'nowrap';
      var m = /^\s*(\d+(?:[.,]\d+)?)\s*-\s*(\d+(?:[.,]\d+)?)\s*$/.exec(c[ni].textContent || ''), v = num(c[vi].textContent);
      if (!m || v == null) continue;
      var lo = num(m[1]), hi = num(m[2]);
      if (v < lo || v > hi) { c[vi].className += ' kp-out'; c[vi].innerHTML += v < lo ? ' &darr;' : ' &uarr;'; }
    }
    }
  })();
</script>
</c:if>
<c:if test="${!frag}">
</td>
</tr>
</table>
</form>
<iframe id="frmDiv" name="frm" style="display: none"></iframe>
<script>
  function save() {
    var tds = document.getElementsByTagName('td');
    for (var i=0;i<tds.length;i++) {
      if (tds[i].getAttribute('required') == 'true') {
        if (tds[i].getElementsByTagName('textarea')[0].value == '') {
          top.alert('Не заполнено поля Заключение');
          return;
        }
      }
    }
    if (document.getElementById("form_999")) {
      var nicE = new nicEditors.findEditor('id_c2');
      document.getElementById("id_c2").value = nicE.getContent();
    }
    document.getElementById('formAction').submit();
  }
  function conf(){
    frm.location = "/kdo/conf.s?id=${plan.id}";
  }
  function printPage(){
    window.open('/kdo/print.s?id=${plan.id}');
  }
  <c:if test="${print}">
  try {
    var data = {'formAction':[${data}]};
    for(var elv in data.formAction) {
      var r = data.formAction[elv];
      for (var e in r) {
        try {
          document.getElementsByName(e)[0].value = r[e];
        } catch (e) {}
      }
    }
  } catch(e) {
    top.alert(e);
  }
  </c:if>
</script>
</body>
</html>
</c:if>
