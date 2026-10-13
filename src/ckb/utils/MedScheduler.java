package ckb.utils;

import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Properties;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class MedScheduler implements Job {

  @Override
  public void execute(final JobExecutionContext ctx) {
    Calendar calendar = Calendar.getInstance();
    calendar.add(Calendar.DATE, -11);
    Connection conn = null;
    PreparedStatement ps = null;
    try {
      // archive in three statements instead of loading and saving every patient one by one
      conn = DB.getConnection();
      Timestamp ambBefore = new Timestamp(calendar.getTimeInMillis());
      // outpatients registered more than 11 days ago: services that are not done are cancelled automatically
      ps = conn.prepareStatement(
        "Update Amb_Patient_Services s Set s.state = 'AUTO_DEL' " +
        " Where (s.state Is Null Or s.state != 'DONE') " +
        "   And s.patient In (Select p.id From Amb_Patients p Where p.state != 'ARCH' And p.Reg_Date < ?)");
      ps.setTimestamp(1, ambBefore);
      ps.executeUpdate();
      DB.done(ps);
      ps = conn.prepareStatement("Update Amb_Patients Set state = 'ARCH' Where state != 'ARCH' And Reg_Date < ?");
      ps.setTimestamp(1, ambBefore);
      ps.executeUpdate();
      DB.done(ps);
      // inpatients discharged (ZGV) more than 15 days ago
      calendar.add(Calendar.DATE, -3);
      ps = conn.prepareStatement("Update Patients Set state = 'ARCH' Where state = 'ZGV' And Date_End <= ?");
      ps.setString(1, Util.dateDB(calendar.getTime()));
      ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
    try {
      // cash data mart for the management module (Dwh_Cashboxs): daily sums by payment method
      DwhCashbox.rebuildRecent();
    } catch (Exception e) {
      e.printStackTrace();
    }
    try {
      // client base: types (VIP, regular, ...) and financial totals for the client list
      ckb.services.med.client.ClientStats.refresh();
    } catch (Exception e) {
      e.printStackTrace();
    }
    try {
      backup();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  // nightly dump of the database to D:\dump\<date>.zip
  // login and password are taken from db.properties; the password goes to mysqldump through MYSQL_PWD,
  // so it is not written in the code and is not visible in the command line of the process
  private void backup() throws Exception {
    Properties db = new Properties();
    try (InputStream is = MedScheduler.class.getResourceAsStream("/db.properties")) {
      db.load(is);
    }
    String name = "D:\\dump\\" + Util.getCurDate().replace(".", "");
    File sql = new File(name + ".sql");
    // --single-transaction: all tables are InnoDB, so the dump reads a consistent snapshot without LOCK TABLES.
    // Without it mysqldump locked every table for the whole dump and any save in the system hung until it finished.
    // --quick: rows are streamed instead of loading whole tables into memory.
    ProcessBuilder builder = new ProcessBuilder("cmd", "/c", "mysqldump", "--single-transaction", "--quick",
      "-u" + db.getProperty("jdbc.username"), "fm");
    builder.environment().put("MYSQL_PWD", db.getProperty("jdbc.password", ""));
    builder.redirectErrorStream(false);
    builder.redirectOutput(sql);
    builder.redirectError(new File("NUL"));
    Process pb = builder.start();
    if (!pb.waitFor(30, java.util.concurrent.TimeUnit.MINUTES)) {
      pb.destroyForcibly();
      throw new RuntimeException("mysqldump timeout");
    }
    byte[] buf = new byte[1024];
    try (ZipOutputStream out = new ZipOutputStream(new FileOutputStream(name + ".zip"));
         InputStream in = new FileInputStream(sql)) {
      out.setLevel(Deflater.BEST_COMPRESSION);
      out.putNextEntry(new ZipEntry(sql.getName()));
      int len;
      while ((len = in.read(buf)) > 0) {
        out.write(buf, 0, len);
      }
      out.closeEntry();
    }
    sql.delete();
  }
}
