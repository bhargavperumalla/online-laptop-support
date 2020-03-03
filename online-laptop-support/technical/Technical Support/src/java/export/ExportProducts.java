/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package export;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import mybean.DB;



/**
 *
 * @author Narendra
 */
public class ExportProducts {
public static void main ( String[] args ) throws FileNotFoundException, IOException, Exception {
    dataExport();
}
public static void dataExport() throws FileNotFoundException, IOException, Exception{
RandomAccessFile raf=new RandomAccessFile("C:\\Users\\shiva\\Desktop\\Technical Support\\src\\java\\export\\modedata.txt","r");
    //RandomAccessFile raf=new RandomAccessFile("/home/CB/NB_Workspace/Technical Support/src/java/export/modedata.txt","r");
    String st;
    String[] str;
    int pid=1;
    Connection con=(Connection)getConnection();
    con.setAutoCommit(false);   
    PreparedStatement pst=(PreparedStatement) con.prepareStatement("insert into products values(?,?,?,?,?)"); 
    while((st=raf.readLine())!=null)  //check the file endpoint
     {
        str=st.split(",");
       /* for(int i=0; i<str.length; i++){
            System.out.print(str[i].trim());
        }*/
         System.out.println(pid+"  "+str[0]+"  "+str[1]);
         
         
             pst.setInt(1,pid);
             pst.setString(2,str[0]);
             pst.setString(3,null);
             pst.setString(4,str[1]); 
             pst.setInt(5,1);
             pst.executeUpdate(); 
             con.commit();
             
             
             
       // inserdb(count,str[0].trim(),str[1].trim());
        pid++;
         System.out.println("");
    }
     pst.close();
     con.close();   
 raf.close();
}
public static Connection getOracleConnection() throws Exception {
	System.out.println("Oracle Connect Example.");
        Connection conn = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";       
        String driver = "oracle.jdbc.driver.OracleDriver";
        String userName = "tech";
        String password = "tech";
        try {
            Class.forName(driver).newInstance();
            conn = (Connection) DriverManager.getConnection(url, userName, password);
            System.out.println("Connected to the database");
        /* conn.close();
        System.out.println("Disconnected from database");*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
	}


 public static Connection getMYSQLConnection() throws Exception {
        System.out.println("MySQL Connect Example.");
        Connection conn = null;
        String url = "jdbc:mysql://172.17.5.85:3306/";
        String dbName = "test";
        String driver = "com.mysql.jdbc.Driver";
        String userName = "j2ee5";
        String password = "j2ee";
        try {
            Class.forName(driver).newInstance();
            conn = (Connection) DriverManager.getConnection(url + dbName, userName, password);
            System.out.println("Connected to the database");
        /* conn.close();
        System.out.println("Disconnected from database");*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
}
 public static Connection getConnection() throws Exception {
    //return getMYSQLConnection();
    return getOracleConnection();
 }
public static void inserdb(int pid,String pname,String productName) throws Exception{
 Connection con=getConnection();
 con.setAutoCommit(false);   
  PreparedStatement st=(PreparedStatement) con.prepareStatement("insert into products values(?,?,?,?,?)"); 
             st.setInt(1,pid);
             st.setString(2,pname);
             st.setString(3,null);
             st.setString(4,productName); 
             st.setInt(5,1);
             st.executeUpdate(); 
             con.commit();
             st.close();
             con.close();
}
}
