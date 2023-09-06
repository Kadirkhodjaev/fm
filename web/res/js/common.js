$(document).ready(function(){
  $('printButton').html("<button title='ѕечать' type='button' onclick='printPage()' class='btn btn-outline btn-primary print-button'><i class='fa fa-print'></i></button>");
});

// возвращает cookie с именем name, если есть, если нет, то undefined
function getCookie(name) {
  var matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}

function setLocation(url){
  document.location = url;
}

// устанавливает cookie c именем name и значением value
// options - объект с свойствами cookie (expires, path, domain, secure)
function setCookie(name, value, options) {
  options = options || {};
  var expires = options.expires;
  if (typeof expires == "number" && expires) {
    var d = new Date();
    d.setTime(d.getTime() + expires * 1000);
    expires = options.expires = d;
  }
  if (expires && expires.toUTCString)
    options.expires = expires.toUTCString();
  value = encodeURIComponent(value);
  var updatedCookie = name + "=" + value;
  for(var propName in options) {
    updatedCookie += "; " + propName;
    var propValue = options[propName];
    if (propValue !== true)
      updatedCookie += "=" + propValue;
  }
  document.cookie = updatedCookie;
}

// удал€ет cookie с именем name
function deleteCookie(name) {
  setCookie(name, "", { expires: -1 })
}

function checkForm(form) {
  var isOk = true;
  form.find('input').each(function () {
    if ($(this).attr('required') && $(this).val() == '') {
      $(this).focus();
      $(this).css('border', '1px solid red').focus(function () {
        $(this).css('border', '1px solid #ccc');
      });
      isOk = false;
    }
  })
  form.find('select').each(function () {
    if ($(this).attr('required') && ($(this).val() == '' || $(this).val() == null)) {
      $(this).focus();
      $(this).css('border', '1px solid red').focus(function () {
        $(this).css('border', '1px solid #ccc');
      });
      isOk = false;
    }
  })
  return isOk;
}

function saveTemplate(field, fieldId) {
  if (confirm('¬ы действительно хотите сохранить значени€ данного пол€ как шаблон')) {
    var name = prompt('Ќаименование шаблона');
    if (name != '') {
      $.ajax({
        url: '/templates/lv/save.s',
        data: 'field=' + field + '&name=' + name + '&template=' + encodeURIComponent(nicEditors.findEditor(fieldId).getContent()),
        method: 'post',
        dataType: 'json',
        success: function (res) {
          alert(res.msg);
        }
      });
    }
  }
}

function getTemplate(field, id) {
  var res = window.open('/templates/lv/get.s?field=' + field + '&id=' + id);
}

function autocomplete(inp, arr) {
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
    a.setAttribute("id", this.id + "autocomplete-list");
    a.setAttribute("class", "autocomplete-items");
    /*append the DIV element as a child of the autocomplete container:*/
    this.parentNode.appendChild(a);
    /*for each item in the array...*/
    for (i = 0; i < arr.length; i++) {
      /*check if the item starts with the same letters as the text field value:*/
      if (arr[i].label.substr(0, val.length).toUpperCase() == val.toUpperCase()) {
        /*create a DIV element for each matching element:*/
        b = document.createElement("DIV");
        /*make the matching letters bold:*/
        b.innerHTML = "<strong>" + arr[i].label.substr(0, val.length) + "</strong>";
        b.innerHTML += arr[i].label.substr(val.length);
        /*insert a input field that will hold the current array item's value:*/
        $(b).data('item', arr[i]);
        /*execute a function when someone clicks on the item value (DIV element):*/
        b.addEventListener("click", function(e) {
          /*insert the value for the autocomplete text field:*/
          inp.value = $(this).data('item').name;
          $(inp).parent().parent().find('select[name=goal]').val($(this).data('item').goal).trigger('liszt:updated');
          $(inp).parent().parent().find('select[name=cat]').val($(this).data('item').cat);
          $(inp).parent().parent().find('input[name=note]').val($(this).data('item').doza);
          /*close the list of autocompleted values,
          (or any other open lists of autocompleted values:*/
          closeAllLists();
        });
        a.appendChild(b);
      }
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

function saveDrugTemplate(id){
  var name = $('#drugTr' + id + ' input[name=drugName]').val();
  var goal = $('#drugTr' + id + ' select[name=goal]').val();
  var cat = $('#drugTr' + id + ' select[name=cat]').val();
  var doza = $('#drugTr' + id + ' input[name=note]').val();
  if (confirm('¬ы действительно хотите сохранить значени€ данного пол€ как шаблон')) {
    $.ajax({
      url: '/templates/lv/drug/save.s',
      data: 'name=' + encodeURIComponent(name) + '&cat=' + cat + '&goal=' + goal + '&doza=' + encodeURIComponent(doza),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        alert(res.msg);
      }
    });
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
function closeMedMsg() {
  $('.med-msg').slideUp(500);
}
function openMsg(res) {
  if(res.success) {
    openMedMsg("ƒанные успешно сохранены", true);
  } else {
    openMedMsg(res.msg, false);
  }
}
function openMedMsg(msg, isOk) {
  $('.med-msg').hide();
  if(isOk || isOk == null) {
    $('.med-msg').removeClass('error').slideDown(500).find('#med-msg-text').html(msg);
    setTimeout(() => {
      $('.med-msg').slideUp(1000);
    }, 8000)
  } else {
    $('.med-msg').addClass('error').slideDown(500).find('#med-msg-text').html(msg);
    setTimeout(() => {
      $('.med-msg').slideUp(1000);
    }, 10000);
  }
}

function errMsg(msg) {
  if($('.med-msg').length === 0) {
    $('body').append('<div class="med-msg" style="display: none"> ' +
      '      <table style="width:100%"> ' +
      '        <tr> ' +
      '          <td id="med-msg-text" style="overflow: hidden;color:white"></td> ' +
      '          <td style="width:35px;border-left: 1px solid #ababab; cursor: pointer;color:white" onClick="closeMedMsg()"> ' +
      '            <div class="close-msg" title="«акрыть">X</div> ' +
      '          </td> ' +
      '        </tr> ' +
      '      </table> ' +
      '    </div>');
  }
  $('.med-msg').hide();
  $('.med-msg').addClass('error').slideDown(500).find('#med-msg-text').html(msg);
  setTimeout(() => {
    $('.med-msg').slideUp(1000);
  }, 10000);
}
