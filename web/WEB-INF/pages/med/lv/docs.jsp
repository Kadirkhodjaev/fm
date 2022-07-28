<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script>
  function setDocCheck(name) {
    var dom = document.getElementsByName(name)[0];
    dom.checked = !dom.checked;
    showHideDairy(dom);
  }
  function setDairyCheck(id) {
    var dom = document.getElementById('id' + id);
    dom.checked = !dom.checked;
  }
  function showHideDairy(dom) {
    if (dom.name == 'dairy')
      document.getElementById('dairies').style.display = !dom.checked ? 'none' : 'block';
    var list = document.getElementsByName('idx');
    for (var i=0;i<list.length;i++)
      list[i].checked = dom.checked;
  }
</script>
<style>
  .formTable td {padding:5px}
</style>
<div class="panel panel-info" style="width: 490px !important; margin: auto">
  <div class="panel-heading">Список документов</div>
  <table class="formTable hand" width="100%">
    <tr>
      <td class="center"><input type="checkbox" name="reg"></td>
      <td onclick="setDocCheck('reg')">Приемное отделение</td>
    </tr>
    <tr>
      <td class="center"><input type="checkbox" name="lv"></td>
      <td onclick="setDocCheck('lv')">Осмотр врача</td>
    </tr>
    <tr>
      <td class="center"><input type="checkbox" name="obos"></td>
      <td onclick="setDocCheck('obos')">Обоснование</td>
    </tr>
    <tr>
      <td class="center"><input type="checkbox" onchange="showHideDairy(this)" name="dairy"></td>
      <td onclick="setDocCheck('dairy')">Дневник</td>
    </tr>
    <tr>
      <td colspan="2" align="right">
        <div id="dairies" style="display: none">
          <table width="90%" class="formTable hand">
            <c:forEach items="${dairies}" var="d">
              <tr>
                <td class="center" width="40"><input id="id${d.id}" type="checkbox" name="idx" value="${d.id}"/></td>
                <td onclick="setDairyCheck('${d.id}')">${d.act_Date}</td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </td>
    </tr>
    <tr>
      <td class="center"><input type="checkbox" name="vyp"></td>
      <td onclick="setDocCheck('vyp')">Выписка</td>
    </tr>
    <tr>
      <td class="center"><input type="checkbox" name="dop"></td>
      <td onclick="setDocCheck('dop')">Дополнительные данные</td>
    </tr>
  </table>
</div>