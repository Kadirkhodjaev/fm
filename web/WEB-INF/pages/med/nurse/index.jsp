<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<div>
  <div class="row" style="margin:20px 0 0 0;">
    <div class="col-md-12">
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-6">
              <i class="fa fa-twitter fa-fw"></i>
              Работа
            </div>
            <div class="col-md-6">
              <table style="float: right">
                <tr>
                  <td style="padding:0 10px">
                    <select id="dep_id" class="form-control" onchange="setPostFilter()" style="width:250px">
                      <c:forEach items="${depts}" var="dp">
                        <option <c:if test="${dp.id == dep}">selected</c:if> value="${dp.id}">${dp.name}</option>
                      </c:forEach>
                    </select>
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div>
        <div class="panel-body" id="panel_body" style="position:relative; overflow: auto; height:400px">
          <div class="list-group">
            <table class="table table-bordered">
              <tr>
                <td class="center bold">№</td>
                <td class="center bold">Пациент</td>
                <c:forEach items="${types}" var="key">
                  <c:if test="${is1 && key.id == 1}"><td class="center bold" nowrap>Лаборатория</td></c:if>
                  <c:if test="${is3 && key.id == 3}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is4 && key.id == 4}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is6 && key.id == 6}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is10 && key.id == 10}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is11 && key.id == 11}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is12 && key.id == 12}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is13 && key.id == 13}"><td class="center bold" nowrap>${key.name}</td></c:if>
                  <c:if test="${is14 && key.id == 14}"><td class="center bold" nowrap>${key.name}</td></c:if>
                </c:forEach>
                <c:if test="${is15}">
                  <td class="center bold" nowrap>Консультация</td>
                </c:if>
                <c:if test="${is16}">
                  <td class="center bold" nowrap>Физиотерапия</td>
                </c:if>
              </tr>
              <c:forEach items="${rows}" var="rw" varStatus="loop">
                <tr title="${rw.c1} Год рож.: ${rw.c2} ИБ №: ${rw.c4} Дата рег.: ${rw.c3} Палата: ${rw.c30}" class="hover">
                  <td class="center" style="vertical-align: middle">${loop.index + 1}</td>
                  <td nowrap style="vertical-align: middle">
                    ${rw.c1}<br/>
                    <b>Год рож.:</b>${rw.c2} <b>ИБ №:</b>${rw.c4} <b>Дата рег.:</b>${rw.c3} <b>Палата:</b>${rw.c30}
                  </td>
                  <c:if test="${is1}"><td nowrap>${rw.c11}</td></c:if>
                  <c:if test="${is3}"><td nowrap>${rw.c13}</td></c:if>
                  <c:if test="${is4}"><td nowrap>${rw.c14}</td></c:if>
                  <c:if test="${is6}"><td nowrap>${rw.c16}</td></c:if>
                  <c:if test="${is10}"><td nowrap>${rw.c20}</td></c:if>
                  <c:if test="${is11}"><td nowrap>${rw.c21}</td></c:if>
                  <c:if test="${is12}"><td nowrap>${rw.c22}</td></c:if>
                  <c:if test="${is13}"><td nowrap>${rw.c23}</td></c:if>
                  <c:if test="${is14}"><td nowrap>${rw.c24}</td></c:if>
                  <c:if test="${is15}"><td nowrap>${rw.c25}</td></c:if>
                  <c:if test="${is16}"><td nowrap>${rw.c26}</td></c:if>
                </tr>
              </c:forEach>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  $(function(){
    $('#panel_body').width($(window).width() - 250).height($(window).height() - 180);
  });
  function setPostFilter() {
    setPage('/nurses/work.s?dep=' + $('#dep_id').val());
  }
</script>
