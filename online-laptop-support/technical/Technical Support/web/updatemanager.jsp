<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              int mid = Integer.parseInt(request.getParameter("mid"));
              String muname = request.getParameter("muname"); 
              String mpwd = request.getParameter("mpwd");
              String mname= request.getParameter("mname");  
              String maddr = request.getParameter("maddr");
              String  mphone = request.getParameter("mphone");
              String mmail = request.getParameter("mmail");
              
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             String que="update managers set mname='"+mname+"',address='"+maddr+"',phone='"+mphone+"',email='"+mmail+"' where muname='"+muname+"'" ;
             out.println("<br>")  ;
             Statement st=con.createStatement(); 
             st.executeUpdate(que); 
             out.println("<center><h1> Database  Successfully Updated</h1></center>");           
             con.commit();
                     }
        catch(Exception e){
               out.println(e);
           }	
 %>
<br>
 <center>
     <jsp:forward page="manager_form.jsp" />

</center>
</center>
</body>
</html>