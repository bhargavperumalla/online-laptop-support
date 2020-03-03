using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Attendance.Attributes
{
    public class AuthorizationAttribute : AuthorizeAttribute
    {
        
        /// <summary>
        /// the allowed types
        /// </summary>
        readonly string[] allowedTypes;

        /// <summary>
        /// Default constructor with the allowed user types
        /// </summary>
        /// <param name="allowedTypes"></param>
        public AuthorizationAttribute(params string[] allowedTypes)
        {
            this.allowedTypes = allowedTypes;
        }

        /// <summary>
        /// Gets the allowed types
        /// </summary>
        public string[] AllowedTypes
        {
            get { return this.allowedTypes; }
        }

        /// <summary>
        /// Gets the authorize user
        /// </summary>
        /// <param name="filterContext">the context</param>
        /// <returns></returns>
        private bool AuthorizeUser(AuthorizationContext filterContext)
        {
            if (filterContext.RequestContext.HttpContext != null)
            {
                var context = filterContext.RequestContext.HttpContext;

                bool roleName = Convert.ToBoolean(context.Session["IsAdmin"]);
                return roleName;
            }
            throw new ArgumentException("filterContext");
        }

        /// <summary>
        /// The authorization override
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext == null)
                throw new ArgumentException("filterContext");
            if (!AuthorizeUser(filterContext))
            {
                string unAuthorizedUrl = new UrlHelper(filterContext.RequestContext).RouteUrl(new { controller = "Error", action = "Unauthorized" });
                filterContext.HttpContext.Response.Redirect(unAuthorizedUrl);
            }
        }
    }
}