<html>
<body>
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
              String cphone = request.getParameter("cphone");
              String cmail = request.getParameter("cmail");
              String cuname = request.getParameter("cuname"); 
              int flag=0;
         try
         {          
              con=DB.getConnection(); 
              //out.println(cuname);
              Statement st1=con.createStatement();
              ResultSet rs=st1.executeQuery("select cuname from  customers where cuname='"+cuname+"'");
               
             if(!rs.next())   //then the user is not exisiting .So we can add the new user to database
             {
               		con.setAutoCommit(false);   
		String que="insert into customers values("+cid+",'"+ cname +"','"+cpwd+"','"+caddr+"','"+cphone+"','"+cmail+"','"+cuname+"')";
                System.out.println("Query..."+que);
                Statement st2=con.createStatement(); 
	                  st2.executeUpdate(que); 
	                  out.println("<center><h1> U Have Successfully Registered</h1></center>");           
                          con.commit();
                          System.out.println("U Have Successfully Registered");           
             }
             else
             {    flag=1;
                  out.println("<font color=red><h1 >'"+cuname+"'  User Already Exists</h1></font>");                 
              }
          }//eof try 
          catch(Exception e)
          {   e.printStackTrace();
              System.out.println(e);             
          }	
    %>
  <br>
      
  <br>
<center>
    <%if(flag==0){
       response.sendRedirect("customerlogin.html");  
     }else{ %>
     <b> <a href="customerlogin.html">Login </a>
     <% }%>
</body>
</html>