using Attendance.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web;
using System.Web.Mvc;

namespace Attendance.Controllers
{
    public class BaseController : Controller
    {
        protected JsonMediaTypeFormatter _jsonMediaTypeFormatter = new JsonMediaTypeFormatter
        {
            SerializerSettings =
            {
                NullValueHandling = NullValueHandling.Ignore,
                DefaultValueHandling = DefaultValueHandling.Ignore
            }
        };

        protected List<string> GetModelStateErrors()
        {

            List<string> errors = ModelState
                .SelectMany(x => x.Value.Errors)
                .Select(x => x.ErrorMessage)
                .ToList();

            return errors
                .Select(x => errors.Count(y => y == x) > 1 ? string.Format("{0} ({1}x)", x, errors.Count(y => y == x)) : x)
                .Distinct()
                .ToList();
        }

        /// <summary>
        /// For errors.
        /// </summary>
        /// <returns></returns>
        protected JsonResult BadPayload()
        {
            List<string> errors = new List<string>();
            errors.Add("The provided payload is invalid.Please verify the payload data format");
            Status badstatus = new Status("BadRequest", errors);
            return Json(badstatus, JsonRequestBehavior.AllowGet);
        }
    }
}