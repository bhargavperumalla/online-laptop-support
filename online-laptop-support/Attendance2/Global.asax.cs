using System;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using log4net;

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
            log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo("log4net.config"));
        }

    }
}
