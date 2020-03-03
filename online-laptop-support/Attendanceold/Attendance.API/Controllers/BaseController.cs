using Attendance.Model;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    public class BaseController : ApiController
    {
        protected JsonMediaTypeFormatter _jsonMediaTypeFormatter = new JsonMediaTypeFormatter
        {
            SerializerSettings = {
                NullValueHandling = NullValueHandling.Ignore, DefaultValueHandling = DefaultValueHandling.Ignore
            }
        };

        protected List<string> GetModelStateErrors()
        {
            List<string> errors = ModelState.SelectMany(x => x.Value.Errors)
                .Select(x => x.ErrorMessage)
                .ToList();

            return errors.Select(x => errors.Count(y => y == x) > 1 ? string.Format("{0} ({1}x)", x, errors.Count(y => y == x)) : x)
                .Distinct().ToList();
        }

        /// <summary>
        /// For errors.
        /// </summary>
        /// <returns></returns>
        protected HttpResponseMessage BadPayload()
        {
            List<string> errors = new List<string>
            {
                "The provided payload is invalid.Please verify the payload data format"
            };
            Status badstatus = new Status("BadRequest", errors);
            return Request.CreateResponse(HttpStatusCode.OK, badstatus, _jsonMediaTypeFormatter);
        }
    }
}
