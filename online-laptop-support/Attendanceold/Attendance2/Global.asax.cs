using System.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace Attendance
{
    public class MvcApplication : System.Web.HttpApplication
    {
        public static string APIBaseUrl { get; private set; }
        public static string APIToken { get; private set; }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RouteConfig.RegisterRoutes(RouteTable.Routes);

            APIBaseUrl = ConfigurationManager.AppSettings["APIBaseUrl"];
            APIToken = ConfigurationManager.AppSettings["APIToken"];
        }
    }
}
