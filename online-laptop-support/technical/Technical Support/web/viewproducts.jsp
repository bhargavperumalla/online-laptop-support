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

<br>
<font size=6pt color=#000077 face=verdana><b><i>Products List</i></b></font></center>
<table width=98% >
<tr><td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Administrator :<%=session.getValue("auname")%></strong></font></td><td align=right><a href="reports.html">BACK</a><b>&nbsp;|&nbsp;</b><a href="admin_form.jsp"  ><b>HOME</b></a><b>&nbsp;|&nbsp;</b><a href="homepage.html"><b>LOGOUT</b></a> </td></tr>
</table>

<center>
 <table width=98% bgcolor=white cellpadding=3 cellspacing=1>               
 <tr><td  colspan=12 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>LIST OF PRODUCTS</b></td></tr>
 <tr><td height=10></td></tr>
<%!  
            Connection con=null;
            ResultSet rs=null; 
            ResultSetMetaData rsmd=null;
 %>
<%
               try
               {
                con=DB.getConnection();
                Statement st=con.createStatement();
                rs=st.executeQuery("select PID, PNAME,VENDOR_NAME, MID from products"); 
                rsmd=rs.getMetaData();

%>
<tr  bgcolor=#000077>
<%
             for(int i=1;i<=rsmd.getColumnCount();i++)
             {
%> 
          <td  align="center"   height=20 bgcolor=#000077   style="font-weight:bold;font-size:9pt;font-family:verdana;color:white">
         <% if(i==3) { } else { %>   <%=rsmd.getColumnName(i)%> <% } %>
<%                       
         
             }
%>
</tr>
<!-- //empty row -->
<tr><td height=5></td></tr>
         <%
                        String bcolor;
                       for(int i=1;rs.next();i++)
                        {
                              if(i%2==0)
                                                  bcolor="#e3f2eb";
                                      else
                                                  bcolor="#f0f4f9";
          
                            %>      
                                     <tr bgcolor=<%=bcolor%>>
                                    <%  
                                         for(int j=1;j<=rsmd.getColumnCount();j++)
                                            {
                                                         
                                    %>  <td height=20  align=middle style="font-weight:bold;font-size:8pt;font-family:verdana;color:#000080">
                                       <% if(j==2) { %> <%=rs.getString(j)+"-"+rs.getString(j+1)%>  <% }else if(j==3) { } else {%> <%=rs.getString(j)%> <% } %>  
                                  </td>
                                    <%
                                            }//eof for
                                      %>
                                   </tr>
                 <%
                         }//eof outer-for
               }//eof try
               catch(Exception e)
               {
                              out.println(e);
               }
%>
</table>
</body>
</html>
