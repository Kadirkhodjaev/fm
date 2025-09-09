<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
  .autocomplete {
    position: relative;
  }
  .autocomplete-items {
    position: absolute;
    border: 1px solid #d4d4d4;
    z-index: 99;
  }
  .autocomplete-items div {
    padding: 5px;
    cursor: pointer;
    background-color: #fff;
    border-bottom: 1px solid #d4d4d4;
  }
  /*when hovering an item:*/
  .autocomplete-items div:hover {
    background-color: #e9e9e9;
  }
  /*when navigating through the items using the arrow keys:*/
  .autocomplete-active {
    background-color: DodgerBlue !important;
    color: #ffffff;
  }
</style>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Реквизиты пациента
    <button  class="btn btn-sm" onclick="setPage('/head_nurse/patients.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <c:if test="${obj.state == 'E'}">
      <button  class="btn btn-sm btn-info" onclick="confirmPatient()" style="float:right;margin-top:-5px; margin-left:5px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
    <c:if test="${obj.state == 'E'}">
      <button  class="btn btn-sm btn-success" onclick="savePatient()" style="float:right;margin-top:-5px"><i class="fa fa-save"></i> Сохранить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" id="row_id" value="${obj.id}">
      <input type="hidden" name="patient_id" id="patient_id" value="${obj.patient.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle; width:150px">Пациент <i class="required">*</i>:</td>
          <td colspan="7">
            <input type="text" class="form-control" onkeyup="setSearch(this)" autocomplete="off" id="patient_fio" name="patient_fio" value="<c:if test="${obj.id>0}">${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</c:if>" style="font-size: 18px"/>
          </td>
        </tr>
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Год рождения: </td>
          <td><input type="text" disabled id="birth_year" class="form-control center" value="${obj.patient.birthyear}"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дата поступления: </td>
          <td><input type="text" disabled id="start_date" class="form-control center" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateBegin}" />"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дата выписки: </td>
          <td><input type="text" disabled id="end_date" class="form-control center" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateEnd}" />"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Палата: </td>
          <td><input type="text" disabled id="palata" class="form-control center" value="${obj.patient.room.name}"></td>
        </tr>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>
<c:if test="${obj.id > 0 && obj.closed != 'Y'}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Новая запись
    </div>
    <div class="panel-body">
      <form id="addEditFormRow" style="padding:5px">
        <input type="hidden" name="parent" value="${obj.id}"/>
        <table class="table table-bordered" style="width:100%; margin:auto">
          <tr>
            <td align="right">Препарат: </td>
            <td>
              <select class="form-control chzn-select" required name="drug" onchange="setPatientDrug(this)">
                <option value=""></option>
                <c:forEach items="${drugs}" var="cc">
                  <option value="${cc.id}">${cc.name}</option>
                </c:forEach>
              </select>
            </td>
            <td align="right">Количественный учет: </td>
            <td style="width:200px">
              <select class="form-control" name="counter" disabled id="drug_counter"></select>
            </td>
            <td align="right">Списание: </td>
            <td style="width:100px"><input type="number" id="drug_count" name="drug_count" disabled class="form-control center"></td>
          </tr>
        </table>
      </form>
      <div style="text-align:center; padding-top:10px; margin-top:10px; border-top:1px solid #ababab">
        <button  class="btn btn-sm btn-success" onclick="saveDrugRow()"><i class="fa fa-save"></i> Сохранить</button>
      </div>
    </div>
    <!-- /.panel-body -->
  </div>
</c:if>
<c:if test="${fn:length(rows) > 0}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Записи
    </div>
    <div class="panel-body">
      <table class="table miniGrid">
        <thead>
        <tr>
          <th>Наименование</th>
          <th>Количественный учет</th>
          <th>Количество</th>
          <c:if test="${obj.closed != 'Y'}">
            <th>Удалить</th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="row" varStatus="loop">
          <tr>
            <td>${row.drug.name}</td>
            <td class="center" style="width:200px">${row.serviceCount} ${row.drug.measure.name}</td>
            <td style="width:150px; text-align:center"><fmt:formatNumber value = "${row.serviceCount}" type = "number"/></td>
            <c:if test="${obj.closed != 'Y'}">
              <td style="width:30px;text-align: center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${row.id})"><span class="fa fa-minus"></span></button>
              </td>
            </c:if>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.panel-body -->
  </div>
