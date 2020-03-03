<html>
<head>
<script language="javascript">
function setFocus()
{
        document.f1.comments.focus();
}

function checkInput()
{
        if(f1.comments.value=="")
         {
                alert("**Please type in the COMMENT**");
                 f1.comments.focus();
              return false;     
           }       
      return true;        
}

</script>
</head>
<body ONLOAD="setFocus()">
<form  name="f1" action="insertcomments.jsp"   ONSUBMIT="return checkInput()" method="post">
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

<table border="0" width="100%">
<tr><td  align=center height=50%><font size=4pt color=#000077 face=verdana><i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MY COMMENTS....</i></font> </td></tr>
</table>
<%!  
             Connection con=null;
             ResultSetMetaData rsmd=null;
             ResultSet rs=null;
             int cid;
 %>
<%

                con=DB.getConnection();
 	 //1st query
                 Statement st=con.createStatement();
                 rs=st.executeQuery("select cid from customers where cuname='"+session.getValue("cuname")+"'"); 
                 if(!rs.next())
                     out.println("<h2>Session Expired</h2><br>");
                 cid= rs.getInt(1);
                 //2nd query
                 Statement st1=con.createStatement();
                 rs= st1.executeQuery("select bug_details.bid,summary,post_date,solution_desc from solutions,bug_details,customers where bug_details.cid=customers.cid and bug_details.bid=solutions.bid and solutions.bid=" +Integer.parseInt(request.getParameter("submit")) );
                 rsmd=rs.getMetaData();
                 rs.next();
%>
<table width=99% bgcolor=white cellpadding=3 cellspacing=1>
 <tr><td  colspan=12 align=center  bgcolor=#b5d1ee height=20  style="font-size:9pt;font-family:verdana;color:#000066"><b>Bug Information</b></td></tr>
 <tr><td height=10></td></tr>
 <table>
<center>
<table border=0 align="center">
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066">Bug-ID               : <td><input name="bid"  type="text" value=<%=rs.getInt(1) %>        style="background-color:#e3e4e9"   ONFOCUS="document.f1.comments.focus()">   </td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066">Bug-Summary  : <td><textarea rows=2 cols=20    style="background-color:#e3e4e9"   ONFOCUS="document.f1.commentsments.focus()" > <%=rs.getString(2)%></textarea>   </td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066">Bug-Post-Date :</td><td><input type="text" value=<%=rs.getDate(3) %>      style="background-color:#e3e4e9"  ONFOCUS="document.f1.commentsments.focus()">   </td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066">Solution              : </td><td><textarea rows=2 cols=20    style="background-color:#e3e4e9"    ONFOCUS="document.f1.commentsments.focus()"><%=rs.getString(4)%></textarea> </td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066" colspan="2">

Does the solution had resolved your problem  ?
<br>

</font>
</td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066" colspan="2" align="right">
 
            <input type=radio name="rb" value="YES"  style="font-family:verdana">YES
            <input type=radio name="rb" value="NO"    style="font-family:verdana"> NO
</font></td></tr>
<tr><td  style="font-size:12;font-weight:bold;font-family:verdana;color=#000066" align="right">
 <font  style="font-size=9pt;font-family:verdana;">
        Comments : </td<td><textarea  name="comments"   rows=3  cols=25></textarea><font color=red>*</font>
</td></tr>
</table>
</CENTER>
<CENTER>

&nbsp;&nbsp;&nbsp;&nbsp;<input name="submitbutton"  type="submit" value="SUBMIT"  STYLE="font-size:9px;font-weight:bold;font-family:sans seriff;color:white;background-image: url(image/buttonback.gif); height:20px;width:51px;background-color:white; border-top-STYLE:none;border-bottom-STYLE:none;border-left-STYLE:none;border-right-STYLE:none">
</B>
</form>               
</body>
</html>