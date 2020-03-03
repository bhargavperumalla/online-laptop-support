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
    
     return getOracleConnection();
    }
    
	public static Connection getOracleConnection() throws Exception {
	System.out.println("Oracle Connect");
        Connection conn = null;
        String url = "jdbc:oracle:thin:@localhost:1521:XE";       
        String driver = "oracle.jdbc.driver.OracleDriver";
        String userName = "system";
        String password = "bhargav";
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

