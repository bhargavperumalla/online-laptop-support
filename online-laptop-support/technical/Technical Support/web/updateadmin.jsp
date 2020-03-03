<html>
<body bgcolor="navyblue">
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              String auname = request.getParameter("auname"); 
              String apwd = request.getParameter("apwd");
              String aname= request.getParameter("aname");  
              String aaddr = request.getParameter("aaddr");
              String  aphone = request.getParameter("aphone");
              String amail = request.getParameter("amail");
              
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             String que="update adminstrator set aname='"+aname+"',address='"+aaddr+"',phone='"+aphone+"',email='"+amail+"' where auname='"+auname+"'" ;
             out.println("<br>")  ;
             Statement st=con.createStatement(); 
             st.executeUpdate(que); 
             con.commit();
             out.println("<h1>DataBase Successfully UpDated</h1>");
         }
         catch(Exception e)
          {
               out.println(e);
          }	
 %>
<br>
 <center>
     <jsp:forward page="admin_form.jsp" />
</center>
</body>
</html>