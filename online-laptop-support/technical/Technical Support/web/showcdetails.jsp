<html>
<head>
    <script language="javascript">

        <!-- following 2 functions is for wave property for heading use span<>   -->
        var wavePhase=0;
        function start()
        {
            window.setInterval("wave()",10);
        }

        function wave()
        {
            wavePhase++;
            mahi.filters("wave").phase=wavePhase;
        }

        <!--COLORS ON  BUTTONS   CHANGING  -->

        function changeColor(obj)
        {
            obj.style.color="red";
            obj.style.fontSize="8.5pt";
            obj.style.fontFamily="verdana";
            obj.style.fontWeight="bold";

        }

        function originalColor(obj)
        {

            obj.style.fontSize="7pt";
            obj.style.fontWeight="bold";
            obj.style.fontFamily="verdana";
            obj.style.color="rgb(0,0,100)";

        }

        var i;
        function printSpaces(n)
        {
            for(i=0;i<n;i++)
            {
                document.write("&nbsp;");
            }
        }
        function isNumberKey(evt)
        { //alert('only Digits');
       
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;

            return true;
        }
        function checkEmail(element) {

            if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(element.value)){
                return (true)
            }
            element.value="";
            alert("Invalid E-mail Address! Please re-enter.")    
            return (false)
        }
                  




    </script>
    
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
    <link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body  bgproperties="fixed"   ONLOAD="">
<form  name=cform     action="updatecustomer.jsp" method="post">
<%@   page    import="java.sql.*,mybean.*"%>
<%@   page  errorPage="err.jsp"%>
<%!    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
%>
<%
            try {
                con = DB.getConnection();
                st = con.createStatement();
                rs = st.executeQuery("select * from customers  where  cuname=" + "'" + session.getValue("cuname") + "'");
                rs.next();
            } catch (Exception e) {
                out.println(e);
            }
%>
<table align=center width=97%  bgcolor=white border="0" cellpadding=3 cellspacing=1 >
<tr><td  colspan=3>
        <table width=100%>
            <tr><td   style="color:white;background-image:url(image/space3.jpg)"  height=100 width=100%>   &nbsp;&nbsp;&nbsp;&nbsp;
            <font size="5" color="white" style="font-weight:bold;font-famlily:verdana;"> OnLine LapTop Support
            <script language="JavaScript">
                printSpaces(38);
            </script>
        </table>
</td></tr>
<tr><td  colspan=3>
        <table width="100%" border="0">
            <tr>
                <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Customer:<%=session.getValue("cuname")%></strong></font></td>
            <td align=right><a href="cust_form.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
        </table>   
</td></tr>    
<tr><td  colspan=3><b><i><font face=verdana size=5px color=navyblue> <span id="mahi" style="color:rgb(200,0,10);align:center;position:absolute;left:30;padding:15;       filter:wave(freq=1 ,phase=0,strength=5"> <font face="blueprint" >
Customer Details   </b></i>   </font></span>&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <font size=1px color=#006388 > <b><input type="button" name="helpbutton" STYLE="background-image:url(qmark.gif); height:46px;width:45px;background-color:white; border-top-STYLE:none;border-bottom-STYLE:none;border-left-STYLE:none;border-right-STYLE:none"> </b> </font></td></tr>
<tr><td colspan=3   align=center bgcolor=#b5d1ee height=25 style="font-size:14;font-family:verdana;color=#000066"><b>CUSTOMER PERSONAL DETAILS....... </b>  </td></tr>
<tr><td height=15></td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Customer&nbsp;ID</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
<td  bgcolor=#fof4f9 ><input   type=text   name=cid                                                                                                                               value= <%= rs.getString(1)%>      STYLE="font-size:'10';font-family:verdana;width=35%;background-color:#e3e4e9"    ONFOCUS="document.cform.cpwd.focus()"> </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> User&nbsp;Name</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
<td  bgcolor=#fof4f9 ><input type=text  name="cuname"                                                                                                                        value= <%= rs.getString(7)%>     STYLE="background-color:#e3e4e9;font-size:'10';font-family:verdana;width=35%"    ONFOCUS="document.cform.cpwd.focus()" >  </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> &nbsp;Password</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
<td  bgcolor=#fof4f9 > <input type="password"   name="cpwd"                                                                                                               value= <%= rs.getString(3)%>  STYLE="font-size:'10';font-family:verdana;width=35%"></td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Customer&nbsp;Name</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
<td  bgcolor=#fof4f9 ><input type=text    name="cname"                                                                                                               value= <%= rs.getString(2)%>    STYLE="font-size:'10';font-family:verdana;width=35%"> </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> &nbsp;Address</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
    
    <td  bgcolor=#fof4f9 >
        <textarea  name="caddr"  rows=3 cols=17><%= rs.getString(4)%></textarea>
</td></tr>

<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> &nbsp;Phone</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 "><b>:</b></td>
    <td  bgcolor=#fof4f9 >
<input type=text     name=cphone value=<%= rs.getString(5)%>     STYLE="font-size:'10';font-family:verdana;width=35%" onkeypress="return isNumberKey(event)"> </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> &nbsp;E-mail</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>
    
<td  bgcolor=#fof4f9 ><input type=text name="cmail" value="<%= rs.getString(6)%>" onchange="checkEmail(this)" STYLE="font-size:'10';font-family:verdana;width=80%"> </td></tr>
<tr><td height=15></td></tr>
<tr><td colspan=3 align=center><input type="submit" name="submit"  value="Save" class="buttonBg50"    </td></tr>
<tr><td height=15></td></tr>
<tr><td height=10></td></tr>
</table>
</body>
</html>

