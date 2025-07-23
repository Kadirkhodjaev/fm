<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="col-lg-12">
  <h1 class="page-header" style="color: #337ab7">Роли</h1>
</div>
<style>
  .truncate {
    white-space: nowrap; /* Текст не переносится */
    overflow: hidden; /* Обрезаем всё за пределами блока */
    text-overflow: ellipsis; /* Добавляем многоточие */
  }
</style>
<div class="clearboth"></div>
<div class="row" style="margin-right:50px; margin-left:50px">
  <c:forEach items="${roles}" var="r" varStatus="loop">
    <div class="col-6 col-sm-6 col-md-6 col-xs-6 col-lg-2" style="padding-right:0;padding-left:0">
      <a onclick="setLocation('/setRole.s?id=' + ${r.id}); return false;" href="#">
        <div class="col-lg-11" style="padding-right:0;padding-left:0">
          <div class="${r.color}">
            <div class="panel-heading">
              <div class="row">
                <div class="center">
                  <i class="${r.icon} fa-5x"></i>
                </div>
              </div>
            </div>
            <div class="panel-footer">
              <div class="pull-left truncate w-100">${r.name}</div>
              <div class="clearfix"></div>
            </div>
          </div>
        </div>
      </a>
    </div>
  </c:forEach>
</div>
