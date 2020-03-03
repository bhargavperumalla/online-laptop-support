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
<center><font size=6pt color=#000077 face=verdana><b><i>My Products</i></b></font></center>
<br>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>

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
                rs1=st.executeQuery("select mid from managers where muname='"+session.getValue("muname")+"'"); 

                if(!rs1.next())
                    out.println("<h2>Session Expired</h2><br>");

                int mid= rs1.getInt(1);
                 Statement st1=con.createStatement();
                 rs= st1.executeQuery("select pid,pname,vendor_name  from products  where mid="+mid+" order by pid");
                 rsmd=rs.getMetaData();
                 }
               catch(Exception e)
                 {
                     out.println(e);
                 }
%>
<table width="100%" border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Manager:<%=session.getValue("muname")%></strong></font></td>
       <td align=right><a href="manager_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>   

<center>
<table width=98% bgcolor=white cellpadding=3 cellspacing=1>               
 <tr><td  colspan=12 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>LIST OF BUGS</b></td></tr>
 <tr><td height=10></td></tr>
<tr>
<%
              try{
                  for(int i=1;i<rsmd.getColumnCount();i++)
                  {
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
                              for(int i=1;i<rsmd.getColumnCount();i++)
                                 {
                                                  if(i%2==0)   
                                                              bcolor="#fof4f9";
                                                   else
                                                              bcolor="#e3f2eb";   
%>                              <td  align="center"   height=20 bgcolor=<%=bcolor%>     style="font-weight:bold;font-size:7pt;font-family:verdana;color:#000080">
                                         <b> 
                                                 <%if(i==1){ %> <%= rs.getString(i)%> <%} else if(i==2) { %> <%= rs.getString(i)+"-"+rs.getString(i+1)%> <% } %>
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
                 out.println(e);
              }
%>
</tr></table>

</body>
</html>