<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              int tid = Integer.parseInt(request.getParameter("tid"));
              String tuname = request.getParameter("tuname"); 
              String tpwd = request.getParameter("tpwd");
              String tname= request.getParameter("tname");
              String taddr = request.getParameter("taddr");
              String  tphone = request.getParameter("tphone");
              String tmail = request.getParameter("tmail");
              int mid = Integer.parseInt(request.getParameter("mid"));
              
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             PreparedStatement st=con.prepareStatement("insert into tech_persons values(?,?,?,?,?,?,?,?,?)"); 
             st.setInt(1,tid);
             st.setString(2,tuname);
             st.setString(3,tpwd);
             st.setString(4,tname); 
             st.setString(5,taddr);
             st.setString(6,tphone);
             st.setString(7,tmail);             
             st.setInt(8,mid);
             st.setString(9,"FREE");
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