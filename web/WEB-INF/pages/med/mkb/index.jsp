<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>МКБ</title>
  <link rel="stylesheet" href="/res/jstree/theme/default/style.min.css" />
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .jstree-default a {
      white-space:normal !important; height: auto;
    }
    .jstree-anchor {
      height: auto !important;
    }
    .jstree-default li > ins {
      vertical-align:top;
    }
    .jstree-leaf {
      height: auto;
    }
    .jstree-leaf a{
      height: auto !important;
    }
  </style>
</head>
<body>
<table style="width:100%; height:100%">
  <tr>
    <td colspan="2" style="text-align:center; vertical-align: middle; font-weight:bold; font-size:20px;height:50px;">
      Международная классификация болезней
    </td>
  </tr>
  <tr>
    <td style="height:1px; vertical-align: bottom;padding:0 10px;" colspan="2">
      <div class="input-group" style="width:100%">
        <span class="input-group-addon"><span class="fa fa-th-list"></span></span>
        <input type="text" id="ricerca-enti" style="height:30px !important;" class="form-control" placeholder="Поиск по тексту" aria-describedby="search-addon">
        <span class="input-group-addon" id="search-addon"><span class="fa fa-search"></span></span>
      </div>
    </td>
  </tr>
  <tr>
    <td style="width:70%; max-width:70%; vertical-align:top; padding:0 10px; border-right:2px solid #e8e8e8">
      <div style="width:100%" id="container-albero">
        <div id="test"></div>
      </div>
    </td>
    <td style="width:30%;vertical-align:top; padding:10px">
      <div style="font-weight:bold;padding:5px;">
        Кодовые обозначение
      </div>
      <div id="node-code">

      </div>
      <div id="node-info" style="display: none;">
        <div id="node-info-label" style="font-weight:bold;padding:5px;">
          Информация:
        </div>
        <div id="node-info-text" style="text-align:justify">

        </div>
      </div>
    </td>
  </tr>
</table>

<script src="/res/bs/jquery/jquery.min.js"></script>
<script src="/res/jstree/jstree.min.js"></script>
<script>
  var to = false;
  $('#ricerca-enti').keyup(function() {
    if (to) {
      clearTimeout(to);
    }
    to = setTimeout(function() {
      var v = $('#ricerca-enti').val();
      if(v.length > 3) {
        $('#test').jstree(true).search(v);
      }
    }, 500);
  });
  $(document).ready(function() {
    $("#test").on("changed.jstree", function(e, data) {
      $('#node-info').toggle(data.node.original.info != undefined);
      $('#node-info-text').text(data.node.original.info == undefined ? '' : data.node.original.info);
      $('#node-code').text(data.node.original.code);
    }).jstree({
      plugins: ['search', 'changed'],
      search: {
        show_only_matches: true
      },
      core: {data: ${mkb}}
    });
    $("#test").on("dblclick.jstree", function (event) {
      var node = $(event.target).closest("li");
      if (node.find('li').length == 0) {
        window.opener.setMkb(node[0].innerText, node.attr('id').replace('padre', ''));
        self.close();
      }
    });
  });
</script>
</body>
</html>
