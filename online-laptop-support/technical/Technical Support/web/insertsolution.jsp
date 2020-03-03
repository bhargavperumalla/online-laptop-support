<html>
<body>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
           int tid;
  %>
<% 

              int sid = Integer.parseInt(request.getParameter("sid"));
              int bid = Integer.parseInt(request.getParameter("bid"));
              String sdesc= request.getParameter("sdesc");
              String priority = request.getParameter("priority");
               String amount = request.getParameter("txtAmount");
              
         try
         {          
             con=DB.getConnection(); 
             con.setAutoCommit(false);   
             PreparedStatement ps=con.prepareStatement("insert into solutions(SID,BID,TID,SOLUTION_DESC,SOLUTION_DATE,PRIORITY,AMOUNT) values(?,?,?,?,?,?,?)"); 
             ps.setInt(1,sid);
             ps.setInt(2,bid);
             Statement st=con.createStatement(); 
             ResultSet rs=st.executeQuery("select  tid from tech_persons where tuname='" +session.getValue("tuname")+"'");
             
             if(!rs.next())
                 out.println("Ur Session Expired<br>");
             tid=rs.getInt(1);
             ps.setInt(3,tid);
             ps.setString(4,sdesc); 

            
             
  // Get the system date and time.
            java.util.Date utilDate = new java.util.Date();
            // Convert it to java.sql.Date
            java.sql.Date date = new java.sql.Date(utilDate.getTime());           
            ps.setDate(5,date);
             ps.setString(6,priority);
             ps.setString(7, amount);
             ps.executeUpdate(); 



   // after providing the solutions   the status of the tech_person must be made free

             Statement st3=con.createStatement();
             Statement st4=con.createStatement();
             Statement st5=con.createStatement(); 


             ResultSet rs3 =st3.executeQuery( "select count(*) from assignment group by tid having tid="+tid);
             rs3.next();
             if(rs3.getInt(1) ==4)
             {
                             st4.executeUpdate("update tech_persons set status='FREE' where tid="+tid);
             } 
             st5.executeUpdate( "update assignment  set solved='YES' where bid="+bid);
             con.commit();
             response.sendRedirect("techmybugs.jsp");
        }
        catch(Exception e)
         {
           out.println(e);
          }	
    %>
</body>
</html>