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
<table width=100% border="0">
    <tr><td   style="color:white;background-image:url(image/space3.jpg)"  height=100 width=100%>   &nbsp;&nbsp;&nbsp;&nbsp;
    <font size="5" color="white" style="font-weight:bold;font-famlily:verdana;"> OnLine LapTop Support
    <script language="JavaScript">
        printSpaces(38);
    </script>
    <tr><td>
<table width="100%" border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Customer:<%=session.getValue("cuname")%></strong></font></td>
       <td align=right><a href="cust_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>
<%@include file="cust_form.html"%>
</body>
</html>