<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
  let services = [];
  <c:forEach items="${packs}" var="pack">
    <c:forEach items="${pack.list}" var="ser">
      services.push({id: ${ser.c1}, name:'${ser.c2}', price:'<fmt:formatNumber value = "${ser.price}" type = "number"/>', pack:${pack.id}});
    </c:forEach>
  </c:forEach>
  function savePack(id) {
    $.ajax({
      url: '/amb/pack.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success:function (res) {
        openMainPage('/amb/reg.s?id=${id}');
      }
    });
  }
  function addService(id, name) {
    $('#pack_name').html(name);
    $('#tservices').html('');
    for(let ser of services.filter(obj => obj.pack == id)) {
      let tr = $('<tr id="service_' + ser.id + '"></tr>');
      let td2 = $('<td>' + ser.name + '</td>');
      let td3 = $('<td class="right">' + ser.price + '</td>');
      tr.append(td2).append(td3);
      $('#tservices').append(tr);
    }
  }
</script>
<div class="panel panel-info" style="width: 100% !important; margin: auto">
  <div class="panel-heading">
    Список обследования
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="openMainPage('/amb/reg.s?id=${id}')"><i title="Сохранить" class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <table style="width:100%; height:100%">
    <tr>
      <td style="width:50%; border:1px solid #e8e8e8; vertical-align: top">
        <div>
          <table class="table table-bordered table-hover" style="width:100%">
            <tr>
              <td class="center bold">Наименование</td>
              <td class="center bold">Стоимость без скидки</td>
              <td class="center bold">Стоимость без скидки с НДС</td>
              <td class="center bold">Стоимость</td>
              <td class="center bold">Стоимость с НДС</td>
              <td style="width:40px" class="center bold">Добавить</td>
            </tr>
            <tbody id="tsers">
            <c:forEach items="${packs}" var="ser">
              <tr class="hover hand" onclick="addService(${ser.id}, '${ser.name}')">
                <td style="vertical-align: middle">${ser.name}</td>
                <td style="text-align:right;vertical-align: middle"><fmt:formatNumber value = "${ser.outCount}" type = "number"/></td>
                <td style="text-align:right;vertical-align: middle"><fmt:formatNumber value = "${ser.outCount * (100 + ser.drugCount) / 100}" type = "number"/></td>
                <td style="text-align:right;vertical-align: middle"><fmt:formatNumber value = "${ser.price}" type = "number"/></td>
                <td style="text-align:right;vertical-align: middle"><fmt:formatNumber value = "${ser.claimCount}" type = "number"/></td>
                <td class="center">
                  <button type="button" class="btn btn-sm btn-success btn-mini" onclick="savePack(${ser.id})">
                    <span class="fa fa-plus"></span>
                  </button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </td>
    </tr>
  </table>
</div>
