package ckb.utils;

import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class MedScheduler implements Job {

  @Override
  public void execute(final JobExecutionContext ctx) {
    ApplicationContextHolder ach = new ApplicationContextHolder();
    DAmbPatient dAmbPatient = ach.getContext().getBean(DAmbPatient.class);
    DAmbPatientService dAmbPatientServices = ach.getContext().getBean(DAmbPatientService.class);
    Calendar calendar = Calendar.getInstance();
    calendar.add(Calendar.DATE, -5);
    try {
      Integer counter = 0;
      String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS").format(calendar.getTime());
      List<AmbPatients> patients = dAmbPatient.getList("From AmbPatients Where state != 'ARCH' And regDate < '" + date + "'");
      for(AmbPatients patient: patients) {
        List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + patient.getId());
        for(AmbPatientServices service : services) {
          if(!"DONE".equals(service.getState())) {
            service.setState("AUTO_DEL");
            dAmbPatientServices.save(service);
          }
        }
        counter++;
        patient.setState("ARCH");
        dAmbPatient.save(patient);
      }
      System.out.println("Archived patient count: " + counter);

      String[] commands = {"cmd", "/c", "mysqldump -uroot -proot fm > D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql"};
      Process pb = Runtime.getRuntime().exec(commands);
      pb.waitFor();
      byte[] buf = new byte[1024];
      File f = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".zip");
      ZipOutputStream out = new ZipOutputStream(new FileOutputStream(f));
      out.setLevel(Deflater.BEST_COMPRESSION);
      File entity = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql");
      InputStream in = new FileInputStream(entity);
      out.putNextEntry(new ZipEntry(entity.getName()));
      int len;
      while ((len = in.read(buf)) > 0) {
        out.write(buf, 0, len);
      }
      // Complete the entry
      out.closeEntry();
      in.close();
      out.close();
      File file = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql");
      file.delete();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
