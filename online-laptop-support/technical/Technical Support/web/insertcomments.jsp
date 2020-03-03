<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
      %>
<% 
              
              int bid = Integer.parseInt(request.getParameter("bid"));
              String resolved= request.getParameter("rb");  
              String comments = request.getParameter("comments");
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             
             PreparedStatement st=con.prepareStatement("insert into comments values(?,?,?)"); 
             st.setInt(1,bid);
             st.setString(2,resolved);
             st.setString(3,comments);
             st.executeUpdate(); 
             con.commit();
             response.sendRedirect("custsolutions.jsp");  
             }
        catch(Exception e)
          {
               out.println(e);
           }	
 %>
</body>
</html>