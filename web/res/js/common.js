$(document).ready(function(){
  $('printButton').html("<button title='\u041f\u0435\u0447\u0430\u0442\u044c' type='button' onclick='printPage()' class='btn btn-outline btn-primary print-button'><i class='fa fa-print'></i></button>");
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

// удаляет cookie с именем name
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
  FmsConfirm('\u0412\u044b \u0434\u0435\u0439\u0441\u0442\u0432\u0438\u0442\u0435\u043b\u044c\u043d\u043e \u0445\u043e\u0442\u0438\u0442\u0435 \u0441\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u044f \u0434\u0430\u043d\u043d\u043e\u0433\u043e \u043f\u043e\u043b\u044f \u043a\u0430\u043a \u0448\u0430\u0431\u043b\u043e\u043d', function () {
    var name = prompt('\u041d\u0430\u0438\u043c\u0435\u043d\u043e\u0432\u0430\u043d\u0438\u0435 \u0448\u0430\u0431\u043b\u043e\u043d\u0430');
    if (name != '') {
      $.ajax({
        url: '/templates/lv/save.s',
        data: 'field=' + field + '&name=' + name + '&template=' + encodeURIComponent(getEditorHtml(fieldId)),
        method: 'post',
        dataType: 'json',
        success: function (res) {
          alert(res.msg);
        }
      });
    }
  });
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
  FmsConfirm('\u0412\u044b \u0434\u0435\u0439\u0441\u0442\u0432\u0438\u0442\u0435\u043b\u044c\u043d\u043e \u0445\u043e\u0442\u0438\u0442\u0435 \u0441\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u0437\u043d\u0430\u0447\u0435\u043d\u0438\u044f \u0434\u0430\u043d\u043d\u043e\u0433\u043e \u043f\u043e\u043b\u044f \u043a\u0430\u043a \u0448\u0430\u0431\u043b\u043e\u043d', function () {
    $.ajax({
      url: '/templates/lv/drug/save.s',
      data: 'name=' + encodeURIComponent(name) + '&cat=' + cat + '&goal=' + goal + '&doza=' + encodeURIComponent(doza),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        alert(res.msg);
      }
    });
  });
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
var medMsgTimer = null;
function closeMedMsg() {
  clearTimeout(medMsgTimer);
  $('.med-msg').stop(true, true).slideUp(500);
}
// creates the message box when the page has none; on pages without styles.css adds its styles,
// otherwise the box was unstyled and ended up at the very bottom of the page
function medMsgBox() {
  if($('.med-msg').length === 0) {
    $('body').append('<div class="med-msg" style="display: none"> ' +
      '      <table style="width:100%"> ' +
      '        <tr> ' +
      '          <td id="med-msg-text" style="overflow: hidden;color:white"></td> ' +
      '          <td style="width:35px;border-left: 1px solid #ababab; cursor: pointer;color:white" onClick="closeMedMsg()"> ' +
      '            <div class="close-msg" title="\u0417\u0430\u043a\u0440\u044b\u0442\u044c">X</div> ' +
      '          </td> ' +
      '        </tr> ' +
      '      </table> ' +
      '    </div>');
  }
  var box = $('.med-msg');
  if(box.css('position') === 'static' && !document.getElementById('medMsgCss')) {
    $('head').append('<style id="medMsgCss">' +
      '.med-msg{position:fixed;right:24px;bottom:24px;z-index:99999;min-width:320px;max-width:520px;font-weight:600;color:#1F2430;text-align:left;background:#fff;' +
      'border:1px solid #E6E8EC;border-left:4px solid #2E9E5B;border-radius:12px;box-shadow:0 16px 40px rgba(20,25,40,.16)}' +
      '.med-msg.error{border-left-color:#D7182E}.med-msg table tr td{padding:12px 14px}.med-msg #med-msg-text{color:#1F2430!important}' +
      '.med-msg.error #med-msg-text{color:#A50F22!important}.med-msg td+td{color:#6B7280!important;border-left:0!important}.med-msg .close-msg{cursor:pointer}' +
      '</style>');
  }
  return box;
}
function openMsg(res) {
  medMsgBox();
  if(res.success) {
    openMedMsg("\u0414\u0430\u043d\u043d\u044b\u0435 \u0443\u0441\u043f\u0435\u0448\u043d\u043e \u0441\u043e\u0445\u0440\u0430\u043d\u0435\u043d\u044b", true);
  } else {
    openMedMsg(res.msg, false);
  }
}
function openMedMsg(msg, isOk) {
  var ok = isOk || isOk == null;
  var box = medMsgBox();
  // an empty error used to show an empty box
  if(msg == null || String(msg).trim() === '' || msg === 'null')
    msg = ok ? "\u0413\u043e\u0442\u043e\u0432\u043e" : "\u041f\u0440\u043e\u0438\u0437\u043e\u0448\u043b\u0430 \u043e\u0448\u0438\u0431\u043a\u0430";
  clearTimeout(medMsgTimer);
  box.stop(true, true).hide();
  box.toggleClass('error', !ok).find('#med-msg-text').html(msg);
  box.slideDown(500);
  medMsgTimer = setTimeout(function () {
    box.stop(true, true).slideUp(1000);
  }, ok ? 8000 : 10000);
}
function errMsg(msg) {
  openMedMsg(msg, false);
}

function getDOM(id) {
  return document.getElementById(id);
}

function moPrintPage(id, param) {
  let form = $('<form action="/print/index.s" method="post" target="_blank"></form>');
  let idx = $('<input name="print_page_id" type="hidden" value="' + id + '"/>');
  let params = $('<input name="params" type="hidden" value="' + param + '"/>');
  form.append(idx).append(params);
  $('body').append(form);
  form.submit();
  form.remove();
}

// ---- rich text editor adapter: works with Quill (window.quills) and legacy nicEdit ----
window.quills = window.quills || {};
function getEditorHtml(id) {
  var q = window.quills[id];
  if (q) {
    var empty = q.getText().trim() === '' && !q.root.querySelector('img, table');
    return empty ? '' : q.getSemanticHTML().replace(/&nbsp;/g, ' ');
  }
  return nicEditors.findEditor(id).getContent();
}
function setEditorHtml(id, html) {
  var q = window.quills[id];
  if (q) {
    q.setContents(q.clipboard.convert({html: html}));
    return;
  }
  nicEditors.findEditor(id).setContent(html);
}
// show a message without a server response (creates the message box when it does not exist yet)
function showMsg(msg, isOk) {
  openMedMsg(msg, isOk);
}
// Uzbek phone number in registration fields, strict: only "998 XX XXX XXXX" (needed for the Telegram bot phone check).
// Works for every input named tel / cl_tel on pages that load common.js: letters and other symbols cannot be typed,
// the 998 prefix is kept, at most 9 digits after it.
function fmsPhoneFormat(v) {
  var d = (v || '').replace(/\D/g, '');
  var rest = d.indexOf('998') === 0 ? d.substring(3) : d;
  rest = rest.substring(0, 9);
  var parts = ['998', rest.substring(0, 2), rest.substring(2, 5), rest.substring(5, 9)];
  return parts.filter(function (p) { return p; }).join(' ');
}
function fmsPhoneValid(v) {
  return /^998 \d{2} \d{3} \d{4}$/.test(v || '');
}
if (window.jQuery) {
  jQuery(document)
    .on('focus', 'input[name=tel], input[name=cl_tel]', function () {
      this.setAttribute('inputmode', 'numeric');
      this.setAttribute('maxlength', '15');
      this.setAttribute('placeholder', '998 XX XXX XXXX');
      this.value = fmsPhoneFormat(this.value) + (this.value.replace(/\D/g, '').length <= 3 ? ' ' : '');
    })
    .on('keypress', 'input[name=tel], input[name=cl_tel]', function (e) {
      // digits only
      if (e.which && (e.which < 48 || e.which > 57) && e.which !== 8 && e.which !== 13) e.preventDefault();
    })
    .on('input', 'input[name=tel], input[name=cl_tel]', function () {
      var f = fmsPhoneFormat(this.value);
      if (f !== this.value.replace(/\s+$/, '')) this.value = f;
    })
    .on('blur', 'input[name=tel], input[name=cl_tel]', function () {
      var f = fmsPhoneFormat(this.value);
      this.value = f === '998' ? '' : f;
      this.style.borderColor = this.value && !fmsPhoneValid(this.value) ? '#D93848' : '';
      this.title = this.value && !fmsPhoneValid(this.value) ? '\u041d\u0435\u043f\u043e\u043b\u043d\u044b\u0439 \u043d\u043e\u043c\u0435\u0440: \u043d\u0443\u0436\u0435\u043d \u0444\u043e\u0440\u043c\u0430\u0442 998 XX XXX XXXX' : '';
    });
}

/*
 * Messages in the new style (as in nano): a dark notice in the bottom right corner.
 * FmsToast.show(text, 'ok' | 'err' | 'info'). openMsg / openMedMsg / errMsg use it, and success alerts
 * ("...uspeshno sokhraneny" etc.) become a notice instead of a blocking window; other alerts stay as they are.
 */
(function (window, document) {
  'use strict';
  // common.js is loaded again by some old pages: its function declarations above replace openMsg etc.,
  // so the new notice functions are installed again each time
  if (window.FmsToast) { window.FmsToast.install(); return; }
  var css =
    '#fms-toasts{position:fixed;right:20px;bottom:20px;z-index:20001;display:flex;flex-direction:column;gap:8px;align-items:flex-end;pointer-events:none}' +
    '.fms-toast{pointer-events:auto;display:flex;align-items:center;gap:10px;max-width:440px;padding:11px 14px;border-radius:12px;background:#1F2430;color:#fff;' +
    'font:500 13.5px/1.4 Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;box-shadow:0 12px 30px rgba(20,25,40,.28);transform:translateY(10px);opacity:0;transition:transform .2s,opacity .2s}' +
    '.fms-toast.on{transform:none;opacity:1}' +
    '.fms-toast .ic{flex:none;width:22px;height:22px;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700}' +
    '.fms-toast.ok .ic{background:#2E9E62}.fms-toast.err .ic{background:#D92D3C}.fms-toast.info .ic{background:#4B5563}' +
    '.fms-toast.err{background:#3A1D22}' +
    '.fms-toast .x{flex:none;margin-left:4px;opacity:.6;cursor:pointer;font-size:17px;line-height:1}.fms-toast .x:hover{opacity:1}' +
    '.med-msg{display:none!important}';
  var st = document.createElement('style');
  st.appendChild(document.createTextNode(css));
  (document.head || document.documentElement).appendChild(st);

  var box = null;
  function show(text, type) {
    if (!document.body) return;
    if (!box || !box.parentNode) { box = document.createElement('div'); box.id = 'fms-toasts'; document.body.appendChild(box); }
    type = type || 'ok';
    var el = document.createElement('div');
    el.className = 'fms-toast ' + type;
    el.setAttribute('role', type === 'err' ? 'alert' : 'status');
    var ic = document.createElement('span'); ic.className = 'ic'; ic.textContent = type === 'ok' ? '\u2713' : (type === 'err' ? '!' : 'i');
    var tx = document.createElement('span'); tx.textContent = String(text == null ? '' : text);
    var x = document.createElement('span'); x.className = 'x'; x.textContent = '\u00d7'; x.title = '\u0417\u0430\u043a\u0440\u044b\u0442\u044c';
    el.appendChild(ic); el.appendChild(tx); el.appendChild(x);
    box.appendChild(el);
    while (box.children.length > 4) box.removeChild(box.firstChild);
    setTimeout(function () { el.classList.add('on'); }, 10);
    var gone = function () { el.classList.remove('on'); setTimeout(function () { if (el.parentNode) el.parentNode.removeChild(el); }, 250); };
    x.onclick = gone;
    setTimeout(gone, type === 'err' ? 8000 : 3000);
  }
  function plain(msg) {
    var d = document.createElement('div');
    d.innerHTML = String(msg == null ? '' : msg);
    return (d.textContent || '').replace(/\s+/g, ' ').trim();
  }
  // the old functions keep their names: every page that calls them gets the new notice
  function install() {
  window.openMedMsg = function (msg, isOk) {
    var ok = isOk || isOk == null, t = plain(msg);
    if (!t || t === 'null') t = ok ? '\u0413\u043e\u0442\u043e\u0432\u043e' : '\u041f\u0440\u043e\u0438\u0437\u043e\u0448\u043b\u0430 \u043e\u0448\u0438\u0431\u043a\u0430';
    show(t, ok ? 'ok' : 'err');
  };
  window.openMsg = function (res) {
    res = res || {};
    window.openMedMsg(res.success ? '\u0414\u0430\u043d\u043d\u044b\u0435 \u0443\u0441\u043f\u0435\u0448\u043d\u043e \u0441\u043e\u0445\u0440\u0430\u043d\u0435\u043d\u044b' : res.msg, !!res.success);
  };
  window.errMsg = function (msg) { window.openMedMsg(msg, false); };
  }
  install();
  window.FmsToast = {show: show, install: install};

  // success alerts (uspeshno, sokhranen, udalen, dobavlen, podtverzhden) go to a notice
  var OK_RE = /(\u0443\u0441\u043f\u0435\u0448\u043d\u043e|\u0441\u043e\u0445\u0440\u0430\u043d\u0435\u043d|\u0443\u0434\u0430\u043b\u0435\u043d|\u0434\u043e\u0431\u0430\u0432\u043b\u0435\u043d|\u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d)/i;
  var BAD_RE = /(\u043e\u0448\u0438\u0431\u043a|\u043d\u0435\u043b\u044c\u0437\u044f|\u043d\u0435 \u0443\u0434\u0430\u043b|\u043d\u0435 \u0441\u043e\u0445\u0440\u0430\u043d|error|exception)/i;
  var nativeAlert = window.alert;
  window.alert = function (msg) {
    var s = String(msg == null ? '' : msg);
    if (s.length < 160 && OK_RE.test(s) && !BAD_RE.test(s)) { show(s, 'ok'); return; }
    return nativeAlert.call(window, msg);
  };
})(window, document);

/*
 * Double-click protection for every page: while a POST request is running,
 *  - the same request (same address and data) is not sent a second time;
 *  - the button or link that started it is disabled and dimmed until the answer comes.
 * Hooks XMLHttpRequest itself, so it works for every jQuery copy the old pages load.
 */
(function (window, document) {
  'use strict';
  if (window.FmsGuard) return;
  var st = document.createElement('style');
  st.appendChild(document.createTextNode('.fms-busy{opacity:.55!important;pointer-events:none!important;cursor:progress!important}'));
  (document.head || document.documentElement).appendChild(st);

  var last = null; // the control clicked most recently
  document.addEventListener('click', function (e) {
    var el = e.target && e.target.closest ? e.target.closest('button, a, input[type=button], input[type=submit], .fm-act, .fm-btn') : null;
    last = el ? {el: el, t: Date.now()} : null;
  }, true);

  var pending = {};
  var XO = window.XMLHttpRequest.prototype.open, XS = window.XMLHttpRequest.prototype.send;
  window.XMLHttpRequest.prototype.open = function (method, url) {
    this._fmsMethod = String(method || 'GET').toUpperCase();
    this._fmsUrl = String(url || '');
    return XO.apply(this, arguments);
  };
  window.XMLHttpRequest.prototype.send = function (body) {
    var xhr = this;
    if (xhr._fmsMethod !== 'POST') return XS.apply(xhr, arguments);
    var key = typeof body === 'string' || body == null ? xhr._fmsUrl + '|' + (body || '') : null;
    if (key && pending[key]) return; // the same request is already running: drop the repeat
    if (key) pending[key] = true;
    var el = last && Date.now() - last.t < 1500 ? last.el : null;
    if (el && !el.classList.contains('fms-busy')) el.classList.add('fms-busy'); else el = null;
    xhr.addEventListener('loadend', function () {
      if (key) delete pending[key];
      if (el) el.classList.remove('fms-busy');
    });
    return XS.apply(xhr, arguments);
  };
  window.FmsGuard = {pending: pending};
})(window, document);

/*
 * Loading indicator (as in nano): a thin bar at the top while any request is running longer than 250 ms,
 * and the page area dims while a page is loaded into it (setPage / menu). FmsLoad.page(true|false).
 */
(function (window, document) {
  'use strict';
  if (window.FmsLoad) return;
  var st = document.createElement('style');
  st.appendChild(document.createTextNode(
    '#fms-bar{position:fixed;left:0;top:0;height:3px;width:0;z-index:20000;background:#D7182E;box-shadow:0 0 8px rgba(215,24,46,.45);opacity:0;transition:width .4s ease,opacity .3s;pointer-events:none}' +
    '#fms-bar.on{opacity:1}' +
    'html.fms-wait,html.fms-wait *{cursor:progress!important}' +
    '#mainWindow.fms-loading{opacity:.5;transition:opacity .15s;pointer-events:none}'));
  (document.head || document.documentElement).appendChild(st);

  var bar = null, active = 0, timer = null, width = 0, grow = null;
  function barEl() {
    if (!bar || !bar.parentNode) { bar = document.createElement('div'); bar.id = 'fms-bar'; (document.body || document.documentElement).appendChild(bar); }
    return bar;
  }
  function start() {
    active++;
    if (active > 1 || timer) return;
    timer = setTimeout(function () {
      timer = null;
      if (!active) return;
      var b = barEl();
      width = 15; b.style.width = width + '%'; b.classList.add('on');
      document.documentElement.classList.add('fms-wait');
      grow = setInterval(function () { width = Math.min(90, width + (90 - width) * 0.12); b.style.width = width + '%'; }, 300);
    }, 250);
  }
  function stop() {
    active = Math.max(0, active - 1);
    if (active) return;
    if (timer) { clearTimeout(timer); timer = null; }
    if (grow) { clearInterval(grow); grow = null; }
    document.documentElement.classList.remove('fms-wait');
    if (bar && bar.classList.contains('on')) {
      bar.style.width = '100%';
      setTimeout(function () { if (!active && bar) { bar.classList.remove('on'); setTimeout(function () { if (!active && bar) bar.style.width = '0'; }, 300); } }, 200);
    }
  }
  var X = window.XMLHttpRequest.prototype, open = X.open, send = X.send;
  X.open = function (method, url, async) { this._fmsAsync = async !== false; return open.apply(this, arguments); };
  X.send = function () {
    if (this._fmsAsync) {
      var done = false;
      start();
      this.addEventListener('loadend', function () { if (!done) { done = true; stop(); } });
    }
    return send.apply(this, arguments);
  };
  // a dialog closed by loading a new page leaves its dark backdrop and body.modal-open behind
  function cleanModals() {
    if (document.querySelector('.modal.in')) return;
    var bs = document.querySelectorAll('.modal-backdrop');
    for (var i = 0; i < bs.length; i++) bs[i].parentNode.removeChild(bs[i]);
    document.body.classList.remove('modal-open');
    document.body.style.paddingRight = '';
  }
  function page(on) {
    var mw = document.getElementById('mainWindow');
    if (mw) mw.classList.toggle('fms-loading', !!on);
    if (!on) cleanModals();
  }
  window.FmsLoad = {page: page, start: start, stop: stop};
})(window, document);

/*
 * Network errors and an expired session for every request:
 *  - no connection -> notice "Net svyazi";
 *  - server error (5xx) -> asks /session/ping.s; no session -> "Sessiya istekla" window, otherwise an error notice;
 *  - a request that was redirected to the login page -> "Sessiya istekla" window.
 */
(function (window, document) {
  'use strict';
  if (window.FmsNet) return;
  var T = {
    net: '\u041d\u0435\u0442 \u0441\u0432\u044f\u0437\u0438 \u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u043e\u043c. \u041f\u0440\u043e\u0432\u0435\u0440\u044c\u0442\u0435 \u0441\u0435\u0442\u044c \u0438 \u043f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435.',
    srv: '\u041e\u0448\u0438\u0431\u043a\u0430 \u043d\u0430 \u0441\u0435\u0440\u0432\u0435\u0440\u0435 (\u043a\u043e\u0434 ',
    srv2: '). \u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u0435 \u0438\u043b\u0438 \u0441\u043e\u043e\u0431\u0449\u0438\u0442\u0435 \u0430\u0434\u043c\u0438\u043d\u0438\u0441\u0442\u0440\u0430\u0442\u043e\u0440\u0443.',
    expTitle: '\u0421\u0435\u0441\u0441\u0438\u044f \u0438\u0441\u0442\u0435\u043a\u043b\u0430',
    expText: '\u0412\u044b \u0434\u043e\u043b\u0433\u043e \u043d\u0435 \u0440\u0430\u0431\u043e\u0442\u0430\u043b\u0438 \u0432 \u0441\u0438\u0441\u0442\u0435\u043c\u0435 \u0438\u043b\u0438 \u0432\u043e\u0448\u043b\u0438 \u0441 \u0434\u0440\u0443\u0433\u043e\u0433\u043e \u043a\u043e\u043c\u043f\u044c\u044e\u0442\u0435\u0440\u0430. \u041f\u043e\u0441\u043b\u0435\u0434\u043d\u0435\u0435 \u0434\u0435\u0439\u0441\u0442\u0432\u0438\u0435 \u043d\u0435 \u0432\u044b\u043f\u043e\u043b\u043d\u0435\u043d\u043e. \u0412\u043e\u0439\u0434\u0438\u0442\u0435 \u0441\u043d\u043e\u0432\u0430.',
    expBtn: '\u0412\u043e\u0439\u0442\u0438 \u0441\u043d\u043e\u0432\u0430'
  };
  var lastNote = 0, expiredShown = false;
  function note(text) {
    var now = Date.now();
    if (now - lastNote < 4000) return; // one notice for a burst of failed requests
    lastNote = now;
    if (window.FmsToast) window.FmsToast.show(text, 'err');
  }
  function expired() {
    if (expiredShown) return;
    expiredShown = true;
    var o = document.createElement('div');
    o.setAttribute('style', 'position:fixed;inset:0;z-index:30000;display:flex;align-items:center;justify-content:center;background:rgba(20,25,40,.45);font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif');
    o.innerHTML = '<div style="width:420px;max-width:calc(100% - 32px);background:#fff;border-radius:16px;box-shadow:0 20px 60px rgba(20,25,40,.3);padding:22px 22px 18px;color:#1F2430">' +
      '<div style="display:flex;align-items:center;gap:10px;margin-bottom:8px"><span style="width:30px;height:30px;border-radius:15px;background:#FFF4D6;color:#8A5A00;display:flex;align-items:center;justify-content:center;font-weight:700">!</span>' +
      '<b style="font-size:16px">' + T.expTitle + '</b></div>' +
      '<div style="font-size:13.5px;line-height:1.5;color:#4B5563">' + T.expText + '</div>' +
      '<div style="display:flex;justify-content:flex-end;margin-top:16px"><button type="button" style="height:34px;padding:0 16px;border:0;border-radius:9px;background:#1F2430;color:#fff;font-weight:600;cursor:pointer">' + T.expBtn + '</button></div></div>';
    o.querySelector('button').onclick = function () { window.top.location = '/login.s'; };
    document.body.appendChild(o);
  }
  function checkSession(status) {
    var x = new XMLHttpRequest();
    x._fmsSkip = true;
    x.open('GET', '/session/ping.s?t=' + Date.now(), true);
    x.onload = function () {
      if (String(x.responseText).replace(/\s/g, '') === 'N' || /login\.s/.test(x.responseURL || '')) expired();
      else note(T.srv + status + T.srv2);
    };
    x.onerror = function () { note(T.net); };
    x.send();
  }
  var X = window.XMLHttpRequest.prototype, send = X.send;
  X.send = function () {
    var xhr = this;
    if (!xhr._fmsSkip) {
      var aborted = false;
      xhr.addEventListener('abort', function () { aborted = true; });
      xhr.addEventListener('loadend', function () {
        if (aborted || expiredShown) return;
        if (xhr.status === 0) { note(T.net); return; }
        if (/\/login\.s/.test(xhr.responseURL || '')) { expired(); return; }
        if (xhr.status >= 500) checkSession(xhr.status);
      });
    }
    return send.apply(xhr, arguments);
  };
  window.FmsNet = {expired: expired};
})(window, document);

/*
 * Confirmation window in the new style instead of the browser confirm():
 *   FmsConfirm(text, onYes[, onNo][, {ok: 'label', danger: true}])
 * Deleting / cancelling / rolling back texts get a red button automatically. Enter confirms, Esc and a click outside cancel.
 */
(function (window, document) {
  'use strict';
  if (window.FmsConfirm) return;
  var T = {
    title: '\u041f\u043e\u0434\u0442\u0432\u0435\u0440\u0434\u0438\u0442\u0435 \u0434\u0435\u0439\u0441\u0442\u0432\u0438\u0435',
    titleDel: '\u0423\u0434\u0430\u043b\u0435\u043d\u0438\u0435',
    ok: '\u0414\u0430, \u043f\u0440\u043e\u0434\u043e\u043b\u0436\u0438\u0442\u044c',
    del: '\u0423\u0434\u0430\u043b\u0438\u0442\u044c',
    cancel: '\u041e\u0442\u043c\u0435\u043d\u0430'
  };
  // udal, otmen, otkat, annul, ubrat, sbros, ochist
  var DANGER = /(\u0443\u0434\u0430\u043b|\u043e\u0442\u043c\u0435\u043d|\u043e\u0442\u043a\u0430\u0442|\u0430\u043d\u0443\u043b|\u0443\u0431\u0440\u0430\u0442|\u0441\u0431\u0440\u043e\u0441|\u043e\u0447\u0438\u0441\u0442)/i;
  var DELETE = /\u0443\u0434\u0430\u043b/i;
  var css = '#fms-cf{position:fixed;inset:0;z-index:25000;display:flex;align-items:center;justify-content:center;background:rgba(20,25,40,.4);' +
    'font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;opacity:0;transition:opacity .12s}' +
    '#fms-cf.on{opacity:1}' +
    '#fms-cf .bx{width:420px;max-width:calc(100% - 32px);background:#fff;border-radius:16px;box-shadow:0 20px 60px rgba(20,25,40,.3);color:#1F2430;transform:translateY(6px);transition:transform .12s}' +
    '#fms-cf.on .bx{transform:none}' +
    '#fms-cf .hd{display:flex;align-items:center;gap:10px;padding:18px 20px 6px}' +
    '#fms-cf .ic{flex:none;width:32px;height:32px;border-radius:16px;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:15px;background:#EEF1F6;color:#3C4A63}' +
    '#fms-cf.dg .ic{background:#FDECEE;color:#C0182B}' +
    '#fms-cf .tt{font-size:15px;font-weight:700}' +
    '#fms-cf .tx{padding:4px 20px 18px 62px;font-size:13.5px;line-height:1.5;color:#4B5563;white-space:pre-line;word-wrap:break-word}' +
    '#fms-cf .ft{display:flex;justify-content:flex-end;gap:8px;padding:12px 16px;border-top:1px solid #E6E8EC;background:#FAFBFC;border-radius:0 0 16px 16px}' +
    '#fms-cf button{height:34px;padding:0 16px;border-radius:9px;font:600 13px Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;cursor:pointer}' +
    '#fms-cf .no{border:1px solid #E6E8EC;background:#fff;color:#3C4250}' +
    '#fms-cf .no:hover{background:#F5F6F8}' +
    '#fms-cf .yes{border:1px solid #1F2430;background:#1F2430;color:#fff}' +
    '#fms-cf.dg .yes{border-color:#C0182B;background:#C0182B}' +
    '#fms-cf .yes:hover{filter:brightness(1.1)}' +
    '#fms-cf .in{display:block;width:calc(100% - 82px);margin:-8px 20px 16px 62px;height:36px;padding:0 10px;border:1px solid #E6E8EC;border-radius:9px;font:14px Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;color:#1F2430;outline:none;box-sizing:border-box}' +
    '#fms-cf .in:focus{border-color:#4B5563;box-shadow:0 0 0 3px rgba(75,85,99,.12)}' +
    '#fms-cf .in.bad{border-color:#C0182B;box-shadow:0 0 0 3px rgba(192,24,43,.12)}';
  var st = document.createElement('style');
  st.appendChild(document.createTextNode(css));
  (document.head || document.documentElement).appendChild(st);

  var box = null;
  function plain(v) {
    var d = document.createElement('div');
    d.innerHTML = String(v == null ? '' : v);
    return (d.textContent || '').trim();
  }
  window.FmsConfirm = function (text, onYes, onNo, opt) {
    if (onNo && typeof onNo === 'object') { opt = onNo; onNo = null; }
    opt = opt || {};
    var msg = plain(text), danger = opt.danger != null ? !!opt.danger : DANGER.test(msg);
    if (box && box.parentNode) box.parentNode.removeChild(box);
    box = document.createElement('div');
    box.id = 'fms-cf';
    if (danger) box.className = 'dg';
    box.innerHTML = '<div class="bx" role="dialog" aria-modal="true"><div class="hd"><span class="ic">' + (danger ? '!' : '?') + '</span><span class="tt"></span></div>' +
      '<div class="tx"></div>' + (opt.input ? '<input type="text" class="in" autocomplete="off">' : '') + '<div class="ft"><button type="button" class="no"></button><button type="button" class="yes"></button></div></div>';
    box.querySelector('.tt').textContent = opt.title || (DELETE.test(msg) ? T.titleDel : T.title);
    box.querySelector('.tx').textContent = msg;
    box.querySelector('.no').textContent = opt.cancel || T.cancel;
    box.querySelector('.yes').textContent = opt.ok || (DELETE.test(msg) ? T.del : T.ok);
    var prev = document.activeElement, done = false, inp = box.querySelector('.in');
    if (inp) { inp.placeholder = typeof opt.input === 'string' ? opt.input : ''; if (opt.value != null) inp.value = opt.value; }
    function close(yes) {
      if (done) return;
      // input mode: an empty answer is not accepted unless opt.allowEmpty
      if (yes && inp && !opt.allowEmpty && !inp.value.replace(/^\s+|\s+$/g, '')) { inp.classList.add('bad'); inp.focus(); return; }
      done = true;
      document.removeEventListener('keydown', onKey, true);
      box.classList.remove('on');
      var b = box;
      setTimeout(function () { if (b.parentNode) b.parentNode.removeChild(b); }, 120);
      try { if (prev && prev.focus) prev.focus(); } catch (e) {}
      var fn = yes ? onYes : onNo;
      if (typeof fn === 'function') fn(inp ? inp.value.replace(/^\s+|\s+$/g, '') : undefined);
    }
    function onKey(e) {
      if (e.key === 'Escape' || e.keyCode === 27) { e.preventDefault(); e.stopPropagation(); close(false); }
      else if (e.key === 'Enter' || e.keyCode === 13) { e.preventDefault(); e.stopPropagation(); close(true); }
    }
    box.querySelector('.no').onclick = function () { close(false); };
    box.querySelector('.yes').onclick = function () { close(true); };
    box.addEventListener('mousedown', function (e) { if (e.target === box) close(false); });
    document.addEventListener('keydown', onKey, true);
    document.body.appendChild(box);
    setTimeout(function () { box.classList.add('on'); (inp || box.querySelector('.yes')).focus(); }, 10);
  };
  /* FmsPrompt(text, onOk(value)[, {input: 'placeholder', value: '', ok: 'label', allowEmpty: false}]) instead of prompt() */
  window.FmsPrompt = function (text, onOk, opt) {
    opt = opt || {};
    if (!opt.input) opt.input = true;
    if (opt.danger == null) opt.danger = false;
    window.FmsConfirm(text, onOk, null, opt);
  };
})(window, document);

/*
 * Auto logout after inactivity (FmsIdle).
 *  - every window that loads common.js (main page, patient card frames, popups) records user activity
 *    (mouse, keys, scroll, touch) into localStorage "fmsActive", so activity in any tab or frame counts;
 *  - the main window calls FmsIdle.start(): one minute before the limit a warning window with a countdown
 *    appears; after the limit the user is sent to /out.s (session closed, login page).
 */
(function (window, document) {
  'use strict';
  if (window.FmsIdle) return;
  var KEY = 'fmsActive', last = Date.now(), wrote = 0;
  function now() { return Date.now(); }
  function store(t) { try { window.localStorage.setItem(KEY, String(t)); } catch (e) {} }
  function read() {
    var v = 0;
    try { v = parseInt(window.localStorage.getItem(KEY), 10) || 0; } catch (e) {}
    return Math.max(v, last);
  }
  function touch() {
    last = now();
    if (last - wrote > 3000) { wrote = last; store(last); }
    // popup windows also tell the main window directly
    try { if (window.opener && window.opener.FmsIdle && window.opener !== window) window.opener.FmsIdle.seen(last); } catch (e) {}
    try { if (window.parent && window.parent !== window && window.parent.FmsIdle) window.parent.FmsIdle.seen(last); } catch (e) {}
  }
  function listen(doc) {
    if (!doc || doc.__fmsIdle) return;
    doc.__fmsIdle = true;
    ['mousedown', 'mousemove', 'keydown', 'wheel', 'scroll', 'touchstart'].forEach(function (ev) {
      doc.addEventListener(ev, touch, true);
    });
  }
  listen(document);

  var timer = null, box = null, opt = null;
  function ensureBox() {
    if (box) return box;
    var css = '#fms-idle{position:fixed;inset:0;z-index:26000;display:none;align-items:center;justify-content:center;background:rgba(20,25,40,.45);font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif}' +
      '#fms-idle.on{display:flex}' +
      '#fms-idle .bx{width:400px;max-width:calc(100% - 32px);background:#fff;border-radius:16px;box-shadow:0 20px 60px rgba(20,25,40,.3);color:#1F2430;text-align:center;padding:24px 22px 18px}' +
      '#fms-idle .ic{width:46px;height:46px;margin:0 auto 10px;border-radius:23px;background:#FFF4D6;color:#8A5A00;display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700}' +
      '#fms-idle .tt{font-size:16px;font-weight:700}' +
      '#fms-idle .tx{margin:6px 0 14px;font-size:13.5px;color:#4B5563;line-height:1.5}' +
      '#fms-idle .sec{font-size:30px;font-weight:700;font-variant-numeric:tabular-nums;margin-bottom:14px}' +
      '#fms-idle button{height:36px;padding:0 18px;border-radius:9px;font:600 13.5px Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;cursor:pointer;margin:0 4px}' +
      '#fms-idle .go{border:1px solid #1F2430;background:#1F2430;color:#fff}' +
      '#fms-idle .out{border:1px solid #E6E8EC;background:#fff;color:#3C4250}';
    var st = document.createElement('style');
    st.appendChild(document.createTextNode(css));
    (document.head || document.documentElement).appendChild(st);
    box = document.createElement('div');
    box.id = 'fms-idle';
    box.innerHTML = '<div class="bx" role="alertdialog" aria-modal="true"><div class="ic">!</div>' +
      '<div class="tt">\u0412\u044b \u0434\u0430\u0432\u043d\u043e \u043d\u0435 \u0440\u0430\u0431\u043e\u0442\u0430\u043b\u0438 \u0432 \u0441\u0438\u0441\u0442\u0435\u043c\u0435</div>' +
      '<div class="tx">\u0414\u043b\u044f \u0431\u0435\u0437\u043e\u043f\u0430\u0441\u043d\u043e\u0441\u0442\u0438 \u0441\u0435\u0430\u043d\u0441 \u0431\u0443\u0434\u0435\u0442 \u0437\u0430\u0432\u0435\u0440\u0448\u0451\u043d \u0447\u0435\u0440\u0435\u0437</div>' +
      '<div class="sec">60</div>' +
      '<button type="button" class="out">\u0412\u044b\u0439\u0442\u0438 \u0441\u0435\u0439\u0447\u0430\u0441</button><button type="button" class="go">\u041f\u0440\u043e\u0434\u043e\u043b\u0436\u0438\u0442\u044c \u0440\u0430\u0431\u043e\u0442\u0443</button></div>';
    box.querySelector('.go').onclick = function () { touch(); store(now()); hide(); };
    box.querySelector('.out').onclick = function () { logout(); };
    document.body.appendChild(box);
    return box;
  }
  function hide() { if (box) box.classList.remove('on'); }
  function logout() {
    if (timer) { clearInterval(timer); timer = null; }
    try { window.localStorage.setItem('fmsIdleOut', String(now())); } catch (e) {}
    window.location.href = opt.logout;
  }
  // same-origin frames (patient card tabs) get listeners too, even if they load an old common.js
  function frames(doc, depth) {
    if (depth > 3) return;
    var list = doc.getElementsByTagName('iframe');
    for (var i = 0; i < list.length; i++) {
      try {
        var d = list[i].contentDocument;
        if (d) { listen(d); frames(d, depth + 1); }
      } catch (e) {}
    }
  }
  function check() {
    frames(document, 0);
    var idle = now() - read();
    if (idle >= opt.limit) { logout(); return; }
    var left = opt.limit - idle;
    if (left <= opt.warn) {
      var b = ensureBox();
      b.querySelector('.sec').textContent = Math.ceil(left / 1000);
      b.classList.add('on');
    } else hide();
  }
  window.FmsIdle = {
    touch: touch,
    // activity reported by a popup or a frame
    seen: function (t) { if (t > last) { last = t; if (last - wrote > 3000) { wrote = last; store(last); } } },
    start: function (o) {
      opt = {limit: 15 * 60 * 1000, warn: 60 * 1000, logout: '/out.s'};
      for (var k in (o || {})) opt[k] = o[k];
      touch();
      store(now());
      if (timer) clearInterval(timer);
      timer = setInterval(check, 1000);
    }
  };
})(window, document);
