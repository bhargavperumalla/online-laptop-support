<html>
<% 
   out.println(request.getParameter("submit"));
  String auname=(String) session.getValue("auname");
  out.println(auname);


  if(request.getParameter("submit").equals("My Details"))
      response.sendRedirect("showadetails.jsp");
  else if(request.getParameter("submit").equals("New Product"))
      response.sendRedirect("productinfo.jsp");
  else if(request.getParameter("submit").equals("New Manager"))
      response.sendRedirect("managerinfo.jsp");
  else if(request.getParameter("submit").equals("New Tech Person"))
      response.sendRedirect("techinfo.jsp");
  else if(request.getParameter("submit").equals("Delete"))
      response.sendRedirect("deletions.html");
  else if(request.getParameter("submit").equals("Reports"))
      response.sendRedirect("reports.jsp");
   else if(request.getParameter("submit").equals("Logout"))
      response.sendRedirect("homepage.html");

%>
</html>