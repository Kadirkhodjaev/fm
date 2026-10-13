<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../proc/nurse_style.jsp"%>
<style>
  .st-grid { display:grid; grid-template-columns:repeat(auto-fit, minmax(260px, 1fr)); gap:12px; max-width:900px; }
  .st-field label { display:block; margin:0 0 6px; font-size:13px; font-weight:600; color:var(--muted); }
  .st-field .np-in, .st-field select { width:100%; height:48px; padding:0 12px; border:1px solid var(--border); border-radius:12px; background:#fff; font-size:16px; font-family:inherit; color:var(--text); }
  .st-rep { display:flex; align-items:center; gap:14px; width:100%; min-height:72px; padding:14px 16px; text-align:left; background:#fff;
    border:1px solid var(--border); border-radius:16px; cursor:pointer; font-family:inherit; font-size:15.5px; font-weight:600; color:var(--text); }
  .st-rep .fa { width:44px; height:44px; flex:none; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; font-size:20px; }
  .st-rep small { display:block; margin-top:2px; font-size:13px; font-weight:400; color:var(--muted); }
  .st-rep:active { transform:scale(.99); }
</style>
<div class="np">
  <div class="np-head">
    <div class="np-title">
      <span class="ic"><i class="fa fa-bar-chart"></i></span>
      <div>
        <h2>Статистика и списки</h2>
        <span class="sub">Печатные списки обследований по отделению</span>
      </div>
    </div>
  </div>

  <div class="np-card" style="max-width:900px">
    <div class="np-card-body">
      <div class="st-grid" style="margin-bottom:14px">
        <div class="st-field">
          <label for="date_iso">Дата</label>
          <input type="date" class="np-in" id="date_iso"/>
        </div>
        <div class="st-field">
          <label for="dep_id">Отделение</label>
          <select id="dep_id">
            <c:forEach items="${depts}" var="dep">
              <option value="${dep.id}">${dep.name}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="st-grid">
        <button type="button" class="st-rep" onclick="openRep(3)"><i class="fa fa-print"></i><span>Список всех обследований на дату<small>по выбранной дате и отделению</small></span></button>
        <button type="button" class="st-rep" onclick="openRep(4)"><i class="fa fa-print"></i><span>Список обследований на завтра (НЮ)<small>на следующий день после выбранной даты</small></span></button>
      </div>
    </div>
  </div>
</div>
<script>
  (function () {
    var d = '${curDate}'.split('.');
    if (d.length == 3) document.getElementById('date_iso').value = d[2] + '-' + d[1] + '-' + d[0];
  })();
  function openRep(idx) {
    var dep = $('#dep_id').val();
    var v = $('#date_iso').val().split('-');
    if (dep == null) {
      errMsg('Отделение не выбрано');
      return;
    }
    var date = v.length == 3 ? v[2] + '.' + v[1] + '.' + v[0] : '${curDate}';
    window.open('/head_nurse/print.s?stat=' + idx + '&dep=' + dep + '&date=' + date);
  }
</script>