</c:if>
<script>
  function savePatient() {
    if($('#patient_id').val() == '') {
      alert('Пациент не выбран');
      return;
    }
    $.ajax({
      url: '/head_nurse/patient/save.s',
      data: 'id=' + $('#row_id').val() + '&patient=' + $('#patient_id').val(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          parent.setPage('/head_nurse/patient/info.s?id=' + res.id);
        } else
          alert(res.msg);
      }
    });
  }

  function setSearch(dom) {
    if(dom.value.length > 3) {
      $.ajax({
        url: '/head_nurse/patient/filter.s',
        data: 'fio=' + dom.value,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            patientAutoComplete(document.getElementById('patient_fio'), res.patients);
          } else
            alert(res.msg);
        }
      });
    }
    if(dom.value == null || dom.value == '') {
      $('#patient_id').val('');
      $('#birth_year').val('');
      $('#start_date').val('');
      $('#end_date').val('');
      $('#palata').val('');
    }
  }

  function patientAutoComplete(inp, arr) {
    /*the autocomplete function takes two arguments,
    the text field element and an array of possible autocompleted values:*/
    var currentFocus;
    /*execute a function when someone writes in the text field:*/
    inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      //a.style.left = inp.getBoundingClientRect().left + "px";
      a.style.width = (inp.getBoundingClientRect().right - inp.getBoundingClientRect().left) + 'px';
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*create a DIV element for each matching element:*/
        b = document.createElement("DIV");
        /*make the matching letters bold:*/
        b.innerHTML = "<strong>" + arr[i].fio.substr(0, val.length) + "</strong>";
        b.innerHTML += arr[i].fio.substr(val.length);
        b.innerHTML += " (Поступления: " + arr[i].start_date + " Выписка: " + arr[i].end_date + " Год рождения: " + arr[i].birth_year + " Палата: " + arr[i].palata + ")";
        /*insert a input field that will hold the current array item's value:*/
        $(b).data('item', arr[i]);
        /*execute a function when someone clicks on the item value (DIV element):*/
        b.addEventListener("click", function(e) {
          /*insert the value for the autocomplete text field:*/
          inp.value = $(this).data('item').fio;
          $('#patient_id').val($(this).data('item').id);
          $('#birth_year').val($(this).data('item').birth_year);
          $('#start_date').val($(this).data('item').start_date);
          $('#end_date').val($(this).data('item').end_date);
          $('#palata').val($(this).data('item').palata);
          /*close the list of autocompleted values,
          (or any other open lists of autocompleted values:*/
          closeAllLists();
        });
        a.appendChild(b);
      }
    });
    /*execute a function presses a key on the keyboard:*/
    inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
    });
    function addActive(x) {
      /*a function to classify an item as "active":*/
      if (!x) return false;
      /*start by removing the "active" class on all items:*/
      removeActive(x);
      if (currentFocus >= x.length) currentFocus = 0;
      if (currentFocus < 0) currentFocus = (x.length - 1);
      /*add class "autocomplete-active":*/
      x[currentFocus].classList.add("autocomplete-active");
    }
    function removeActive(x) {
      /*a function to remove the "active" class from all autocomplete items:*/
      for (var i = 0; i < x.length; i++) {
        x[i].classList.remove("autocomplete-active");
      }
    }
    function closeAllLists(elmnt) {
      /*close all autocomplete lists in the document,
      except the one passed as an argument:*/
      var x = document.getElementsByClassName("autocomplete-items");
      for (var i = 0; i < x.length; i++) {
        if (elmnt != x[i] && elmnt != inp) {
          x[i].parentNode.removeChild(x[i]);
        }
      }
    }
    /*execute a function when someone clicks in the document:*/
    document.addEventListener("click", function (e) {
      closeAllLists(e.target);
    });
  }

  function saveDrugRow() {
    if(parseFloat($('#drug_count').val()) > 0) {
      $.ajax({
        url: '/head_nurse/patient/drug/save.s',
        method: 'post',
        data: $('#addEditFormRow').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/patient/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    } else {
      alert('Поле "Расход" не заполнено или имеет не правильный формат данных');
    }
  }

  function delDrugRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/patient/drug/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/head_nurse/patient/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }

  function setPatientDrug(dom) {
    $('#drug_count').attr('disabled', dom.value === '');
    //
    $('#drug_counter').attr('disabled', dom.value === '').html('');
  }

  function confirmPatient() {
    if(confirm('Дейтвительно хотите подтвердить?')) {
      $.ajax({
        url: '/head_nurse/patient/confirm.s',
        data: 'id=${obj.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/head_nurse/patient/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  //
  $(function() {
    $(".chzn-select").chosen();
  });
</script>
