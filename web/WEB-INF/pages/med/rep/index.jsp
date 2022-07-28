<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  $(document).ready(function(){
    <c:if test="${authErr}">
      parent.location = '/login.s';
    </c:if>
    $('.repList').click(function(){
      $.each($('.active'), function(idx, el){
        $(this).removeClass('active');
      });
      $(this).addClass('active');
      $('#repParams').load('/rep/params.s?id=' + $(this).attr('repId'));
    });
    $('.repList')[0].click();
  });
  <c:if test="${id > 0}">
    $.each($('tr.active'), function(idx, el){
      $(this).removeClass('active');
    });
    $('#repParams').load('/rep/params.s?id=${id}');
    $('#rep-${id}').addClass('active');
  </c:if>
</script>
<div style="border:1px solid #eee; width:29.5%; height: 100%; float:left; overflow: auto">
  <table class="table table-striped table-bordered table-hover dataTable hand">
    <thead>
      <tr style="font-weight: bold; background: #e8e8e8">
        <td align="center">№</td>
        <td align="center">Наименование отчета</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${repList}" var="r" varStatus="loop">
        <tr class="hover repList" id="rep-${r.id}" repId="${r.id}">
          <td class="center">${r.id}</td>
          <td>${r.name}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
<div id="repParams" style="border:1px solid #e8e8e8; width:70%; height: 100%; float:right; overflow: auto"></div>