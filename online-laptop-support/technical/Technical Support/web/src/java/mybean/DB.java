package mybean;

import java.sql.*;
import java.io.*;
/*
 create user tech identified by tech

grant create session to tech		      

grant dba to tech	              

alter user tech quota unlimited on system   
 */
public class DB implements Serializable {

    static Connection con = null;

   /*public static void main ( String[] args ) throws FileNotFoundException, IOException, Exception {
       System.out.println("sdjfgsdgsdhfg");
       if(getOracleConnection()!=null){System.out.println("connect object is created......"); }else{ System.out.println("Connect object is null");}
   }*/
    /*public static Connection getConnection() throws Exception {
        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
        con = DriverManager.getConnection("jdbc:odbc:tch", "scott", "tiger");
        System.out.println("***Connected to Oracle successfully***");
        return (con);

    }*/
    public static Connection getConnection() throws Exception {
    // return getMYSQLConnection();
     return getOracleConnection();
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
            conn = DriverManager.getConnection(url + dbName, userName, password);
            System.out.println("Connected to the database");
       /* conn.close();
        System.out.println("Disconnected from database");*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;       
    }
	public static Connection getOracleConnection() throws Exception {
	System.out.println("Oracle Connect");
        Connection conn = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";       
        String driver = "oracle.jdbc.driver.OracleDriver";
        String userName = "system";
        String password = "siva";
        try {
            Class.forName(driver).newInstance();
            conn = DriverManager.getConnection(url, userName, password);
            System.out.println("Connected to the database");
        /* conn.close();
        System.out.println("Disconnected from database");*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
	}  
}

