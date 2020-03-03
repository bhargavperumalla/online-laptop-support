<html>
<body  bgcolor="navyblue">
<center>
<%@page  import="java.sql.*,mybean.*,javax.servlet.http.*"%>
<%@page  errorPage="err.jsp"%>
<%!
       Connection con=null;
       HttpSession session=null;
%>

<%

      String uid=request.getParameter("uid");
      String pwd=request.getParameter("pwd");
      if(con==null)
      {
	con=DB.getConnection();
       }	        
       Statement st=con.createStatement();
       ResultSet rs=st.executeQuery("select password  from  customers   where cuname='"+uid+"'");
       if(rs.next())
         {
              if(pwd.equals(rs.getString(1)))
               {
                 session=request.getSession(true);
                 session.putValue ("cuname",uid);
                 response.sendRedirect("cust_form.jsp");
                }
             else
               {
                      response.sendRedirect("customerlogin.html");
                 }
           }
        else
                {   
                      response.sendRedirect("customerlogin.html");
                 }                      
      
%>
</body>
</html>





