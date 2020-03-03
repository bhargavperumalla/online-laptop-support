<html>
<% 
   out.println(request.getParameter("submit"));
  String cuname=(String) session.getValue("cuname");
  out.println(cuname);


  if(request.getParameter("submit").equals("My Details"))
      response.sendRedirect("showcdetails.jsp");
   else if(request.getParameter("submit").equals("My Bugs"))
      response.sendRedirect("mybugs.jsp");
   else if(request.getParameter("submit").equals("Post New Bug"))
      response.sendRedirect("buginfo.jsp");
else if(request.getParameter("submit").equals("My Solutions"))
     // response.sendRedirect("custsolutions.jsp");
    response.sendRedirect("PayAmount.jsp");
   else if(request.getParameter("submit").equals("Logout"))
      response.sendRedirect("homepage.html");

%>
</html>