using System.Web;
using System.Web.Mvc;

namespace Attendance.Attributes
{
    public class SessionAuthorizeAttribute : AuthorizeAttribute
    {
        private const string errorUrl = "~/Error/Timeout";

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            return httpContext.Session["UserId"] != null;
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new RedirectResult(errorUrl);
        }
    }
}