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

        function checkInput()
        {
            if(ainfo.edate.value=="")
            {
                alert("** Enter Expected Date **");
                ainfo.edate.focus();
                return false; 
            }
            return true;
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
<form name="ainfo"  action="insertassignment.jsp" method="POST"  ONSUBMIT="return checkInput()"> 
<%@   page    import="java.sql.*,mybean.*"%>
<%@   page  errorPage="err.jsp"%>
<%!
    Connection con = null;
    int next_id;
    ResultSet rs, rs1, rs2;
    Statement st, st1, st2;
    int manager_id;
%>
<%
            try {
                con = DB.getConnection();
                st1 = con.createStatement();
                rs1 = st1.executeQuery("select mid from managers where   muname='" + session.getValue("muname") + "'");
            } catch (Exception e) {
                out.println(e);
            }
            try {
                if (!rs1.next()) {
                    out.println("<H1><br>Session Expired</H1>");
                } else {
                    manager_id = rs1.getInt(1);
                    st = con.createStatement();
                    rs = st.executeQuery("select max(assignment_id) from assignment");
                    if (rs.next()) {
                        next_id = rs.getInt(1) + 1;
                    } else {
                        next_id = 1;
                     }
                
%>
<img src="image/M_Dell.jpg" style="width=40%" height="20%"></img>
<img src="image/M_apple5.jpg" style="width=5%" height="20%"></img>
<img src="image/M_HP3.jpg" style="width=5%" height="20%"></img>
<img src="image/M_ibm53302.jpg" style="width=3%" height="20%"></img>
<img src="image/M_inspn640.jpg" style="width=16%" height="20%"></img>
<img src="image/ibm_laptop1.jpg" style="width=15%" height="20%"></img>
<table width="100%" border="0">
    <tr>
        <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Manager:<%=session.getValue("muname")%></strong></font></td>
    <td align=right><a href="managerbugs.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table>


<table align=center width=97%  bgcolor=white border=0 cellpadding=3 cellspacing=1 >
<tr><td  colspan=3><b><i><font face=verdana size=5px color=navyblue> <span id="mahi" style="color:rgb(200,0,10);align:center;position:absolute;left:30;padding:15;       filter:wave(freq=1 ,phase=0,strength=5"> <font face="blueprint" >
Bug  Assignment Form  </b></i>   </font></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <font size=1px color=#006388 > <b><input type="button" name="helpbutton" STYLE="background-image:url(qmark.gif); height:46px;width:45px;background-color:white; border-top-STYLE:none;border-bottom-STYLE:none;border-left-STYLE:none;border-right-STYLE:none"></b> </font></td></tr>
<tr><td colspan=3   align=center bgcolor=#b5d1ee height=25 style="font-size:14;font-family:verdana;color=#000066"><b>ASSIGN BUG....... </b>  </td></tr>
<tr><td height=15></td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Assignement-ID</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><input name=aid size=10 value=           <%= next_id%>     onfocus="document.ainfo.tid.focus()"        style="font-size:'10';font-family:verdana;background-color:#e3e4e9"></td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Bug-ID</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><input name=bid   size=15 value=<%=request.getParameter("submit")%>    style="font-size:'10';font-family:verdana;background-color:#e3e4e9"  onfocus="document.ainfo.tid.focus()"> </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Assigned To</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 >
    <select name=tid  style="width=25%;font-size:12;font-weight:bold;font-family:verdana">
        <%
         st2 = con.createStatement();
         rs2 = st2.executeQuery("select tid,tuname from tech_persons where mid=" + manager_id + " and tid IN (select tid from tech_persons where status='FREE')");
        // System.out.println("select tid,tuname from tech_persons where mid=" + manager_id + " and tid IN (select tid from tech_persons where status='FREE'");
         int count = 0;
         while (rs2.next()) {
             count = 1;
        %>
        <option value=        <%= rs2.getInt(1)%>      >    
                <%= rs2.getString(2)%> 
        </option>
        <%
         }  //end of while

         if (count == 0) {
             out.println("<br><h1> THERE R NO TECHNICAL PERSONS UNDER U </h1>");
        }%>
    </SELECT>
</TR>
<%         // Get the system date and time.
            java.util.Date utilDate = new java.util.Date();
            // Convert it to java.sql.Date
            java.sql.Date date = new java.sql.Date(utilDate.getTime());           
            
%>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Assignment Date</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td> 
<td  bgcolor=#fof4f9 ><input name="adate"   size=20 value =<%= date.toString()%>  style="font-size:'10';font-family:verdana;"> </td></tr>
<tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Expected Date</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  
<td  bgcolor=#fof4f9 ><input name="edate" size=20 style="font-size:'10';font-family:verdana;"><font color=red>*</font> </td></tr>
<tr><td height=15></td></tr>
<tr><td colspan=3 align=center><input type="submit" name="submit"  value="ASSIGN" class="buttonBg50"></td></tr>  
<tr><td height=15></td></tr>
<tr><td height=10></td></tr>
</table>
<%
                }//end of else               

            }//end of try
            catch (Exception e) {
                out.println(e);
            }
%>
</body>
</html>

