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

      String muname=request.getParameter("uid");
      String pwd=request.getParameter("pwd");
      if(con==null)
      {
	con=DB.getConnection();
       }	        
       Statement st=con.createStatement();
       ResultSet rs=st.executeQuery("select password  from  managers   where muname='"+muname+"'");
       if(rs.next())
        {
             if(pwd.equals(rs.getString(1)))
                {
                    session=request.getSession(true);
                     session.putValue ("muname",muname);
                     response.sendRedirect("manager_form.jsp");
                  }
               else
                 {
                      response.sendRedirect("managerlogin.html");
                   }
         }
        else
       {
                      response.sendRedirect("managerlogin.html");
        }
      }
      catch(Exception e)
       {
            out.println(e);
        }
%>



</body>
</html>





