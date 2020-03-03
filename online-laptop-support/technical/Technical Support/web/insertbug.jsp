<html>
<body bgcolor=navyblue>
 <%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>

<%! 
           Connection con=null;
  %>
<% 

              int bid = Integer.parseInt(request.getParameter("bid"));
              int pid = Integer.parseInt(request.getParameter("pid"));
              String severity= request.getParameter("severity");
              String priority = request.getParameter("priority");
              String  summary = request.getParameter("summary");
              String details = request.getParameter("details");
              String os = request.getParameter("os");
              String softies = request.getParameter("softies");
             // String file = request.getParameter("file");
              System.out.println(bid+" "+pid+" "+severity+" "+priority+" "+summary+" "+details+" "+os+" "+softies);
         try
         {          
             con=DB.getConnection(); 
             con.setAutoCommit(false);   
             PreparedStatement ps=con.prepareStatement("insert into bug_details values(?,?,?,?,?,?,?,?,?,?,?,?)"); 
             ps.setInt(1,bid);
             Statement st=con.createStatement(); 
             ResultSet rs=st.executeQuery("select  cid from customers where cuname='" +session.getValue("cuname")+"'");
             if(!rs.next())
                 out.println("Ur Session Expired<br>");
             ps.setInt(2,rs.getInt(1));
             ps.setInt(3,pid);
             ps.setString(4,severity); 
             ps.setString(5,priority);
             ps.setString(6,summary);
             ps.setString(7,details);             
             ps.setString(8,os);
             ps.setString(9,null);
             ps.setString(10,null); 
             // Get the system date and time.
            java.util.Date utilDate = new java.util.Date();
            // Convert it to java.sql.Date
            java.sql.Date date = new java.sql.Date(utilDate.getTime());           
             ps.setDate(11,date);
             ps.setString(12,"N" );             
             ps.executeUpdate(); 
             con.commit();
             response.sendRedirect("cust_form.jsp");
          
        }
        catch(Exception e)
         {
           out.println(e);
          }	
    %>
    <jsp:forward page="cust_form.jsp" />
</body>
</html>