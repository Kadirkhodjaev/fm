package ckb.utils;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DB {

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


  public static Connection getConnection() {
    Connection conn = null;
    Properties prop = null;
    try {
      InputStream is = DB.class.getClassLoader().getResourceAsStream("db.properties");
      prop = new Properties();
      if (is != null) prop.load(is);
      if(prop != null) {
        Class.forName(prop.getProperty("jdbc.driverClassName"));
        return DriverManager.getConnection(prop.getProperty("jdbc.url"), prop.getProperty("jdbc.username"), prop.getProperty("jdbc.password"));
      }
    } catch (Exception e) {
      System.err.println("DB_CONN_ERR = " + e.getMessage());
    }
    return conn;
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
