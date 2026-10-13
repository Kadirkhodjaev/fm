package ckb.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

/**
 * Counts grouped by a key in one query, instead of a separate count query for every room / doctor.
 */
public class Counts {

  // active patients per room: where is a condition on the Patients table
  public static Map<Integer, Long> patientsByRoom(String where) {
    return group("Select Room_Id, Count(*) From Patients Where Room_Id Is Not Null And (" + where + ") Group By Room_Id");
  }

  // first column is the key (id), second the count
  public static Map<Integer, Long> group(String sql) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Map<Integer, Long> res = new HashMap<>();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) res.put(rs.getInt(1), rs.getLong(2));
    } catch (Exception e) {
      throw new RuntimeException(e);
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return res;
  }

  public static Long get(Map<Integer, Long> counts, Integer id) {
    Long v = counts.get(id);
    return v == null ? 0L : v;
  }
}
