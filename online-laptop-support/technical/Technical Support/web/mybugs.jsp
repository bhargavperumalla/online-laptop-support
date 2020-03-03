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
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>

<center><font size=6pt color=#000077 face=verdana><b><i>My Bugs</i></b></font></center>
<br>
<%!  
            Connection con=null;
             ResultSetMetaData rsmd=null;
             ResultSet rs=null,rs1; 
 %>
<%
                try{
                con=DB.getConnection();
                Statement st=con.createStatement();
                rs1=st.executeQuery("select cid from customers where cuname='"+session.getValue("cuname")+"'"); 

                if(!rs1.next())
                    out.println("<h2>Session Expired</h2><br>");

                int cid= rs1.getInt(1);
                 Statement st1=con.createStatement();
                 
                 rs= st1.executeQuery("select BID, CID, PID, SEVERITY, PRIORITY, SUMMARY, DETAILS, OS_USING, POST_DATE, ASSIGNED from bug_details where cid="+cid+" order by bid");
                 rsmd=rs.getMetaData();
                }
               catch(Exception e)
                 {
                     out.println(e);
                 }
%>
<table width=98% border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Customer:<%=session.getValue("cuname")%></strong></font></td>
       <td align=right><a href="cust_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>
<center>
<table width=98% bgcolor=white cellpadding=3 cellspacing=1>               
<tr><td  colspan=12 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>LIST OF BUGS</b></td></tr>
<tr><td height=10></td></tr>
<tr>
<%
              try{
                   if(false)
                     out.println("There are No Bugs Posted by You");
                   else
                     {
                  for(int i=1;i<rsmd.getColumnCount();i++)
                  {
       
%>
                             <td  align="center"   height=20 bgcolor=#000077   style="font-weight:bold;font-size:7pt;font-family:verdana;color:white"><b><%=    rsmd.getColumnName(i) %>
	          </td></b>
<%
                    }
                String bcolor;
                boolean flag=false,flag1=true; 
                   while(rs.next())
                      {
                           if(!flag)
                              {
                                bcolor="#f0f4f9";
                                 flag=true;
                                }
                          else
                                {
                                bcolor="#e3f2eb";
                                 flag=false;
                                }
         
 %>
	<tr>
<%
                              for(int i=1;i<rsmd.getColumnCount();i++)
                                 {
                               //instead of printong the pid from bug_details table we are going to print the product name  from the products table
                                      if(i==3)
                                       {
                                                              int pid=rs.getInt(i);
                                                              Statement stt=con.createStatement();
     		                          ResultSet rss=stt.executeQuery("select pname,vendor_name from products where pid="+pid);		                               
 			        rss.next();
                                                              String pname=rss.getString(1)+"-"+rss.getString(2);
                                                              
                      %>

 <td  align="center"   height=20 bgcolor=<%=bcolor%>     style="font-weight:bold;font-size:7pt;font-family:verdana;color:#000080"><b><%=pname%></b></td>

                          <%                     
                                        }
                                     else
                                     {        //simply print the remaining details from bugdetails table because we r making adjustment for 3rd column only i.e pid but we are print product name


                                                            %>     
                                                                   <td  align="center"   height=20 bgcolor=<%=bcolor%>     style="font-weight:bold;font-size:7pt;font-family:verdana;color:#000080">
          		                                         <b> 
		                                       <%  //for date formatting 
		                                                     if(i==9)
		                                                      {
		                                        %>       
		                                                              <%= rs.getDate(i)%> 
		                                          <%
		                                                        }
					else
		                                                         {
		                                           %>
		                                                           <%= rs.getString(i)%>
		                                             <% 
		                                                         }
		                                              %>
		                                         </b>
		                                     </td>
		<%
                                            }  //end of outer else         
                                   }// end of  for
		%>
		                   </tr>                     
			<%
		                       }//end of while
                }//end of else
             }//end of try
            catch(Exception e)
             {
                 out.println(e);
              }
%>
</tr></table>

</body>
</html>