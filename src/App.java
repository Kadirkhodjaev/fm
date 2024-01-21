import ckb.utils.DB;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Scanner;

public class App {

  public static void main(String[] args) throws FileNotFoundException {
    File myObj = new File("D:\\1.txt");
    Scanner myReader = new Scanner(myObj);
    Connection con = DB.getConnection();
    PreparedStatement ps = null;
    while (myReader.hasNextLine()) {
      String data = myReader.nextLine();
      if(!data.contains("/res/")) {
        String d = data.substring(47);
        d = d.substring(d.indexOf("/"));
        d = d.replace("HTTP/1.1\"", "|");
        String s = d.substring(d.indexOf("|"));
        if(s.length() > 5 && s.substring(2, 5).equals("200")) {
          d = d.replace(" | 200 ", "________");
          try {
            int t = Integer.parseInt(d.substring(d.indexOf("________") + 8, d.length()));
            if(t > 50) {
              ps = con.prepareStatement("Insert Into aaa values (?, ?)");
              ps.setString(1, d);
              ps.setInt(2, t);
              ps.execute();
            }
          } catch (Exception e) {}
        }
      }
    }
    myReader.close();
  }
}
