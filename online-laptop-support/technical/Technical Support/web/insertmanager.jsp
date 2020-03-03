<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              int mid = Integer.parseInt(request.getParameter("mid"));
              String muname = request.getParameter("muname"); 
              String mpwd = request.getParameter("mpwd");
              String mname= request.getParameter("mname");
              String maddr = request.getParameter("maddr");
              String  mphone = request.getParameter("mphone");
              String mmail = request.getParameter("mmail");
              
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             PreparedStatement st=con.prepareStatement("insert into managers values(?,?,?,?,?,?,?)"); 
             st.setInt(1,mid);
             st.setString(2,muname);
             st.setString(3,mpwd);
             st.setString(4,mname); 
             st.setString(5,maddr);
             st.setString(6,mphone);
             st.setString(7,mmail);             
             st.executeUpdate(); 
             con.commit();
              response.sendRedirect("admin_form.jsp");  
        }
        catch(Exception e)
         {
           out.println(e);
          }	
    %>
</body>
</html>