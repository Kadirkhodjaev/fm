<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
  <title><ui:message code="med"/> </title>
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
  <script src="/res/bs/jquery/jquery.min.js"></script>
  <script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
  <script src="/res/bs/jquery/jquery.js"></script>
</head>
<body>
<script>
  <c:if test="${debug}">
    $(document).ready(function(){
      $("input[name='login']").val('admin');
      $("input[name='password']").val('1');
    });
  </c:if>
</script>
<div class="container">
  <div class="row">
    <div class="col-md-4 col-md-offset-4">
      <div class="login-panel panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><ui:message code="auth"/></h3>
        </div>
        <div class="panel-body">
          <f:form role='form' method='POST' action='/login.s' commandName='loginForm' name='bufferForm'>
            <%@include file="/incs/msgs/errors.jsp"%>
            <fieldset>
              <div class="form-group">
                <f:input path='login' type='text' cssStyle="height: 34px; font-size:14px" class='form-control' placeholder='${login}' value='' autofocus="true" autocomplete="on"/>
              </div>
              <div class="form-group">
                <f:input path='password' type='password' cssStyle="height: 34px; font-size:14px" class='form-control' placeholder='${password}' value='' autofocus="true" autocomplete="on"/>
              </div>
              <div class="form-group" style="text-align: right">
                <a href="/downloadBrowser.s"><img src="/res/imgs/chrom.gif" style="width: 20px; height: 20px"/>Скачать браузер</a>
              </div>
              <button type="submit" class="btn btn-lg btn-success btn-block"><ui:message code="enter"/></button>
            </fieldset>
          </f:form>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  ;(function($){
    var F = $.fn.files = function(){
      F.open.apply(this, arguments);
    };

    $.extend(F, {

      block : null,
      form  : null,
      list  : null,
      files : [],

      setFiles : function(dom){
        var idx = F.files.length;
        $.each(dom[0].files, function(i, file){
          var data = {
            id : idx,
            name: file.name,
            title: file.title,
            size: file.size,
            type: file.type,
            format:  file.type ? file.type.split('/', 1).toString().toLowerCase() : '',
            extension: file.name.indexOf('.') != -1 ? file.name.split('.').pop().toLowerCase() : '',
            data: file.data || {},
            file: file,
            reader: {},
            id: Date.now(),
            input: null,
            html: null
          }, div = $('<div></div>');
          F.files[idx] = data;
          div.html(data.name).appendTo(F.list);
          $("<button type='button'>X</button>").bind('click.files', function(){F.remove(idx)}).appendTo(div);
          idx++;
        });
      },

      remove : function(id){
        F.files.remove(F.files.find(id));
      },

      find : function(id) {
        $.each(F.files, function(i, f) {
          if (f.id == id) {
            return f;
          }
        });
        return null;
      },

      submit : function(e){
        e.preventDefault();
        alert(F.files.length);
        var data = new FormData();
        $.each(F.files, function(i, f){
          data.append('files', f.file, f.name);
        });
        $.each(F.form.find('input'), function(i, c){
          if(c.type != 'file')
            data.append(c.name, c.value);
        });
        $.each(F.form.find('select'), function(i, c){
          data.append(c.name, c.value);
        });
        $.ajax({
          url: F.form.attr('action'),
          data: data,
          processData: false,
          contentType: false,
          cache : false,
          type: F.form.attr('method'),
          success: function (data) {
            // alert(data);
          }
        });
      },

      init : function(el){
        F.block = el;
        F.form = F.block.parent('form');
        $("<button>Добавить файл</button>").bind('click.files', function(){$('input[name=files]').click()}).attr('type', 'button').appendTo(F.block);
        F.list = $('<div></div>').attr('block', 'files').appendTo(F.block);
        F.block.css('width', '100%').css('border', '1px solid red');
        $('<input>').css('display', 'none').attr('type', 'file').attr('multiple', true).attr('name', 'files').bind('change.files', function(){F.setFiles($(this))}).appendTo(F.block);
        F.form.bind('submit.files', function(){F.submit(event)});
      }
    });
    $.fn.files = function(){
      F.init(this);
      return this;
    }
  }(jQuery));
  $(document).ready(function(){
    //$('#files').files();
  });
</script>
<form action="test.s" method="post">
  <div id="files"></div>
    <%--<input name="hello" type="text" value="SSS"/>
    <input type="submit" value="save"/>--%>
</form>
</body>
</html>