<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:if test="${!print}">
  <tr>
    <td colspan="10" style="font-weight:bold; padding: 10px">Врач <div style="float:right">${conf_user_fio}</div></td>
  </tr>
</c:if>
</table>
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
          alert('Не заполнено поля Заключение');
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
    alert(e);
  }
  </c:if>
</script>
</body>
</html>