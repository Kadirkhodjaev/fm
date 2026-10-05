<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .ep { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width:900px; margin:0 auto; padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ep * { box-sizing:border-box; }
  .ep-title { display:flex; align-items:baseline; gap:14px; flex-wrap:wrap; margin-bottom:12px; }
  .ep-title h2 { margin:0; font-size:19px; font-weight:700; }
  .ep-title .who { color:var(--muted); font-size:13.5px; }
  .ep-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; margin-bottom:14px; }
  .ep-card h3 { margin:0; padding:12px 18px; font-size:14px; font-weight:700; background:#FAFBFC; border-bottom:1px solid var(--border); }
  .ep-table { width:100%; border-collapse:collapse; }
  .ep-table th { padding:8px 14px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:left; background:#F8F9FA; border-bottom:1px solid var(--border); }
  .ep-table td { padding:10px 14px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .ep-table tr:last-child td { border-bottom:0; }
  .ep-table .per { white-space:nowrap; font-weight:600; }
  .ep-table .arrow { color:#9AA1AC; margin:0 6px; }
  .ep-empty { padding:20px 18px; color:var(--muted); text-align:center; }
  .ep-form { padding:16px 18px 18px; display:grid; grid-template-columns:repeat(6, 1fr); gap:14px; align-items:end; }
  .ep-form .fg label { display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:5px; }
  .ep-form .fg .form-control { height:38px; }
  .ep-form .ro { height:38px; line-height:38px; padding:0 10px; background:#F8F9FA; border:1px solid var(--border); border-radius:9px; font-weight:600; text-align:center; }
  .ep-form .c2 { grid-column:span 2; }
  @media (max-width:760px) { .ep-form { grid-template-columns:1fr 1fr; } .ep-form .c2 { grid-column:span 2; } }
</style>
<f:form commandName="epic" method="post">
  <div class="ep">
    <div class="ep-title">
      <h2>Перевод</h2>
      <span class="who"><b>${patient.surname}&nbsp;${patient.name}&nbsp;${patient.middlename}</b> &nbsp;·&nbsp; Год рождения: ${patient.birthyear}</span>
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>

    <div class="ep-card">
      <h3>История переводов</h3>
      <c:choose>
        <c:when test="${empty epics}">
          <div class="ep-empty">Переводов пока не было</div>
        </c:when>
        <c:otherwise>
          <table class="ep-table">
            <tr>
              <th>Период</th>
              <th>Отделение</th>
              <th>Палата</th>
              <th>Лечащий врач</th>
            </tr>
            <c:forEach items="${epics}" var="e">
              <tr>
                <td class="per">${e.c1}<span class="arrow">&rarr;</span>${e.c2}</td>
                <td>${e.c3}</td>
                <td>${e.c4}</td>
                <td>${e.c5}</td>
              </tr>
            </c:forEach>
          </table>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="ep-card">
      <h3>Новый перевод</h3>
      <div class="ep-form">
        <div class="fg">
          <label>Период: с</label>
          <div class="ro"><input type="hidden" name="Date_Begin" value="${startDate}"/>${startDate}</div>
        </div>
        <div class="fg">
          <label for="Date_End">по</label>
          <input type="text" id="Date_End" name="Date_End" class="form-control fms-cal" autocomplete="off" value="${sysDate}"/>
        </div>
        <div class="fg c2">
          <label for="epic_dept">Отделение</label>
          <select name="deptId" class="form-control" id="epic_dept" onchange="setDept()">
            <c:forEach items="${deps}" var="d">
              <option value="${d.id}" <c:if test="${d.id == epic.deptId}">selected</c:if>>${d.name}</option>
            </c:forEach>
          </select>
        </div>
        <div class="fg">
          <label for="epic_room">Палата</label>
          <select class="form-control" name="room_id" id="epic_room"></select>
        </div>
        <div class="fg" style="grid-column:1 / -1">
          <label for="epic_lv">Лечащий врач</label>
          <select name="lvId" class="form-control" id="epic_lv">
            <c:forEach items="${lvs}" var="d">
              <option value="${d.id}" <c:if test="${d.id == epic.lvId}">selected</c:if>>${d.fio}</option>
            </c:forEach>
          </select>
        </div>
      </div>
    </div>
    <div style="text-align: right">
      <button class="hidden" type="submit" id="saveBtn">Сохранить</button>
    </div>
  </div>
</f:form>
<script>
  let rooms = [];
  <c:forEach items="${rooms}" var="room">
  rooms.push({value: ${room.id}, name: '${room.name} ${room.floor.name} ${room.roomType.name}', dep: ${room.dept.id}});
  </c:forEach>
  function setDept() {
    let dept = $('#epic_dept').val();
    $('#epic_room').html('');
    rooms.forEach((dom) => {
      if(dept == dom.dep)
        $('#epic_room').append($('<option value="' + dom.value + '">' + dom.name + '</option>'));
    });
  }
  $(function() {
    setDept();
    $('#epic_room').val('${epic.room.id}');
  });
</script>
