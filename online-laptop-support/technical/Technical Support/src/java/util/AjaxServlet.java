/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;


import java.io.*;
import java.net.*;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import mybean.DB;

/**
 *
 * @author Narendra
 */
public class AjaxServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String result = "";
        String method = "";
        String filed = "";
        try {
            method = (String) request.getParameter("key");
            filed = (String) request.getParameter("key1");
            System.out.println("method:" + method + "   filed:" + filed);
            if (method.equals("getModels")) {
                result = getModels(filed);
            } else {
                System.out.println("No method not found");
            }
            
            System.out.println(result);
            out.println(result);
        } catch(Exception e){
            System.out.println(e.toString());
        }finally {
           out.close();
        }
    }

    public String getModels(String filed) throws SQLException {
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        StringBuffer str = new StringBuffer("");
        try {
            con = (Connection) DB.getConnection();
            st = (Statement) con.createStatement();
            rs = st.executeQuery("select  pid, vendor_name from products where pname='" + filed + "'");
            while (rs.next()) {
                //System.out.println(rs.getInt("pid") + ">"+ rs.getString("vendor_name") );
                str.append("<option value=" + rs.getInt("pid") + ">" + rs.getString("vendor_name") + "</option>");
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        rs.close();
        st.close();
        con.close();
        System.out.println("2..." + str.toString());        
        return str.toString();
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AjaxServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AjaxServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /** 
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
