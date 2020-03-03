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
      try{ 

      String auname=request.getParameter("uid");
      String pwd=request.getParameter("pwd");
      if(con==null)
      {
	con=DB.getConnection();
       }	        
       Statement st=con.createStatement();
       ResultSet rs=st.executeQuery("select password  from  adminstrator   where auname='"+auname+"'");
       if(rs.next())
        {
             if(pwd.equals(rs.getString(1)))
                {
                    session=request.getSession(true);
                     session.putValue ("auname",auname);
                     response.sendRedirect("admin_form.jsp");
                  }
               else
                 {
                      response.sendRedirect("adminlogin.html");
                   }
         }
        else
                  {
                      response.sendRedirect("adminlogin.html");
                   }
      }
      catch(Exception e)
       {
            out.println(e);
        }
%>



</body>
</html>





