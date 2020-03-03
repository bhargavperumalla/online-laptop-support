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
 <%@page   import="java.sql.*,mybean.*"%>
<%@page   errorPage="err.jsp"%>

<%! 
           Connection con=null;
           int mid;
  %>
<% 
                con=DB.getConnection(); 
                Statement st1=con.createStatement();
                ResultSet rs1=st1.executeQuery("select mid  from managers where muname='"+session.getValue("muname")+"'");
                if(rs1.next())
                 {
                         mid=rs1.getInt(1);
                   // out.println(mid);
                 }
                else
                 {
	     out.println("<h1>Session Expired</h1>");
                 }
             Statement st2=con.createStatement();
             ResultSet rs2=st2.executeQuery("select  tid,tname,status from tech_persons  where mid="+mid);
             ResultSetMetaData rsmd=rs2.getMetaData();

            	%>
<center>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>
</center>
<br>
<center><font size=6pt color=#000077 face=verdana><b><i>My Technical Persons</i></b></font></center>
<table width="90%" border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Manager:<%=session.getValue("muname")%></strong></font></td>
       <td align=right><a href="manager_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>   


<table align=center  bgcolor=white  border=0 cellspacing=1  width=70%>
 <tr><td  colspan=12 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>My Technical Persons</b></td></tr>
<%-- <tr bgcolor=#b5d1ee ><td height=20 colspan=3  align=middle style="font-size=9pt;font-family:verdana;color:#000080"><strong>My Technical Persons</strong></td></tr>  --%>
<!-- //empty row -->
<tr><td height=5></td></tr>
<tr  bgcolor=#000077>
<%
             for(int i=1;i<=rsmd.getColumnCount();i++)
             {
%> 
      <%--   <td  height=20 align=middle style="font-size=7pt;font-family:verdana;color:white;font-weight:bold">  --%>
           <td  align="center"   height=20 bgcolor=#000077   style="font-weight:bold;font-size:7pt;font-family:verdana;color:white"><b>
           <%=rsmd.getColumnName(i)%>
<%                       
         
             }
%>
</tr>
<!-- //empty row -->
<tr><td height=5></td></tr>
 <%
                       String bcolor;
                       for(int i=1;rs2.next();i++)
                        {
                              if(i%2==0)
                                                  bcolor="#e3f2eb";
                                      else
                                                  bcolor="#f0f4f9";
          
   %>                          <tr bgcolor=<%=bcolor%>>
                                    <%  
                                         for(int j=1;j<=rsmd.getColumnCount();j++)
                                            {
                                                         
                                    %>  <td  align="center"   height=20 bgcolor=<%=bcolor%>     style="font-weight:bold;font-size:7pt;font-family:verdana;color:#000080"><%=rs2.getString(j)%></td>
                                    <%
                                            }//eof for
                                      %>
                                   </tr>
                 <%
                         }//eof outer-for
                  %>
</table>
</body>
</html>