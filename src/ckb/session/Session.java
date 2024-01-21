package ckb.session;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 22:10
 * To change this template use File | Settings | File Templates.
 */
public class Session {
  private int userId;       // Ид пользователя
  private String userName;  // ФИО пользователя
  private int roleId;       // Ид-р роли
  private int deptId;       // Ид-р департамента
  private String curUrl;    // Текущий адрес
  private String curSubUrl = ""; // Текущий под адрес
  private int curPat;       // Текущий пациент
  private String backUrl;   // Адрес для возврата
  private boolean isArchive = false; // Флаг архивности
  private List<Integer> kdoTypesIds;
  private Map<String, String> params;
  //Фильтры
  private boolean isFiltered = false;
  private String filterFio = ""; // ФИО
  private HashMap<String, String> filters = new HashMap<String, String>();
  private HashMap<String, String> ambFilters = new HashMap<String, String>();
  private HashMap<String, String> dateBegin = new HashMap<String, String>();
  private HashMap<String, String> dateEnd = new HashMap<String, String>();

  public String getFilterSql(){
    String sql = "";
    if(filters != null) {
      for(Map.Entry<String, String> f : filters.entrySet()) {
        if(f.getKey().equalsIgnoreCase("lv_id") || f.getKey().equalsIgnoreCase("dept_id")) {
          sql += f.getKey() + " = " + f.getValue() + " And ";
        } else {
          if(f.getKey().toLowerCase().contains("birth"))
            sql += "birthYear " + (f.getKey().toLowerCase().contains("end") ? "<=" : ">=") + f.getValue() + " And ";
          if(f.getKey().toLowerCase().contains("reg"))
            sql += "date_begin " + (f.getKey().toLowerCase().contains("end") ? "<='" : ">='") + f.getValue() + "' And ";
          if(f.getKey().toLowerCase().contains("vyp"))
            sql += "date_end " + (f.getKey().toLowerCase().contains("end") ? "<='" : ">='") + f.getValue() + "' And ";
        }
      }
    }
    if(sql.length() > 0)
      sql = " And " + sql.substring(0, sql.length() - 5);
    return sql;
  }

  public String getAmbFilterSql(){
    String sql = "";
    if(ambFilters != null) {
      for(Map.Entry<String, String> f : ambFilters.entrySet()) {
        if(f.getKey().equalsIgnoreCase("group_id")) {
          String val = f.getValue();
          sql += " Exists (Select 1 From Amb_Patient_Services c, Amb_Services d Where d.id = c.service_id And c.patient = t.id And d.group_id = " + val + ") And ";
        } else if(f.getKey().equalsIgnoreCase("state")) {
          sql += f.getKey() + " = '" + f.getValue() + "' And ";
        } else {
          if(f.getKey().toLowerCase().contains("birth"))
            sql += "birthyear " + (f.getKey().toLowerCase().contains("end") ? "<=" : ">=") + f.getValue() + " And ";
          if(f.getKey().toLowerCase().contains("reg"))
            sql += "reg_Date " + (f.getKey().toLowerCase().contains("end") ? "<='" : ">='") + f.getValue() + "' And ";
        }
      }
    }
    if(sql.length() > 0)
      sql = " And " + sql.substring(0, sql.length() - 5);
    return sql;
  }

  public HashMap<String, String> getFilters() {
    return filters;
  }

  public void clearFilter() {
    if(filters != null) filters.clear();
    if(ambFilters != null) ambFilters.clear();
  }

  public void setFilters(HashMap<String,String> values) {
    filters = values;
  }

  public String getParam(String code) {
    try {
      return this.params.get(code);
    } catch (Exception e) {
      return "";
    }
  }

  public boolean isParamEqual(String code, String val) {
    String param = getParam(code);
    return param != null && param.equals(val);
  }

  public String getBackUrl() {
    return backUrl;
  }

  public void setBackUrl(String backUrl) {
    this.backUrl = backUrl;
  }

  public int getCurPat() {
    return curPat;
  }

  public void setCurPat(int curPat) {
    this.curPat = curPat;
  }

  public String getCurUrl() {
    return curUrl;
  }

  public void setCurUrl(String curUrl) {
    this.curUrl = curUrl;
  }

  public int getRoleId() {
    return roleId;
  }

  public void setRoleId(int roleId) {
    this.roleId = roleId;
  }

  public int getDeptId() {
    return deptId;
  }

  public void setDeptId(int deptId) {
    this.deptId = deptId;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId(int userId) {
    this.userId = userId;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

  public String getCurSubUrl() {
    return curSubUrl;
  }

  public void setCurSubUrl(String curSubUrl) {
    this.curSubUrl = curSubUrl;
  }

  public String getFilterFio() {
    return filterFio;
  }

  public void setFilterFio(String filterFio) {
    this.filterFio = filterFio;
  }

  public boolean isFiltered() {
    return isFiltered;
  }

  public void setFiltered(boolean filtered) {
    isFiltered = filtered;
  }

  public boolean isArchive() {
    return isArchive;
  }

  public void setArchive(boolean archive) {
    isArchive = archive;
  }

  public List<Integer> getKdoTypesIds() {
    return kdoTypesIds;
  }

  public void setKdoTypesIds(List<Integer> kdoTypesIds) {
    this.kdoTypesIds = kdoTypesIds;
  }

  public Map<String, String> getParams() {
    return params;
  }

  public void setParams(Map<String, String> params) {
    this.params = params;
  }

  public HashMap<String, String> getAmbFilters() {
    return ambFilters;
  }

  public void setAmbFilters(HashMap<String, String> ambFilters) {
    this.ambFilters = ambFilters;
  }

  public HashMap<String, String> getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(HashMap<String, String> dateBegin) {
    this.dateBegin = dateBegin;
  }

  public HashMap<String, String> getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(HashMap<String, String> dateEnd) {
    this.dateEnd = dateEnd;
  }

  public boolean isReg() {
    return roleId == 15;
  }
}
