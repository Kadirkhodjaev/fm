package ckb.models;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 22.08.15
 * Time: 23:40
 * To change this template use File | Settings | File Templates.
 */
public class Grid {
  private String orderCol = "";
  private String orderType = "";
  private String orderColId = "";
  private int startPos = 1;
  private int pageSize = 20;
  private int endPos = pageSize;
  private int page = 1;
  private long rowCount = 0;
  private int maxPage = 1;
  private String sql = "";

  public void init(){
    orderCol = "";
    orderType = "";
    orderColId = "";
    startPos = 1;
    endPos = pageSize;
    page = 1;
    rowCount = 0;
    maxPage = 1;
  }

  public int getPageSize() {
    return pageSize;
  }

  public void setPageSize(int pageSize) {
    this.pageSize = pageSize;
  }

  public String getOrderColId() {
    return orderColId;
  }

  public void setOrderColId(String orderColId) {
    this.orderColId = orderColId;
  }

  public String getSql() {
    return sql;
  }

  public void setSql(String sql) {
    this.sql = sql;
  }

  public int getMaxPage() {
    return maxPage;
  }

  public void setMaxPage(int maxPage) {
    this.maxPage = maxPage;
  }

  public long getRowCount() {
    return rowCount;
  }

  public void setRowCount(long rowCount) {
    this.rowCount = rowCount;
  }

  public int getStartPos() {
    return startPos;
  }

  public void setStartPos(int startPos) {
    this.startPos = startPos;
  }

  public int getEndPos() {
    return endPos;
  }

  public void setEndPos(int endPos) {
    this.endPos = endPos;
  }

  public int getPage() {
    return page;
  }

  public void setPage(int page) {
    this.page = page;
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
}
