using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Attendance.Controllers
{
    public class ErrorController : Controller
    {
        // GET: Error
        public ActionResult Timeout()
        {
            return View();
        }

        public ActionResult Unauthorized()
        {
            return View();
        }
    }
}