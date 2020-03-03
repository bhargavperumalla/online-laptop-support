using Attendance.Model;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text.RegularExpressions;
using System.Web.Http;
using System.Web.Http.Controllers;

namespace Attendance.API.Controllers
{
    public class TokenAuthenticationAttribute : AuthorizeAttribute
    {
        protected JsonMediaTypeFormatter _jsonMediaTypeFormatter = new JsonMediaTypeFormatter
        {
            SerializerSettings =
            {
                NullValueHandling = NullValueHandling.Ignore,
                DefaultValueHandling = DefaultValueHandling.Ignore
            }
        };

        public override void OnAuthorization(HttpActionContext actionContext)
        {
           
            var securityToken = GetAccountToken(actionContext.Request);
                if (securityToken == "")
            {
                List<string> errors = new List<string>();
                errors.Add("Missing authorization token in header");             
                Status status = new Status("Unauthorized", errors);
                actionContext.Response = actionContext.Request.CreateResponse(System.Net.HttpStatusCode.Unauthorized, status, _jsonMediaTypeFormatter);
            }
            else if (securityToken != System.Configuration.ConfigurationManager.AppSettings["AccountSecurityToken"].ToString())
            {
                List<string> errors = new List<string>();
                errors.Add( "The authorization token is not valid for the given account") ;
                Status status = new Status("Unauthorized", errors);
                actionContext.Response = actionContext.Request.CreateResponse(System.Net.HttpStatusCode.Unauthorized, status, _jsonMediaTypeFormatter);
            }
        }

        protected string GetAccountToken(HttpRequestMessage request)
        {
            if (request.Headers.Contains("Authorization"))
            {
                string authValue = request.Headers.GetValues("Authorization").FirstOrDefault();                
                return !string.IsNullOrWhiteSpace(authValue) ? Regex.Replace(authValue, "Bearer ", string.Empty, RegexOptions.IgnoreCase) : string.Empty;
            }
            else
                return string.Empty;
        }
    }
}