var xmlreq;
function newXMLHttpRequest() {
    var xmlreq = false;
    if(window.XMLHttpRequest) {
        xmlreq = new XMLHttpRequest();
    } else if(window.ActiveXObject) {
        try {
             xmlreq = new ActiveXObject("MSxm12.XMLHTTP");
        } catch(e1) {
            try {
                 xmlreq = new ActiveXObject("Microsoft.XMLHTTP");
             } catch(e2) {
                 xmlreq = false;
             }
        }
    }
    return xmlreq;
}
function readyStateHandlerText(req,responseTextHandler){
    return function() {
        if (req.readyState == 4) {
            if (req.status == 200) {
               // alert(req.responseText);
                responseTextHandler(req.responseText);

            } else {
                alert("HTTP error"+req.status+" : "+req.statusText);
            }
        }
    }
}
function getAjaxValue(field, method){            
            xmlHttp=newXMLHttpRequest();
            if (xmlHttp==null)
            {
            alert ("Your browser does not support AJAX!");
            return;
            }
            if (method == "getModels"){
            var get = getModels(field);
            //alert(get);
            }
            
            var url = "./AjaxServlet?"+get;
            //alert(url);
            xmlHttp.onreadystatechange=readyStateHandlerText(xmlHttp,populateModels);
            xmlHttp.open("GET",url,true);
            //alert("request completed in Ajax Select")
            xmlHttp.send(null);

};
function getModels(field){
	var brandName = document.getElementById('brandName').value;
	return "key=getModels&key1="+brandName;
}

function populateModels(resp){
              var result=resp;
              document.getElementById('pid').innerHTML=result;
              //alert(result);
};
