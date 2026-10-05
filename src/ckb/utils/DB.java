package ckb.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DB {

  private static volatile javax.sql.DataSource dataSource;

  public static void setDataSource(javax.sql.DataSource ds) {
    dataSource = ds;
  }

  public static void done(Connection obj) {
    try {
      if(obj != null) obj.close();
    } catch (Exception e){
      e.printStackTrace();
    }
  }

  public static void done(PreparedStatement obj) {
    try {
      if(obj != null) obj.close();
    } catch (Exception e){
      e.printStackTrace();
    }
  }

  public static void done(ResultSet obj) {
    try {
      if(obj != null) obj.close();
    } catch (Exception e){
      e.printStackTrace();
    }
  }

  public static void done(Connection conn, PreparedStatement ps, ResultSet rs) {
    done(rs);
    done(ps);
    done(conn);
  }

  public static Connection getConnection() {
    try {
      return dataSource.getConnection();
    } catch (Exception e) {
      System.err.println("DB_CONN_ERR = " + e.getMessage());
      e.printStackTrace();
      return null;
    }
  }

  public static Double getSum(Connection conn, String sql) throws SQLException {
    PreparedStatement ps = null;
    ResultSet rs = null;
    Double vSum = 0D;
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      if(rs.next()) {
        vSum = rs.getDouble(1);
      }
      return vSum;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

}
