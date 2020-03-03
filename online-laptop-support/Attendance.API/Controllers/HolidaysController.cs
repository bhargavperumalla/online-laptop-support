using Attendance.DAL;
using Attendance.Model;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("v1/Holidays")]
    public class HolidaysController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        HolidaysDAL holidaysDAL = new HolidaysDAL();
        [Route(""), HttpPost]
        public HttpResponseMessage CreateHolidayList(HolidaysDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered CreateHolidayList method ");

                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.Year))
                    ModelState.AddModelError("Year", "Year is required");


                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                log.Info("Creating HolidayList in database ");

                int res = holidaysDAL.SaveHolidayList(model);

                log.Info("Creating HolidayList in database completed .Returning the status object ");
                string error = string.Empty;
                if (res == -1) error = "Holiday List already exists";

                if (!string.IsNullOrEmpty(error))
                {
                    log.Debug($"Errors:{error}");
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
               
                status = new Status("OK", null, model);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("CreateHolidayList method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route("{Year}"), HttpGet]
        public HttpResponseMessage Holidays(string Year)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Holidays Method ");
                log.Info("Getting HolidayList from database ");
                List<Holidays> res = holidaysDAL.GetHolidays(Year);
                log.Info("Getting HolidayList from database is completed.Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<Holidays>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("Holidays method Elapsed - " + stopwatch.Elapsed);
            }

        }

    }
}