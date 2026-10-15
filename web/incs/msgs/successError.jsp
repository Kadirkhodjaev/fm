<%@ taglib prefix="lang" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cf" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Message after a save that reloaded the page: shown as the new notice (FmsToast, common.js).
     The old green/red bar is only a fallback for a page without common.js. --%>
<cf:if test="${messageCode != null || errorMsg != null}">
  <cf:if test="${messageCode != null}"><div class="alert alert-success alert-dismissable fms-old-msg" style="display:none"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><lang:message code="${messageCode}" /></div></cf:if>
  <cf:if test="${errorMsg != null}"><div class="alert alert-danger alert-dismissable fms-old-msg" style="display:none"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><lang:message code="${errorMsg}" /></div></cf:if>
  <script>
    (function () {
      function go() {
        var boxes = document.querySelectorAll('.fms-old-msg');
        for (var i = 0; i < boxes.length; i++) {
          var b = boxes[i], ok = b.className.indexOf('alert-success') >= 0;
          var x = b.querySelector('button.close');
          var text = (b.textContent || '').substring(x ? (x.textContent || '').length : 0).replace(/\s+/g, ' ').trim();
          var t = null;
          try { t = window.top !== window && window.top.FmsToast ? window.top.FmsToast : window.FmsToast; } catch (e) { t = window.FmsToast; }
          if (t && t.show) { t.show(text, ok ? 'ok' : 'err'); if (b.parentNode) b.parentNode.removeChild(b); }
          else b.style.display = '';
        }
      }
      if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', go); else go();
    })();
  </script>
</cf:if>
