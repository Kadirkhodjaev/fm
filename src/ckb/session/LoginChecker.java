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
    if(url.contains("bot-pdf.s?id=") && session == null && url.indexOf("login.s") == -1)
      response.getOutputStream().println("<script>parent.parent.document.location = '/login.s'</script>");
    else
      chain.doFilter(req, res);
  }

  @Override
  public void destroy() {}
}
