<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              int cid = Integer.parseInt(request.getParameter("cid"));
              String cname= request.getParameter("cname");
              String cpwd = request.getParameter("cpwd");
              String caddr = request.getParameter("caddr");
              String  cphone = request.getParameter("cphone");
              String cmail = request.getParameter("cmail");
              String cuname = request.getParameter("cuname"); 
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
             String que="update customers set password='"+cpwd+"',cname='"+cname+"',address='"+caddr+"',phone='"+cphone+"',email='"+cmail+"' where cuname='"+cuname+"'" ;
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
     <jsp:forward page="cust_form.jsp" />
</center>
</center>
</body>
</html>