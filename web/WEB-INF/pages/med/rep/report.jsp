<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function getWord() {
    let b = document.getElementById('form_word');
    let form = document.createElement('form');
    form.method = 'post';
    form.action = '/rep/run.s';
    form.target = 'frm';
    let i1 = document.createElement('input');
    i1.name = 'print';
    i1.value = 'Y';
    form.append(i1);
    let i2 = document.createElement('input');
    i2.name = 'word';
    i2.value = 'Y';
    form.append(i2);
    let i3 = document.createElement('input');
    i3.name = 'period_start';
    i3.value = '<%=request.getParameter("period_start")%>';
    form.append(i3);
    let i4 = document.createElement('input');
    i4.name = 'period_end';
    i4.value = '<%=request.getParameter("period_end")%>';
    form.append(i4);
    let i5 = document.createElement('input');
    i5.name = 'repId';
    i5.value = '<%=request.getParameter("repId")%>';
    form.append(i5);
    let i6 = document.createElement('input');
    i6.name = 'cat';
    i6.value = '<%=request.getParameter("cat")%>';
    form.append(i6);
    b.append(form);
    form.submit();
  }
  $(document).ready(function(){
    $('#printFontSize').val(${sessionScope.fontSize});
  });
  function repPrint() {
    window.print()
  }
</script>
<style>
  @media print {.banner {display: none;}}
</style>
<iframe name="frm" class="hidden"></iframe>
<div id="form_word" class="hidden"></div>
<div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px;">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; color: #337ab7">${patFio}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px; float:right">
          <li class="paginate_button" tabindex="0"><a href="#" onclick="repPrint()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="getWord()"><i title="Word" class="fa fa-wordpress"></i> Word</a></li>
          <li class="paginate_button" tabindex="0"><a href="#" onclick="self.close()"><i title="Закрыть" class="fa fa-close"></i> Закрыть</a></li>
        </ul>
      </td>
    </tr>
  </table>
</div>
