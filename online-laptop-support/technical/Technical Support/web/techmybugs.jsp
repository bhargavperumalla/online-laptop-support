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
<form name="tform"     action="writesolution.jsp">
<%@page  import="java.sql.*,mybean.*"%>
<%@page errorPage="err.jsp"%>
<center>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>

<br>
<center><font size=6pt color=#000077 face=verdana><b><i>My Bugs</i></b></font></center>
<table border=0   width=98%>
<tr><td align="right"  style="font-size:7pt;font-family:verdana;color:red">Click on <b><i><font color=blue>BID</font></i></b>  to Provide Solution</td></tr>
</table>   
<%!  
            Connection con=null;
             ResultSetMetaData rsmd=null;
             ResultSet rs=null,rs1; 
 %>
<%
                try{
                con=DB.getConnection();
                Statement st=con.createStatement();
                rs1=st.executeQuery("select tid from tech_persons where tuname='"+session.getValue("tuname")+"'"); 

	if(!rs1.next())
	            out.println("<h2>Session Expired</h2><br>");

	int tid= rs1.getInt(1);

                  Statement stt=con.createStatement();
	rs= stt.executeQuery("select bug_details.*,expected_date from bug_details,assignment  where assignment.bid =bug_details.bid and solved!='YES' and tid="+tid+" order by assignment.bid");
                  if(rs.next()==false)
                  {
  %>
		<script language="javascript">
		alert("***Sorry No BUGs Posted ***");
		 </script>

<%                 }

                
                 else
                  { 
	Statement st1=con.createStatement();
	rs= st1.executeQuery("select bug_details.BID, bug_details.CID, bug_details.PID, bug_details.SEVERITY, bug_details.PRIORITY, bug_details.SUMMARY, bug_details.DETAILS, bug_details.OS_USING, bug_details.POST_DATE, bug_details.ASSIGNED,expected_date from bug_details,assignment  where assignment.bid =bug_details.bid and solved!='YES' and tid="+tid+" order by assignment.bid");
	rsmd=rs.getMetaData();
                 }//eof else
                 }//eof try
               catch(Exception e)
                 {
                     out.println(e);
                 }
%>
<table width="98%" border="0">
    <tr><td>&nbsp;&nbsp;<font style="font-size=9pt;font-family:verdana;color:orange"><strong>Technical Person:<%=session.getValue("tuname")%></strong></font></td><td align=right><a href="tech_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="signout.jsp"><b>LOGOUT</b></a> </td></tr>
</table>

<center>
<table width=98% bgcolor=white cellpadding=3 cellspacing=1>               
 <tr><td  colspan=13 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>LIST OF BUGS</b></td></tr>
 <tr><td height=10></td></tr>
<tr>
<%
              try{
                  for(int i=1;i<=rsmd.getColumnCount();i++)
                  {
                      if(i==12) continue;
%>
                             <td  align="center"   height=20 bgcolor=#000077   style="font-weight:bold;font-size:7pt;font-family:verdana;color:white"><b><%=    rsmd.getColumnName(i) %>
	          </td></b>
<%
                    }
                String bcolor;
                   while(rs.next())
                      {
 %>
	<tr>
<%
                              for(int i=1;i<=rsmd.getColumnCount();i++)
                                 {
                                                 if(i==12)
                                                    continue; 
                                                 if(i%2==0)   
                                                              bcolor="#fof4f9";
                                                   else
                                                              bcolor="#e3f2eb";  

 
%>                              <td  align="center"   height=20 bgcolor=<%=bcolor%>     style="font-weight:bold;font-size:7pt;font-family:verdana;color:#000080">
                                         <b>
                                         <%
                   //1st colum is buttons with bgcolor=green and no border
	                                   if(i==1)
                                                        {
                                           %>
                                                  <input    type="submit" name="submit" value= <%= rs.getString(i)%>  style="font-weight:bold;font-size:7pt;font-family:verdana;color:red;border-top-style:none;border-bottom-style:none;border-left-style:none;border-right-style:none;background-color='yellow';width=20px"   >
                                      <%                  continue;
                                                        }
                                      %>
                                       <% //for date formatting 
                                                     if(i==9 || i==11)
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
<%                           }// end of  for
%>
                   </tr>                     
<%
                       }//end of while
             }//end of try
            catch(Exception e)
             {
              //   out.println(e);
              }
%>
</tr>
</table>
</form>
</body>
</html>