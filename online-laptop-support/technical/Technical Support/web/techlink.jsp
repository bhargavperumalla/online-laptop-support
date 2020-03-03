<html>
<% 
   out.println(request.getParameter("submit"));
  String tuname=(String) session.getValue("tuname");
  out.println(tuname);


  if(request.getParameter("submit").equals("My Details"))
      response.sendRedirect("showtdetails.jsp");
   else if(request.getParameter("submit").equals("My Bugs"))
     response.sendRedirect("techmybugs.jsp"); 
  else if(request.getParameter("submit").equals("Logout"))
      response.sendRedirect("homepage.html");

%>
</html>