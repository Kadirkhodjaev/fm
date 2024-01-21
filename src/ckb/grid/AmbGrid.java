package ckb.grid;

import ckb.utils.Util;

import javax.servlet.http.HttpServletRequest;

public class AmbGrid {

  private int startPos = 1;
  private String sql;
  private String order;
  private String orderCol = "";
  private String orderType = "";
  private int page = 1;
  private long rowCount = 0;
  private int maxPage = 1;
  private int pageSize = 20;
  private int[] pageSizes = {20, 50, 100, 200, 500};
  private String word = "";

  public int getStartPos() {
    return startPos;
  }

  public void setStartPos(int startPos) {
    this.startPos = startPos;
  }

  public String getSql() {
    return sql;
  }

  private String filter() {
    String a = "";
    if(!word.isEmpty()) a = " And (upper(surname) like '%" + word + "%' Or upper(name) like '%" + word + "%' Or upper(middlename) like '%" + word + "%')";
    return a;
  }

  private String orderBy() {
    return order.isEmpty() ? " " : " " + order;
  }

  public String select(){
    return sql + filter() + orderBy();
  }

  public void setSql(String sql) {
    this.sql = sql;
  }

  public String getOrder() {
    return order;
  }

  public void setOrder(String order) {
    this.order = order;
  }

  public String getOrderCol() {
    return orderCol;
  }

  public void setOrderCol(String orderCol) {
    this.orderCol = orderCol;
  }

  public String getOrderType() {
    return orderType;
  }

  public void setOrderType(String orderType) {
    this.orderType = orderType;
  }

  public int getPage() {
    return page;
  }

  public void setPage(int page) {
    this.page = page;
  }

  public long getRowCount() {
    return rowCount;
  }

  public void setRowCount(long rowCount) {
    this.rowCount = rowCount;
  }

  public int getMaxPage() {
    return maxPage;
  }

  public void setMaxPage(int maxPage) {
    this.maxPage = maxPage;
  }

  public int getPageSize() {
    return pageSize;
  }

  public void setPageSize(int pageSize) {
    this.pageSize = pageSize;
  }

  public int[] getPageSizes() {
    return pageSizes;
  }

  public void setPageSizes(int[] pageSizes) {
    this.pageSizes = pageSizes;
  }

  public String getWord() {
    return word;
  }

  public void setWord(String word) {
    this.word = word;
  }

  public void setGrid(HttpServletRequest req) {
    String action = Util.get(req, "action", "");
    if(action.equals("page_size")) {
      setPageSize(Util.getInt(req, "page_size"));
      page = 1;
    }
    if(action.equals("search")){
      setWord(Util.get(req, "word", "").toUpperCase());
      setPage(1);
    }
    if(action.equals("page_num")){
      setPage(Util.getInt(req, "page_num"));
    }
    if (action.equals("prev") && page != 1)
      setPage(page - 1);
    if (action.equals("begin"))
      page = 1;
    if (action.equals("next") && page != maxPage)
      setPage(page + 1);
    if (action.equals("end"))
      setPage(getMaxPage());
  }
}
