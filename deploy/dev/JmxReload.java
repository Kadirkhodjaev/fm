import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/** Reloads the ROOT web app of the local Tomcat started by IntelliJ (JMX on 127.0.0.1:port, credentials from its password file). */
public class JmxReload {
  public static void main(String[] a) throws Exception {
    String port = a[0], pwdFile = a[1];
    String user = null, pass = null;
    BufferedReader r = new BufferedReader(new FileReader(pwdFile));
    for (String line; (line = r.readLine()) != null; ) {
      line = line.trim();
      if (line.isEmpty() || line.startsWith("#")) continue;
      String[] p = line.split("\\s+", 2);
      user = p[0]; pass = p.length > 1 ? p[1] : "";
      break;
    }
    r.close();
    Map<String, Object> env = new HashMap<String, Object>();
    env.put(JMXConnector.CREDENTIALS, new String[]{user, pass});
    JMXConnector c = JMXConnectorFactory.connect(new JMXServiceURL("service:jmx:rmi:///jndi/rmi://127.0.0.1:" + port + "/jmxrmi"), env);
    MBeanServerConnection s = c.getMBeanServerConnection();
    Set<ObjectName> names = s.queryNames(new ObjectName("Catalina:j2eeType=WebModule,name=//localhost/,*"), null);
    if (names.isEmpty()) { System.out.println("ROOT web module not found"); c.close(); System.exit(2); }
    for (ObjectName n : names) {
      long t = System.currentTimeMillis();
      s.invoke(n, "reload", null, null);
      System.out.println("reloaded " + n + " in " + (System.currentTimeMillis() - t) + " ms");
    }
    c.close();
  }
}
