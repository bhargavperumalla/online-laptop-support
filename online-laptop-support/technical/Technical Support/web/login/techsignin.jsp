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

      String tuname=request.getParameter("uid");
      String pwd=request.getParameter("pwd");
      if(con==null)
      {
	con=DB.getConnection();
       }	        
       Statement st=con.createStatement();
       ResultSet rs=st.executeQuery("select password  from  tech_persons   where tuname='"+tuname+"'");
       if(rs.next())
        {
             if(pwd.equals(rs.getString(1)))
                {
                    session=request.getSession(true);
                     session.putValue ("tuname",tuname);
                     response.sendRedirect("tech_form.jsp");
                  }
               else
                 {
                      response.sendRedirect("techlogin.html");
                   }
         }
        else
                  {
                      response.sendRedirect("techlogin.html");
                   }
      }
      catch(Exception e)
       {
            out.println(e);
        }
%>



</body>
</html>





