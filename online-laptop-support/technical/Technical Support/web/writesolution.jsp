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
   	if(sinfo.sdesc.value=="")
        	{
	   alert("** Provide Solution **");
	   sinfo.sdesc.focus();
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
<form name="sinfo"  action="insertsolution.jsp" method="POST"  ONSUBMIT="return checkInput()">
<%@   page    import="java.sql.*,mybean.*"%>
<%@   page  errorPage="err.jsp"%>
<%! 
          Connection con=null ;
          int next_id;
          ResultSet rs;   
          Statement st;
%>
<%
//alter table solutions add amount number(5);
//alter table solutions add paystatus varchar2(1) default 'n';
           try
          { 
            con=DB.getConnection();
            st=con.createStatement(); 
            rs=st.executeQuery("select max(sid) from solutions");
            if(rs.next())
              next_id=rs.getInt(1)+1;
          else 
            next_id=1;
            }
          catch(Exception e)
         {
               out.println(e);
          }
%>  
<table width=100%>
 <tr><td   style="color:white;background-image:url(image/space3.jpg)"  height=100 width=100%>   &nbsp;&nbsp;&nbsp;&nbsp;
               <font size="5" color="white" style="font-weight:bold;font-famlily:verdana;"> OnLine LapTop Support  
<script language="JavaScript">
                 printSpaces(38);
</script>
 </table>
 <table width="100%" border="0">
<tr>
    <td><font style="font-size=9pt;font-family:verdana;color:orange"><strong>Technical Person :<%=session.getValue("tuname")%></strong></font></td>
       <td align=right><a href="techmybugs.jsp">BACK</a><b>&nbsp;|&nbsp;<a href="homepage.html"><b>LOGOUT</b></a>|&nbsp;<a href="help.html"><b>HELP</b></a> </td></tr>
</table> 
  <table align=center width=97%  bgcolor=white border=0 cellpadding=3 cellspacing=1 >
   <tr><td  colspan=3><b><i><font face=verdana size=5px color=navyblue> <span id="mahi" style="color:rgb(200,0,10);align:center;position:absolute;left:30;padding:15;       filter:wave(freq=1 ,phase=0,strength=5"> <font face="blueprint" >
                     Solution  Form  </b></i></font></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <font size=1px color=#006388 > <b><input type="button" name="helpbutton" STYLE="background-image:url(qmark.gif); height:46px;width:45px;background-color:white; border-top-STYLE:none;border-bottom-STYLE:none;border-left-STYLE:none;border-right-STYLE:none"> </b> </font></td></tr>
   <tr><td colspan=3   align=center bgcolor=#b5d1ee height=25 style="font-size:14;font-family:verdana;color=#000066"><b>SOLUTION FORM....... </b>  </td></tr>
   <tr><td height=15></td></tr>
   <tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Solutiont-ID</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><input name=sid size=10 value=  <%= next_id  %>  onfocus="document.sinfo.sdesc.focus()"   style="font-size:'10';font-family:verdana;background-color:#e3e4e9"> </td></tr>
   <tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Bug-ID</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><input name="bid"  size=15  value="<%=Integer.parseInt(request.getParameter("submit")) %>"    onfocus="document.sinfo.sdesc.focus()"   style="font-size:'10';font-family:verdana;background-color:#e3e4e9"> </td></tr>
   <tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Solution Description</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><textarea name="sdesc"  rows=3 cols=35   style="font-size:'10';font-family:verdana"></textarea><font color=red>*</font></td></tr>
   <tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Priority</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><select  name="priority"><option>Low</option><option>Medium</option><option>High</option></select></td></tr>
    <tr><td width=39%  bgcolor=#fof4f9 style="font-size:12;font-weight:bold;font-family:verdana;color=#000066"> Amount</td><td width=10% align=center  bgcolor=#fof4f9 style="font-size:10;font-weight:bold;font-family:verdana;color=#000066 " ><b>:</b></td>  <td  bgcolor=#fof4f9 ><input  name="txtAmount"></td></tr>
   <tr><td height=15></td></tr>
   <tr><td colspan=3 align=center><input type="submit" name="submit"  value="SUBMIT" class="buttonBg50">  </td></tr>  
   <tr><td height=15></td></tr>
   <tr><td height=10></td></tr>
</table>
</body>
</html>

