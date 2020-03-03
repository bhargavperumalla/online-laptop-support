<html>
<body bgcolor=navyblue>
<%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>
<%! 
           Connection con=null;
          %>
<% 
              
              
              int aid = Integer.parseInt(request.getParameter("aid"));
              int bid = Integer.parseInt(request.getParameter("bid"));  
              int tid = Integer.parseInt(request.getParameter("tid"));
              Date adate = Date.valueOf(request.getParameter("adate")); 
              Date  edate = Date.valueOf(request.getParameter("edate"));
                            
         try
         {          
              con=DB.getConnection(); 
             con.setAutoCommit(false);   
//1st query
             PreparedStatement st=con.prepareStatement("insert into assignment values(?,?,?,?,?,?)"); 
             st.setInt(1,aid);
             st.setInt(2,bid);
             st.setInt(3,tid);
             st.setDate(4,adate); 
             st.setDate(5,edate); 
             st.setString(6,"No");
             st.executeUpdate(); 
//2nd query
             Statement st1=con.createStatement();
             st1.executeUpdate("update bug_details set assigned ='Y' where bid="+bid);
//3r query
//if count of bugs reaches 4 then we have to update the status of tech_person as busy                 
             Statement st2=con.createStatement();
             ResultSet rs =st2.executeQuery( "select count(*) from assignment group by tid having tid="+tid);
             rs.next();
             if(rs.getInt(1) ==4)
             {
                  st1.executeUpdate("update tech_persons set status='BUSY' where tid="+tid);
             } 
            con.commit();
            response.sendRedirect("managerbugs.jsp");  
        }
        catch(Exception e)
         {
           out.println(e);
          }	
    %>
</body>
</html>