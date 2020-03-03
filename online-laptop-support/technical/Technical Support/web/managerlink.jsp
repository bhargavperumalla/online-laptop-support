<html>
<% 
   out.println(request.getParameter("submit"));
  String muname=(String) session.getValue("muname");
  out.println(muname);


  if(request.getParameter("submit").equals("My Details"))
      response.sendRedirect("showmdetails.jsp");
   else if(request.getParameter("submit").equals("My Products"))
      response.sendRedirect("myproducts.jsp");
   else if(request.getParameter("submit").equals("Assigned Bugs"))
      response.sendRedirect("managerassignedbugs.jsp"); 
   else if(request.getParameter("submit").equals("Bugs To Assign"))
      response.sendRedirect("managerbugs.jsp"); 
  else if(request.getParameter("submit").equals("Tech Status"))
      response.sendRedirect("tech_status.jsp");  
  else if(request.getParameter("submit").equals("View Comments"))
      response.sendRedirect("viewcomments.jsp");  
  else if(request.getParameter("submit").equals("Logout"))
      response.sendRedirect("homepage.html");

%>
</html>