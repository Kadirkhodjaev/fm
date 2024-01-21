package ckb.session;

import ckb.grid.AmbGrid;
import ckb.models.Grid;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 22:14
 * To change this template use File | Settings | File Templates.
 */
public class SessionUtil {

  // Сохраняем пользовательские данные в сессии
  public static void setUser(HttpServletRequest request, Session session){
    WebUtils.setSessionAttribute(request, "ENV", session);
  }

  // Функция для получения пользовательских данных из сессии
  public static Session getUser(HttpServletRequest request) {
    Session session = (Session) WebUtils.getSessionAttribute(request, "ENV");
    /*if(session == null)
      throw new Exception("Ошибка сессий. Авторизуйтесь!");*/
    return session;
  }

  // Удаляем сессию
  public static void kill(HttpServletRequest request){
    request.getSession().invalidate();
  }

  public static void addSession(HttpServletRequest request, String sessionName, Object opt){
    request.getSession().setAttribute(sessionName, opt);
  }

  public static Grid getGrid(HttpServletRequest request, String sessionName){
    try {
      Grid grid = (Grid) request.getSession().getAttribute(sessionName);
      return grid == null ? new Grid() : grid;
    } catch(Exception ex) {
      return new Grid();
    }
  }

  public static AmbGrid getAmbGrid(HttpServletRequest request, String sessionName){
    try {
      AmbGrid grid = (AmbGrid) request.getSession().getAttribute(sessionName);
      return grid == null ? new AmbGrid() : grid;
    } catch(Exception ex) {
      return new AmbGrid();
    }
  }

  public static String getSession(HttpServletRequest request, String sessionName) {
    try {
      return (String) WebUtils.getSessionAttribute(request, sessionName);
    }catch(Exception e) {
      return "";
    }
  }
}
