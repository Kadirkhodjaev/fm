<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="page-wrapper" style="margin:0; border:0">
  <div class="row" style="margin:0">
    <div class="col-lg-12">
      <h2 class="page-header text-danger" style="margin:20px 0 10px;">
        <table style="width:100%">
          <tr>
            <td>Палаты отделений - ${dep_name}</td>
            <td>
              <select class="form-control" onchange="setPage('/proc/palatas.s?time=' + this.value)">
                <option <c:if test="${time==1}">selected</c:if> value="1">Утром</option>
                <option <c:if test="${time==2}">selected</c:if> value="2">Днем</option>
                <option <c:if test="${time==3}">selected</c:if> value="3">Вечером</option>
              </select>
            </td>
          </tr>
        </table>
      </h2>
    </div>
  </div>
  <div class="row" style="margin:0">
    <c:forEach items="${rooms}" var="r" varStatus="loop">
      <div class="col-lg-3" style="padding-left: 5px; padding-right: 5px">
        <a onclick="setPage('/proc/palata.s?id=${r.id}'); return false;" href="#">
          <div class="col-lg-12">
            <div class="panel panel-success">
              <div class="panel-heading">
                <div class="row">
                  <div class="center">
                    <c:forEach items="${r.list}" var="p">
                      <i class="fa ${p.c1} ${p.c2} fa-2x"></i>
                    </c:forEach>
                  </div>
                </div>
              </div>
              <div class="panel-footer">
                <span class="pull-left">${r.name}</span>
                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                <div class="clearfix"></div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </c:forEach>
  </div>
</div>
