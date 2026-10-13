package ckb.session;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginChecker implements Filter {

  @Override
  public void init(FilterConfig filterConfig) {}

  @Override
  public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
    HttpServletRequest request = (HttpServletRequest) req;
    HttpServletResponse response = (HttpServletResponse) res;
    String url = request.getRequestURL().toString();
    Session session = SessionUtil.getUser(request);
    if(url.contains("bot-pdf.s?id=") && session == null && url.indexOf("login.s") == -1 && url.indexOf("amb/qrcode") == -1)
      response.getOutputStream().println("<script>parent.parent.document.location = '/login.s'</script>");
    else if(session == null && expiredPage(request)) {
      // сессия закончилась (выход, перезапуск сервера): страница во фрейме или окне уходит на вход, а не падает с ошибкой 500
      response.setContentType("text/html;charset=UTF-8");
      response.getOutputStream().print("<script>(window.top || window).location = '/login.s';</script>");
    } else
      chain.doFilter(req, res);
  }

  // обычная загрузка страницы (не ajax: его обрабатывает FmsNet в common.js) по адресу, которому нужен вход
  private static boolean expiredPage(HttpServletRequest r) {
    if(!"GET".equals(r.getMethod()) || "XMLHttpRequest".equals(r.getHeader("X-Requested-With"))) return false;
    String accept = r.getHeader("Accept");
    if(accept == null || !accept.contains("text/html")) return false;
    String path = r.getRequestURI();
    for(String open : OPEN) if(open.startsWith("/") ? path.equals(open) : path.contains(open)) return false;
    return true;
  }

  // адреса без входа: вход и выход, проверка сессии, страница результатов по QR и PDF для бота
  private static final String[] OPEN = {"/login.s", "/user_login.s", "/out.s", "/main.s", "/session/ping.s", "qrcode", "bot-pdf"};

  @Override
  public void destroy() {}
}
