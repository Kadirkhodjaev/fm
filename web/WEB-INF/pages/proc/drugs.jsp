<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script>
  function setIterator(type, pm) {
    let cur = Number($('#' + type).val());
    if(cur === 0 && pm < 0) return;
    $('#' + type).val(cur + pm);
    $.ajax({
      url: '/proc/patient/drug/exp.s',
      method: 'post',
      data: 'patient=${pat.id}&time=${time}&oper_day=${oper_day}&code=' + type + '&val=' + (cur + pm),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  function setDrugState(id) {
    $.ajax({
      url: '/proc/patient/drug/done.s',
      method: 'post',
      data: 'id=' + id + '&time=${time}',
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          $('#home').load('/proc/patient/drugs.s?id=${pat.id}&oper_day=' + $('#oper_day').val());
        }
      }
    });
  }
</script>
<c:if test="${fn:length(ines) > 0}">
  <p style="width:95%; margin: auto; text-align: center;padding: 5px">
    &nbsp;&nbsp;<b>Год рождения:</b> ${pat.birthyear}
  </p>
  <table style="margin: auto; border-spacing:0; border-collapse:collapse; font-size: 13px;width:100%">
    <tr>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:25px">№</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Наимнеование</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">${oper_day}</td>
    </tr>
    <tr><td colspan="3" style="font-weight:bold;padding:5px;border:1px solid #ababab">Инъекции</td></tr>
    <c:forEach items="${ines}" var="drug" varStatus="loop">
      <tr class="hover">
        <td style="border:1px solid #ababab;text-align:center">${loop.index + 1}</td>
        <td style="border:1px solid #ababab">
          <b>
            <c:forEach items="${drug.rows}" var="row" varStatus="loop">
              <c:if test="${row.source == 'own'}">
                <u>${row.name}</u>
              </c:if>
              <c:if test="${row.source != 'own'}">
                ${row.name}
              </c:if>
              <c:if test="${loop.index + 1 < fn:length(drug.rows)}"> + </c:if>
            </c:forEach>
          </b> (${drug.note})<c:if test="${drug.injectionType != null}"> - ${drug.injectionType.name}</c:if>
        </td>
        <td style="border:1px solid #ababab; text-align: center; padding:2px" nowrap>
          <c:if test="${!drug.timeDone}">
            <button class="btn btn-success btn-sm" onclick="setDrugState(${drug.dateId})"><b class="fa fa-check"></b></button>
          </c:if>
          <c:if test="${drug.timeDone}">
            <div>${drug.timeDoneBy}</div>
            <div><fmt:formatDate pattern = "HH:mm" value = "${drug.timeDoneOn}"/></div>
          </c:if>
        </td>
      </tr>
    </c:forEach>
    <tr class="hover">
      <td style="border:1px solid #ababab;padding: 4px" colspan="2">Спирт 70%</td>
      <td style="border:1px solid #ababab; padding:10px 0">
        <table style="width:100px; margin:auto">
          <tr>
            <td><button style="width:35px" onclick="setIterator('spirt', -0.5)">-</button></td>
            <td><input style="width:30px" type="text" class="center" readonly value="${exps.get("spirt") == null ? 0 : exps.get("spirt")}" id="spirt"/></td>
            <td><button style="width:35px" onclick="setIterator('spirt', 0.5)">+</button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="hover">
      <td style="border:1px solid #ababab;padding: 4px" colspan="2">Вата</td>
      <td style="border:1px solid #ababab; padding:10px 0">
        <table style="width:100px; margin:auto">
          <tr>
            <td><button style="width:35px" onclick="setIterator('vata', -0.5)">-</button></td>
            <td><input style="width:30px" type="text" class="center" readonly value="${exps.get("vata") == null ? 0 : exps.get("vata")}" id="vata"/></td>
            <td><button style="width:35px" onclick="setIterator('vata', 0.5)">+</button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="hover">
      <td style="border:1px solid #ababab;padding: 4px" colspan="2">Шприц</td>
      <td style="border:1px solid #ababab; padding:10px 0">
        <table style="width:100px; margin:auto">
          <tr>
            <td><button style="width:35px" onclick="setIterator('spric', -0.5)">-</button></td>
            <td><input style="width:30px" type="text" class="center" readonly value="${exps.get("spric") == null ? 0 : exps.get("spric")}" id="spric"/></td>
            <td><button style="width:35px" onclick="setIterator('spric', 0.5)">+</button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="hover">
      <td style="border:1px solid #ababab;padding: 4px" colspan="2">Система</td>
      <td style="border:1px solid #ababab; padding:10px 0">
        <table style="width:100px; margin:auto">
          <tr>
            <td><button style="width:35px" onclick="setIterator('sistema', -0.5)">-</button></td>
            <td><input style="width:30px" type="text" class="center" readonly value="${exps.get("sistema") == null ? 0 : exps.get("sistema")}" id="sistema"/></td>
            <td><button style="width:35px" onclick="setIterator('sistema', 0.5)">+</button></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="hover">
      <td style="border:1px solid #ababab;padding: 4px" colspan="2">Перчатка</td>
      <td style="border:1px solid #ababab; padding:10px 0">
        <table style="width:100px; margin:auto">
          <tr>
            <td><button style="width:35px" onclick="setIterator('perchatka', -0.5)">-</button></td>
            <td><input style="width:30px" type="text" class="center" readonly value="${exps.get("perchatka") == null ? 0 : exps.get("perchatka")}" id="perchatka"/></td>
            <td><button style="width:35px" onclick="setIterator('perchatka', 0.5)">+</button></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</c:if>
<c:if test="${fn:length(ines) == 0}">
  <div style="text-align: center; margin-top:50px; margin-bottom: 50px">
    <h4 class="text-danger" style="margin:auto">Нет данных по инъекциям</h4>
  </div>
</c:if>
<div style="height:20px"></div>
<c:if test="${fn:length(tabs) > 0}">
  <table style="width:100%; margin: auto; border-spacing:0; border-collapse:collapse; font-size: 13px">
    <tr>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:25px">№</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Наименование</td>
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">${oper_day}</td>
    </tr>
    <tr><td colspan="3" style="font-weight:bold;padding:5px;border:1px solid #ababab">Таблетки</td></tr>
    <c:forEach items="${tabs}" var="drug" varStatus="loop">
      <tr>
        <td style="border:1px solid #ababab;text-align:center;width:25px">${loop.index + 1}</td>
        <td style="border:1px solid #ababab">
          <b>
            <c:forEach items="${drug.rows}" var="row" varStatus="loop">
              <c:if test="${row.source == 'own'}">
                <u>${row.name}</u>
              </c:if>
              <c:if test="${row.source != 'own'}">
                ${row.name}
              </c:if>
              <c:if test="${loop.index + 1 < fn:length(drug.rows)}"> + </c:if>
            </c:forEach>
          </b> (${drug.note})
        </td>
        <td style="border:1px solid #ababab; vertical-align:middle; text-align:center">+</td>
      </tr>
    </c:forEach>
  </table>
</c:if>
