package ckb.utils;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ApiSchedule implements Job {

  protected static JSONObject APIresult(HttpURLConnection con) throws IOException, JSONException {
    if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
      BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));
      String inputLine;
      StringBuilder response = new StringBuilder();
      while ((inputLine = in.readLine()) != null) response.append(inputLine);
      in.close();
      JSONObject res = new JSONObject(response.toString());
      return res;
    }
    return new JSONObject();
  }

  private static void sendAmb() {
    HttpURLConnection con = null;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null, rc = null;
    /*try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select t.*, c.fio user_fio From Amb_Patients t, Users c Where Not Exists (Select 1 From Crm_Patients d Where d.patient_id = t.id) And t.state in ('WORK', 'DONE', 'ARCH') And c.id = t.crBy And t.id > 143050 "); // And date(t.reg_date) = CURRENT_DATE()
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject row = new JSONObject();
        row.put("id", rs.getInt("id"));
        row.put("first_name", rs.getString("name"));
        row.put("last_name", rs.getString("surname"));
        row.put("middle_name", rs.getString("middlename"));
        row.put("reg_date", Util.dateTimeToString(rs.getDate("reg_date")));
        row.put("client_id", rs.getString("client_id"));
        row.put("sex", rs.getInt("sex") == 13 ? 0 : 1);
        row.put("cr_by_id", rs.getInt("crBy"));
        row.put("cr_by", rs.getString("user_fio"));
        row.put("birthday", Util.dateToString(rs.getDate("birthday")));
        ps = conn.prepareStatement("Select sum(ifnull(t.card, 0) + ifnull(t.cash, 0) + ifnull(t.transfer, 0) + ifnull(t.humo, 0) + ifnull(t.visa, 0) + ifnull(t.online, 0)) paid From Amb_Patient_Pays t Where t.patient = ?");
        ps.setInt(1, rs.getInt("id"));
        rc =  ps.executeQuery();
        if(rc.next()) row.put("paid", rc.getString("paid"));
        JSONArray services = new JSONArray();
        ps = conn.prepareStatement("Select t.*, c.id service_id, c.name service_name, d.fio worker_fio From Amb_Patient_Services t, Amb_Services c, Users d Where d.id = t.worker_id And c.id = t.service_id And t.state in ('PAID', 'DONE') And t.patient = ?");
        ps.setInt(1, rs.getInt("id"));
        rc = ps.executeQuery();
        while (rc.next()) {
          JSONObject r = new JSONObject();
          r.put("id", rc.getInt("id"));
          r.put("service_id", rc.getInt("service_id"));
          r.put("service_name", rc.getString("service_name"));
          r.put("worker_id", rc.getInt("worker_id"));
          r.put("worker_fio", rc.getString("worker_fio"));
          services.put(r);
        }
        row.put("services", services);
        //
        URL obj = new URL("http://195.158.4.73:5000/api/regpatient");
        con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Cookie", ".AspNetCore.Identity.Application=CfDJ8M9k00ZCKRxCoiGwt4ONGGGBERI82-7lj1O6pmtxSx0OSLWSvzOFxKAAq5RnfRur0XPQGwkmO329BeZaaclQbBYG9QEphuUF5ZMLlokIzRMl8GDSUY7vjVmS6frqMdCG4V8DVKqUhx9brt3usa0sRfPAub34g6QxKe_eL_gp3sLfq2ZrKSzRAzTOwBda9ZjtTe7rSKDZwSZVKkR9oWBmfXoqwpJUD9ieB0dP2WRqEhgu5jlzrfAvq10tcnK0lEmh4LK2tOontq6UgZMYQmvjM6rXWL2E-xGmM8FaoSNm2-5xzKNa3SK0fbaHnn0v0rkwLFye31tUKFSw_A2ws3HoOzN6myU1AKUAH9d4vOrDOe4UoC-V3I1vdbRVsNLeKHO9GNZAocob4HO9H7nEW6MYjGfKQzxK31pjhL3_5WjgINQ6A7r0YoCHdfrooprSGjawe8sJFWxLPNJBPDVg7Ri4-yi37rlApD-A29tCYy2Jb8fvHksz9VaDN5GyuQ2SIOF2iw1OfgjhiYEYilzpZqCqjW8WnrXynDSHGSsWsD1DhvF5nUdPMycrn67YGBFMdMuR3zT2Yp63lsfUqTmITe91E5F_zIXF7odg7i7O_4gNMa7P6ttyXfKdOllR9iUG7_aoZy1xDrEvjEz8Z3X2wU8zEtDDc7-QXzb36p8XpRQ2LKpL7H1cfVNaV_gWBeXKIC0tNA"); // <- use full value here
        con.setRequestProperty("Content-Type", "application/json; utf-8");
        con.setDoOutput(true);
        try (OutputStream os = con.getOutputStream()) {
          byte[] input = row.toString().getBytes(StandardCharsets.UTF_8);
          os.write(input, 0, input.length);
        }
        JSONObject res = APIresult(con);
        //
        con.disconnect();
        System.out.println(res);
        ps = conn.prepareStatement("Insert Into Crm_Patients(patient_Id) values(?)");
        ps.setInt(1, rs.getInt("id"));
        ps.executeUpdate();
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
      DB.done(rc);
    }*/
  }

  @Override
  public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
    try {
      sendAmb();
    }catch (Exception e) {
      e.printStackTrace();
    }
  }
}
