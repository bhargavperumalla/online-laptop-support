<html>
<head>
<style>
a
{
       text-decoration:none;
       color:red;
        font-size:9pt;
       font-family:verdana;
       font-weight:bold;

}
a:hover
{

  color:blue;
  text-decoration: underline;
}
</style>
</head>
<body>
<%@page  import="java.sql.*,mybean.*"%>
<%@page errorPage="err.jsp"%>
<center>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>
</center>
<center><font size=6pt color=#000077 face=verdana><b><i>MY SOLUTIONS</i></b></font></center>
<table border=0   width=98%>
<tr><td align="right"  style="font-size:7pt;font-family:verdana;color:red">Click on <b><i><font color=blue>BID</font></i></b>  to Write Comments....</td></tr>
</table>
<table width=98% border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Customer:<%=session.getValue("cuname")%></strong></font></td>
       <td align=right><a href="cust_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>
<center>
<%! 
           Connection con=null;
           PreparedStatement ps=null;
           ResultSet rs=null;
           int cid;
           int bid;
           int amount;
  %>
<% 
     
         try
         {    
            String custName=(String)session.getValue("cuname");                  
             con=DB.getConnection(); 
             con.setAutoCommit(false);   
             ps=con.prepareStatement("select cid from customers where cname=?"); 
             ps.setString(1,custName);
             rs=ps.executeQuery();
             rs.next();
             cid=rs.getInt(1);
             
             ps=con.prepareStatement("select bid from bug_details where cid=?"); 
             ps.setInt(1, cid);
             rs=ps.executeQuery();
             if(rs.next())
                                 {
             
             bid=rs.getInt(1);
             
              ps=con.prepareStatement("select amount from solutions where bid=? and paystatus=?"); 
             ps.setInt(1, bid);
              ps.setString(2,"n");
             rs=ps.executeQuery();
             rs.next();
             amount=rs.getInt(1);
              out.print("<hr>");
              out.print("<font color=green size=30>Payment Details</font><br><br>");
             out.print("<form action=custsolutions.jsp>");
             out.print("Amount:<input type=text size=6 name=txtAmount value="+ amount+">");
             out.print("<input type=hidden  name=txtBid value="+ bid+">");
             out.print("<input type=submit name=pay value=PAY style=font-weight:bold;font-size:7pt;font-family:verdana;color:red;border-top-style:none;border-bottom-style:none;border-left-style:none;border-right-style:none;background-color='#deefff';width=30pt>");
             out.print("</form>");
             
                       }
                         else{
                 response.sendRedirect("custsolutions.jsp");
                         }
        }
        catch(Exception e)
         {
           out.println(e);
          }
         finally{
             rs.close();
             ps.close();
             con.close();
             
         }
    %>
    </center>
</body>
</html>