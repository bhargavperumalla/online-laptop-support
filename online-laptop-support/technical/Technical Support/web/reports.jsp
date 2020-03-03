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
  color:green;
  text-decoration: underline;
}
</style>
</head>
<body>
 <br>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>

<br>
<table width=98% >
<tr><td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Administrator :<%=session.getValue("auname")%></strong></font></td><td align=right><a href="admin_form.jsp">BACK</a><b>&nbsp;|&nbsp;</b><a href="admin_form.jsp" ><b>HOME</b></a><b>&nbsp;|&nbsp;</b><a href="homepage.html"><b>LOGOUT</b></a> </td></tr>
</table>
<%@include file="reports.html"%>
</body>
</html>