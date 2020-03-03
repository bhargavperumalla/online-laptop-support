<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
  %>
<% 
              
              int tid = Integer.parseInt(request.getParameter("tid"));
              String tuname =(String)session.getValue("tuname");
              String tpwd = request.getParameter("tpwd");
              String tname= request.getParameter("tname");  
              String taddr = request.getParameter("taddr");
              String  tphone = request.getParameter("tphone");
              String tmail = request.getParameter("tmail");
              int mid=Integer.parseInt(request.getParameter("mid"));
              String tstatus=request.getParameter("tstatus");


              
         try
         {          
             con=DB.getConnection(); 
             con.setAutoCommit(false);   
             String que="update tech_persons set password='"+tpwd+"',tname='"+tname+"',address='"+taddr+"',phone='"+tphone+"',email='"+tmail+"' where tuname='"+tuname+"'" ;
             out.println("<br>")  ;
             Statement st=con.createStatement(); 
             st.executeUpdate(que); 
             out.println("<center><h1> Database successfully Updated</h1></center>");           
             con.commit();
                     }
        catch(Exception e){
               out.println(e);
           }	
 %>
<br>
 <center>
     <jsp:forward page="tech_form.jsp" />

</center>
</center>
</body>
</html>